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
    public var queue: DispatchQueue = .global(qos: .background)
    
    public init(token: String? = nil, coordinate: CYCoordinate = .defaultCoordinate) {
        self.endpoint = CYEndpoint(token: token, coordinate: coordinate)
    }
    
    public enum DataSource: Equatable {
        case local
        case remote
    }
}

// MARK: - Work with request for CYResponse

extension CYRequest {
    
    /// Perform an action to request weather content.
    ///
    /// If the data from local cache will be used if:
    /// 1. the local cached file exists with no decoding errors; and
    /// 2. it is for the coordinate you are requiring (rounded to `%.4f`, about 100 meters in distance); and
    /// 3. it is not expired.
    ///
    /// Elsewise, a new data will be requested from remote API.
    open func perform(completionHandler: @escaping (CYResponse?, DataSource, Error?) -> Void) {
        perform(from: .local) { [self] response, source, error in
            if let response = response, error == nil {
                if validate(response) {
                    completionHandler(response, source, nil)
                    NSLog("Local content verified.", 0)
                }
                else {
                    NSLog("Local content expired. Trying to request new content...", -1)
                    perform(from: .remote) { request, source, error in
                        completionHandler(request, source, error)
                    }
                }
            }
            else {
                NSLog("Local content meets error. Trying to request new content...", -1)
                perform(from: .remote) { request, source, error in
                    completionHandler(request, source, error)
                }
            }
        }
    }
    
    /// Perform an action to request weather content. Explicitly defines from which dataSource that you want to request weather content.
    public func perform(from dataSource: DataSource, completionHandler: @escaping (CYResponse?, DataSource, Error?) -> Void) {
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
                    completionHandler(nil, dataSource, error)
                    return
                }
                decode(data) { response, error in
                    completionHandler(response, dataSource, error)
                }
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
                NSLog("Performed a remote data fatching. URL: %@", endpoint.url.absoluteString)
                
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
    public func fetchExampleData(completionHandler: @escaping (Data?, Error?) -> Void) {
        queue.async {
            guard let url = Bundle.module.url(forResource: "Weather", withExtension: "json") else {
                completionHandler(nil, CYError.fileDontExist)
                return
            }
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                completionHandler(data, nil)
                NSLog("Reading example data. URL: %@", url.absoluteString)
            }
            catch let error {
                completionHandler(nil, error)
                NSLog("Error exists when reading example data. Error: %@", error.localizedDescription)
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
        do {
            try data.write(to: localFileUrl, options: .atomic)
            NSLog("Successfully saved data to local. URL: %@", localFileUrl.absoluteString)
        }
        catch let error {
            NSLog("Error exists when saving data to local. Error: %@", error.localizedDescription)
            throw error
        }
        
    }
    
    /// Read some content from local, URL of `<CYRequest.localContentUrl>/<CYCoordinate.urlString>`.
    func readDataFromLocal() throws -> Data {
        do {
            let data = try Data(contentsOf: localFileUrl)
            NSLog("Successfully read data from local.", 0)
            return data
        }
        catch let error {
            NSLog("Error exists when reading data from local. Error: %@", error.localizedDescription)
            throw error
        }
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
                NSLog("Successfully decode content.", 0)
            }
            else if let invalidResponse = try? decoder.decode(CYInvalidResponse.self, from: data) {
                completionHandler(nil, .invalidResponse(description: invalidResponse.error))
                NSLog("API return invalid result. API error content: %@", invalidResponse.error)
            }
            else {
                completionHandler(nil, .invalidResponse(description: "unexpected result"))
                NSLog("API return unexpected result", -1)
            }
        }
    }
    
    /// Validate a `CYResponse` file.
    public func validate(_ response: CYResponse) -> Bool {
        // Coordinate
        guard response.coordinate == endpoint.coordinate else {
            return false
        }
        // Data expiration
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
    // Credit: https://nshipster.com/temporary-files/
}
