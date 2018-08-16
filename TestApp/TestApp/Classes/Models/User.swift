//
//  ServerItem.swift
//  BookLibrary
//
//  Created by Rupesh Kumar on 08/03/18.
//  Copyright © 2018 Rupesh Kumar. All rights reserved.
//

import Foundation


struct User
{
    //Genral
    var name :String
    var imageUrl :String?
    var userItemList:Array<String> = Array()
    
    init(name :String, imageUrl:String?) {
        self.name = name
        self.imageUrl = imageUrl
    }
    
    init?(dictionary :JSONDictionary) {
        
        guard let userName = dictionary[kServerResonceJSONKeyName] as? String else {
                return nil
        }
        
        self.name = userName
        self.imageUrl = dictionary[kServerResonceJSONKeyImageURL] as? String
        self.userItemList.append(contentsOf: (dictionary[kServerResonceJSONKeyUserItems] as! [String]))
    }
}
