//
//  Network.swift
//  Articles
//
//  Created by Anna on 8/18/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import Foundation

class Network {
    
    static var url_base = "http://madiosgames.com"
    
    static func request (api: String, method: String, parameters: [String: Any]? = nil, completion: @escaping (NSArray?) -> Void, errorHandler: ((NSError) -> Void)?) {
        guard let destination = URL(string: Network.url_base + api) else { return }
        var request = URLRequest(url: destination)
        request.httpMethod = method
        if let parameters = parameters {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return
            }
            request.httpBody = httpBody
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    if let jsonArray = json as? NSArray {
                        completion(jsonArray)
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
