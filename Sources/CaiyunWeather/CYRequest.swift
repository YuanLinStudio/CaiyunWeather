//
//  CYRequest.swift
//  
//
//  Created by 袁林 on 2021/6/12.
//

import Foundation

public class CYRequest {
    
    /// The `CYEndpoint` object to which the request is sent to.
    public lazy var endpoint = CYEndpoint()
    
    /// The URL that saves API response cache.
    public lazy var localContentUrl: URL = getDefaultLocalContentUrl()
    
    /// The expiration, that is, the minimum time interval for URL request for the same condinate. In second.
    public let expiration: TimeInterval = 5 * 60
    
    /// The queue on which the request is performed
    public var queue: DispatchQueue = DispatchQueue.global(qos: .background)
    
    /// Perform an action to request data.
    ///
    /// If the data from local cache will be used if:
    /// - it is for same Coordinate; and
    /// - it is not expired (use `CYRequest.expiration` to define the period of validation)
    ///
    /// Elsewise, a new data will be requested from remote API.
    open func perform(completionHandler: @escaping (CYResponse?, Error?) -> Void) {
        request(from: .local) { [self] response, error in
            if let response = response, error == nil {
                if validate(response) {
                    completionHandler(response, nil)
                }
                else {
                    request(from: .remote, completionHandler: completionHandler)
                }
            }
            else {
                request(from: .remote, completionHandler: completionHandler)
            }
        }
    }
    
    public enum DataSource: Equatable {
        case local
        case remote
    }
}

// MARK: - Work with request for CYResponse

extension CYRequest {
    
    /// request for `CYResponse`.
    public func request(from dataSource: DataSource, completionHandler: @escaping (CYResponse?, Error?) -> Void) {
        let actuator: (@escaping (Data?, Error?) -> Void) -> Void = {
            switch dataSource {
            case .remote:
                return fetchDataFromRemote
            case .local:
                return fetchDataFromLocal
            }
        }()
        
        queue.async { [self] in
            actuator { data, error in
                guard let data = data else {
                    completionHandler(nil, error)
                    return
                }
                decode(data, completionHandler: completionHandler)
            }
        }
    }
}

// MARK: - Work with data

extension CYRequest {
    
    /// Explicitly fetch data.
    public func fetchData(from dataSource: DataSource, completionHandler: @escaping (Data?, Error?) -> Void) {
        switch dataSource {
        case .remote:
            fetchDataFromRemote(completionHandler: completionHandler)
        case .local:
            fetchDataFromLocal(completionHandler: completionHandler)
        }
    }
    
    /// Explicitly fetch data from API.
    func fetchDataFromRemote(completionHandler: @escaping (Data?, Error?) -> Void) {
        queue.async { [self] in
            guard endpoint.token != nil else {
                completionHandler(nil, CYError.tokenIsNil)
                return
            }
            
            URLSession.shared.dataTask(with: endpoint.url) { (data, _, error) in
                completionHandler(data, error)
                
                if let data = data {
                    // save a copy to local
                    try? saveDataToLocal(data)
                }
            }
            .resume()
        }
    }
    
    /// Explicitly fetch data from local caches.
    func fetchDataFromLocal(completionHandler: @escaping (Data?, Error?) -> Void) {
        queue.async { [self] in
            do {
                let data = try readDataFromLocal()
                completionHandler(data, nil)
            }
            catch let error {
                completionHandler(nil, error)
            }
        }
    }
    
    /// Explicitly fetch data from example file.
    func fetchExampleData(completionHandler: @escaping (Data?, Error?) -> Void) {
        queue.async {
            guard let url = Bundle.module.url(forResource: "Weather", withExtension: "json") else {
                completionHandler(nil, CYError.fileDontExist)
                return
            }
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                completionHandler(data, nil)
            }
            catch let error {
                completionHandler(nil, error)
            }
        }
    }
}

// MARK: - Local data caches management

extension CYRequest {
    
    /// URL for local data cache, as `<CYRequest.localContentUrl>/<CYRequest.endpoint.coordinate.urlString>`
    public var localFileUrl: URL { return getFileUrl(forCoordinate: endpoint.coordinate) }
    
    /// Save some content to local, URL of `<CYRequest.localContentUrl>/<CYCoordinate.urlString>`.
    func saveDataToLocal(_ data: Data) throws {
        try data.write(to: localFileUrl, options: .atomic)
    }
    
    /// Read some content from local, URL of `<CYRequest.localContentUrl>/<CYCoordinate.urlString>`.
    func readDataFromLocal() throws -> Data {
        return try Data(contentsOf: localFileUrl)
    }
    
    /// get URL as `<CYRequest.localContentUrl>/<CYCoordinate.urlString>`.
    func getFileUrl(forCoordinate: CYCoordinate) -> URL {
        let filename: String = endpoint.coordinate.urlString
        let fileUrl = localContentUrl.appendingPathComponent(filename)
        return fileUrl
    }
}

// MARK: - Decoding and Validating

extension CYRequest {
    
    /// Decode the data. May result in `CYResponse`, `CYInvalidResponse`, or cannot decode.
    /// Resulting in `CYInvalidResponse` means there's some error with your token, so the `error` return will be `CYError.invalidResponse(description: invalidResponse.error)`.
    public func decode(_ data: Data, completionHandler: @escaping (CYResponse?, CYError?) -> Void) {
        queue.async {
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(CYResponse.self, from: data) {
                completionHandler(response, nil)
            }
            else if let invalidResponse = try? decoder.decode(CYInvalidResponse.self, from: data) {
                completionHandler(nil, .invalidResponse(description: invalidResponse.error))
            }
            else {
                completionHandler(nil, .invalidResponse(description: "unexpected result"))
            }
        }
    }
    
    func validate(_ response: CYResponse) -> Bool {
        let responseTime = response.serverTime.time
        let intervalTillNow = -responseTime.timeIntervalSinceNow
        return intervalTillNow <= expiration
    }
}

// MARK: - Default generator for Local Content URL

/// A default generator for `CYRequest.localContentUrl`. The URL will be `cachesDirectory`.
fileprivate func getDefaultLocalContentUrl() -> URL {
    let destination: URL = Bundle.module.bundleURL
    let cacheUrl: URL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: destination, create: true)
    return cacheUrl
}
