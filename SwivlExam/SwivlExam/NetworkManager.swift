//
//  NetworkManager.swift
//  SwivlExam
//
//  Created by Sergiy Suprun on 3/15/15.
//  Copyright (c) 2015 Sergiy Suprun. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager: NSObject {

    class var sharedInstance: NetworkManager {
        struct Static {
            static let instance: NetworkManager = NetworkManager(serverUrl:"https://api.github.com/", routing: [NSStringFromClass(User.self) : "users"])
        }
        return Static.instance
    }
    
    
    private let _dataSession: NSURLSession!

    private let _routing:[String:String]
    private let _serverUrlString = ""
    
    init(serverUrl:String!, routing:[String:String]){
        _routing = routing
        _serverUrlString = serverUrl
        
        super.init()
        
        _dataSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
        
        }

}


//MARK: public data loader method
extension NetworkManager {
    func downloadObject<T:MappableObject>(objectClass:T.Type, handler: (success:Bool, data:[T!]?, error:NSError?) -> Void) -> Void{
        let request = requestForObjectClass(objectClass, HTTPMethod: "GET")
        let task = _dataSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, err:NSError!) -> Void in
            let httpResponse = response as NSHTTPURLResponse
            
            let successResponceCodes = [Int](200...208)
            
            if data.length == 0 || !contains(successResponceCodes, httpResponse.statusCode) {
                handler(success: false, data: nil, error: err)
            } else {
                var jsonError : NSError?
                if let jsonObject:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error:&jsonError) as AnyObject! {
                    if jsonObject.isKindOfClass(NSDictionary.self) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let data = self.mapObject(objectClass, jsonDictionary: jsonObject as [String:AnyObject!])
                            handler(success: true, data: [data], error: nil)
                        })
                        
                    }else if (jsonObject.isKindOfClass(NSArray.self)) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let data = self.mapObjects(objectClass, jsonArray: jsonObject as NSArray)
                            handler(success: true, data: data, error: nil)
                        })
                    }
                    
                } else {
                    handler(success: false, data: nil, error: jsonError)
                }
            }
        })
        task.resume()
    }
}



//MARK: internal methods
extension NetworkManager {
    func requestForObjectClass<T:MappableObject>(objectClass:T.Type, HTTPMethod:String!) -> NSURLRequest {
    
        

        let className = NSStringFromClass(objectClass)
        
        let url = String(format: "%@%@", _serverUrlString, _routing[className]!)
        
        
        let result =  NSMutableURLRequest(URL:NSURL(string:url)!)
        result.HTTPMethod = HTTPMethod
        result.addValue("application/json", forHTTPHeaderField: "accept")
        
        
        return result.copy() as NSURLRequest
    }
    
    func dataTaskForRequest(request:NSURLRequest) -> NSURLSessionDataTask {
        return _dataSession.dataTaskWithRequest(request)
    }
}


// MARK: Mapping
extension NetworkManager {

    func mapObject<T:MappableObject>(objectClass:T.Type, jsonDictionary:NSDictionary) -> T? {
        let mappingSheme = objectClass.fromJSONMappingSheme()
        
        if (mappingSheme.count == 0) {
            return nil;
        }
        
        var result = T()
        
        for (jsonKey, objectKey) in mappingSheme {
            if let value:AnyObject = jsonDictionary[jsonKey] as AnyObject! {
                
                (result as AnyObject).setValue(value, forKey: objectKey)
            }
        }
        return result;
    }
    
    func mapObjects<T:MappableObject>(objectClass:T.Type, jsonArray:NSArray) -> [T]? {
        if (jsonArray.count == 0 ) {
            return nil;
        }
        
        var resultArray:[T] = []
        
        for oneObjectDictionary in jsonArray {
            
            if let mapped = mapObject(objectClass, jsonDictionary: oneObjectDictionary as NSDictionary) {
                resultArray.append(mapped)
            }
        }
        
        return resultArray;
    }
}

//MARK: session delegate
extension NetworkManager: NSURLSessionDelegate {

    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
        let serverUrl = NSURL(string: _serverUrlString)
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust{
            completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust))
        }
    }
}