//
//  HttpRequester.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/30/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

class HttpRequester{
    var delegate: HttpRequesterDelegate?
    
    func send(withMethod method: HttpMethod,
              toUrl urlString: String,
              withBody bodyDict: Dictionary<String, Any>? = nil,
              andHeaders headers: Dictionary<String, String> = [:]) {
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        
        if(bodyDict != nil) {
            do {
                let body = try JSONSerialization.data(withJSONObject: bodyDict!, options: .prettyPrinted)
                request.httpBody = body
            } catch {
            }
        }
        
        headers.forEach() { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        weak var weakSelf = self
        
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler:
            { bodyData, response, error in
                do {
                    let body = try JSONSerialization.jsonObject(with: bodyData!, options: .allowFragments)
                    
                    if((response as! HTTPURLResponse).statusCode >= 400) {
                        let message = (body as! Dictionary<String, Any>)["error"] as! String
                        weakSelf?.delegate?.didReceiveError(error: message)
                        return
                    }
                    let message = (body as! Dictionary<String, Any>)["message"] as? String
                    let success = (body as! Dictionary<String, Any>)["success"] as? Bool
                    let data = (body as! Dictionary<String, Any>)["data"]
                    
                    if success! && data != nil{
                        weakSelf?.delegate?.didReceiveData(data: data)
                    }
                    
                    weakSelf?.delegate?.didReceiveMessage(success: success ?? false, message: message ?? "")
                    
                }
                catch {
                    weakSelf?.delegate?.didReceiveError(error: error.localizedDescription)
                }
        })
        
        dataTask.resume()
    }
    
    func get(fromUrl urlString: String, andHeaders headers: Dictionary<String, String> = [:]){
        self.send(withMethod: .get, toUrl: urlString,withBody: nil, andHeaders: headers)
    }
    
    func postJson(toUrl urlString: String, withBody bodyDict: Dictionary<String, Any>, andHeaders headers: Dictionary<String, String> = [:]){
        var headersWithJson: Dictionary<String,String>= [:]
        headers.forEach(){ headersWithJson[$0.key] = $0.value }
        headersWithJson["Content-Type"] = "application/json"
        
        self.send(withMethod: .post, toUrl: urlString, withBody: bodyDict, andHeaders: headers)
    }
}
