//
//  WebServiceManager.swift
//  BookLibrary
//
//  Created by Rupesh Kumar on 08/03/18.
//  Copyright © 2018 Rupesh Kumar. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String:Any]

class WebServiceManager {
    
    func getUserList (from offset: Int, limit: Int, callback: @escaping ([User]?) -> Void) {
        var userList = [User]()
        let url = URL(string: "http://sd2-hiring.herokuapp.com/api/users?offset=\(offset)&limit=\(limit)")
        
        guard let finalUrl = url else {
            callback(nil)
            return
        }
        
        URLSession.shared.dataTask(with: finalUrl) { data, response, error in
            
            if let data = data {
                
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                let dictionary = json as! JSONDictionary
                let dataDict = dictionary[kServerResonceJSONKeyData] as! JSONDictionary
                let userListDict = dataDict[kServerResonceJSONKeyUsers] as! [JSONDictionary]

                userList = userListDict.compactMap { dictionary in
                    return User(dictionary :dictionary)
                }
            }
            
            DispatchQueue.main.async {
                callback(userList)
            }
            
        }.resume()
    }
}
