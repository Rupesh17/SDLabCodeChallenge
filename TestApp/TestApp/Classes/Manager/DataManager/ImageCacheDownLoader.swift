//
//  CacheManager.swift
//  BookLibrary
//
//  Created by Rupesh Kumar on 09/03/18.
//  Copyright © 2018 Rupesh Kumar. All rights reserved.
//

import Foundation
import UIKit

typealias ImageCacheDownLoaderCompletionHandler = ((UIImage) -> ())

class ImageCacheDownLoader {
    
    static let shared = ImageCacheDownLoader()
    
    // MARK: -
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache: NSCache<NSString, UIImage>!
    
    // Initialization
    
    private init() {
        session = URLSession.shared
        task = URLSessionDownloadTask()
        self.cache = NSCache()
    }

    func getImageWithPath(imagePath: String, completionHandler: @escaping ImageCacheDownLoaderCompletionHandler) {
        if let image = self.cache.object(forKey: imagePath as NSString) {
            DispatchQueue.main.async {
                completionHandler(image)
            }
        } else {
            
            /* placeholder to if we want to use */
            
            let placeholder = #imageLiteral(resourceName: "placeHolder.png")
            DispatchQueue.main.async {
                completionHandler(placeholder)
            }
            
            let url: URL! = URL(string: imagePath)
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) in
                if let data = try? Data(contentsOf: url) {
                    let img: UIImage! = UIImage(data: data)
                    self.cache.setObject(img, forKey: imagePath as NSString)
                    DispatchQueue.main.async {
                        completionHandler(img)
                    }
                }
            })
            
            task.resume()
        }
    }
}
