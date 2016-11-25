//
//  SessionAndParseModel.swift
//  language
//
//  Created by Arif Khan on 11/24/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation



class SessionAndParseModel {
    
    static let sheredInstance = SessionAndParseModel()
    
    // MARK: Properties
    
    /* Shared session */
    var session: URLSession
    
    // MARK: Initializers
    
    init() {
        session = URLSession.shared
    }
    
    /* Takes variable requests, client (udacity or parse) ,perform session, return result and  succesful respond to be parsed as completion handeler*/
    func sessionAndParseTask(_ request: NSMutableURLRequest, client: ClientSelection, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var parsedResult: AnyObject!
        
        let test : URLSessionDataTask? = nil
        return test!
    }
    /*        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
     
     /* GUARD: Was there an error? */
     guard (error == nil) else {
     print("There was an error with your request: \(error)")
     completionHandler(result: false, error: error)
     return
     }
     
     /* GUARD: Did we get a successful 2XX response? */
     guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
     if let response = response as? HTTPURLResponse {
     print("Your request returned an invalid response! Status code: \(response.statusCode)!")
     
     completionHandler(result: nil, error: NSError(domain: "sessionAndParseTask", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey:"Status code: \(response.statusCode)"]))
     } else if let response = response {
     print("Your request returned an invalid response! Response: \(response)!")
     } else {
     print("Your request returned an invalid response!")
     }
     return
     }
     
     /* GUARD: Was there any data returned? */
     guard var data = data else {
     print("No data was returned by the request!")
     return
     }
     
     /* Parse JSONResponse */
     DispatchQueue.main.async(execute: { () -> Void in
     if client == .udacity {  /* if the client is Udacity */
     /* Parse the data after the first five char */
     data = data.subdata(with: NSMakeRange(5, data.count - 5))
     }
     do {
     parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
     } catch {
     parsedResult = nil
     print("Could not parse JSON")
     }
     completionHandler(result: parsedResult, error: nil) // insert the data to the completion handeler
     })
     })
     
     task.resume()
     return task
     }
     */
    
}
