//
//  CYRequest.swift
//  
//
//  Created by 袁林 on 2021/6/12.
//

import Foundation

public class CYRequest {
    
    /// The `CYEndpoint` object to which the request is sent to.
    public var endpoint: CYEndpoint
    
    /// The queue on which the request is performed
    public var queue: DispatchQueue = DispatchQueue.global(qos: .background)
    
    public init(endpoint: CYEndpoint) {
        self.endpoint = endpoint
    }
    
    public convenience init(token: String) {
        self.init(endpoint: CYEndpoint(token: token))
    }
    
    public func request(completionHandler: @escaping (Data?, Error?) -> Void) {
        queue.async { [self] in
            URLSession.shared.dataTask(with: endpoint.url) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(data, nil)
            }
            .resume()
        }
    }
    
}
