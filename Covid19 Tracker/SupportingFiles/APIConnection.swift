//
//  APIConnection.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Patel on 5/22/21.
//

import Foundation
enum RequestType: String {
    case Get = "GET"
}

class APIConnection {
    public static let shared = APIConnection()
    
    private init() {
        
    }
    
    func makeRequest(toURL url: URL, params: [String: String], method: RequestType, onCompletion: @escaping (_ error: NSError?, _ response: Data?) -> Void) -> URLSessionDataTask? {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = params.map {
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        
        urlComponents?.queryItems = queryItems
        if let requestUrl = urlComponents?.url {
            var request = URLRequest(url: requestUrl)
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
            
            request.httpMethod = method.rawValue
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let err = error as NSError? {
                    if err.code == NSURLErrorCancelled {
                        //ignore if user cancels the request.
                        return
                    }
                    
                    onCompletion(err, nil)
                    return
                }
                
                //success.
                onCompletion(nil, data)
            })
            task.resume()
            return task
        }
        
        return nil
    }
}
