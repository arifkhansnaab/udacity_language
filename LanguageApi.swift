//
//  LanguageApi.swift
//  language
//
//  Created by Arif Khan on 12/10/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation

class LanguageApi : NSObject {
    
    func getWords(_ publishedDate: Date, completionHandlerForWords: @escaping (_ result: [JsonWord]?, _ error: String?) -> Void) {
        
        taskForPOSTMethod(publishedDate) { (results, error) in
            if let error = error {
                completionHandlerForWords(nil, error)
            } else {
                var words:Array<JsonWord> = []
                words = self.parseJson(anyObj: results!)
                completionHandlerForWords(words, nil)
            }
        }
    }

    func postWord(_ word: JsonWord, completionHandlerForWords: @escaping (_ result: String?, _ error: String?) ->Void) {
        taskForPOSTWordMethod(word) { (results, error) in
            if let error = error {
                completionHandlerForWords(nil, error)
            } else {
                var wordId = ""
                if ( results != nil ) {
                    wordId = results as! String
                    completionHandlerForWords(wordId, nil)
                }
            }
        }
    }
    
    func taskForPOSTWordMethod(_ word: JsonWord, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: String?) -> Void) -> URLSessionDataTask{
        
        var json = word.getConvertedJson()
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
 
        let url = NSURL(string: generalConstants.language_webapi_publishword_url)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                completionHandlerForPOST(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                if ((response as? HTTPURLResponse)?.statusCode == 403) {
                    sendError("403")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        })
        
        task.resume()
        return task
    }
    
    func taskForPOSTMethod(_ publishedDate: Date, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: String?) -> Void) -> URLSessionDataTask{
        
        let json = ["message":"echo"]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        // create post request
        let url = NSURL(string: generalConstants.language_webapi_searchword_url)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            func sendError(_ error: String) {
                completionHandlerForPOST(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                if ((response as? HTTPURLResponse)?.statusCode == 403) {
                    sendError("403")
                }
                return
            }
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the Web-API Language request!")
                return
            }
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        })
        
        task.resume()
        return task
    }
    
    fileprivate func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: String?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            print(parsedResult)
        } catch {
            completionHandlerForConvertData(nil, "custom error: parsing data: \(error)")
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    func parseJson(anyObj:AnyObject) -> Array<JsonWord>{
        var list:Array<JsonWord> = []
        print(anyObj.description)
        
        let arrWords = (anyObj as! NSDictionary).object(forKey: "result") as! NSArray?
        if ( arrWords != nil ) {
            for arrWord in arrWords! {
            
                let apiResults = arrWord as! [String: AnyObject]
             
                  let word = JsonWord(sourceWord: apiResults[wordConstant.sourceWord] as! String, translatedWord: apiResults[wordConstant.translatedWord] as! String, language: apiResults[wordConstant.language] as! String, publishedDate: apiResults[wordConstant.publishedDate] as! String, publishedBy: apiResults[wordConstant.publishedBy] as! String)
                
                list.append(word)
            }
        }
        return list
        
    }
    static let sharedInstance = LanguageApi()
    private override init() {}
    
}


