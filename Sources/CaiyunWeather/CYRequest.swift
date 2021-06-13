//
//  CYRequest.swift
//  
//
//  Created by 袁林 on 2021/6/12.
//

import Foundation

class CYRequest {
    
    /// The `CYEndpoint` object to which the request is sent to.
    var endpoint: CYEndpoint
    
    /// The queue on which the request is performed
    var queue: DispatchQueue = DispatchQueue.global(qos: .background)
    
    init(endpoint: CYEndpoint) {
        self.endpoint = endpoint
    }
    
    convenience init(token: String) {
        self.init(endpoint: CYEndpoint(token: token))
    }
    
    func request(completionHandler: @escaping (Data?, Error?) -> Void) {
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
