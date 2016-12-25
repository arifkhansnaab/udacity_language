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
        //let json = ["sourceWord":"wow1","translatedWord":"dunya","language":"urdu","publishedDate":"12/11/2016","publishedBy":"arif.khan@snnab.com"]
        //let json = ["message":"sourceWord~Sky1=translatedWord~asman=language~urdu=publishedDate~12-24-2016=publishedBy~arif.khan@snnab.com"]
        print(json)
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        //print(jsonData.description)
        // create post request
        let url = NSURL(string: generalConstants.language_webapi_publishword_url)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // insert json data to the request
        //request.httpBody = jsonData
        
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
                print((response as? HTTPURLResponse)?.description)
                return
            }
            
            print((response as? HTTPURLResponse)?.description)
            
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
    
    func PostLetter() -> Bool {
        let request = NSMutableURLRequest(url: NSURL(string: "https://language-150802.appspot.com/_ah/api/language/v1/publishWord") as! URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = ["sourceWord":"world343","translatedWord":"dunya","language":"urdu","publishedDate":"12/11/2016","publishedBy":"arif.khan@snnab.com"]
        //var params = ["username":"jameson", "password":"password"] as Dictionary<String, String>
        //let params = ["message":"jameson"] as Dictionary<String, String>
        
        var err: NSError? = nil
        
        var json : NSDictionary
        
        //let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        //request.httpBody = JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        //request.HTTPBody = JSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            //println("Response: \(response)")
            var strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //println("Body: \(strData)")
            var err: NSError?
            //let buttonAudioPlayer = try! AVAudioPlayer(contentsOfURL: buttonAudioURL)
            //let json : NSDictionary
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
            } catch let error {
                print("error occured \(error)")
            }
            
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                //println(err!.localizedDescription)
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                print("test")
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                //if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                  //  var success = parseJSON["success"] as? Int
                    //println("Succes: \(success)")
                //}
                //else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                  //  let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    //println("Error could not parse JSON: \(jsonStr)")
                //}
            }
        })
        
        task.resume()
        return true
    }
    
    func taskForPOSTMethod(_ publishedDate: Date, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: String?) -> Void) -> URLSessionDataTask{
        
        
        let json = ["message":"echo"]
        //let json = ["message":"sourceWord"]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        // create post request
        let url = NSURL(string: generalConstants.language_webapi_searchword_url)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
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
                print((response as? HTTPURLResponse)?.description)
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
    
  /*  func taskForGETMethod(_ publishedDate: Date, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        let page = 1
        
        let url = "https://language-150802.appspot.com/_ah/api/language/v1/words"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        
        let session = URLSession.shared
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                completionHandlerForGET(nil, error)
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
                print((response as? HTTPURLResponse)?.description)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        })
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }*/
    
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
             
                let word = JsonWord(sourceWord: apiResults["sourceWord"] as! String, translatedWord: apiResults["translatedWord"] as! String, language: apiResults["language"] as! String, publishedDate: apiResults["publishedDate"] as! String, publishedBy: apiResults["publishedBy"] as! String)
                
                list.append(word)
            }
        }
        
        return list
        
    }//fun
    
    static let sharedInstance = LanguageApi()
    private override init() {}
    
}


