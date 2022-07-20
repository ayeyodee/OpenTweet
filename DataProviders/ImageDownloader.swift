//
//  ImageDownloader.swift
//  OpenTweet
//
//  Created by Derrick Turner on 7/19/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    
    private let cache = NSCache<NSString, UIImage>()
    
    func downloadImage(withURL url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, responseURL, error in
            
            var downloadedImage: UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                self?.cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        dataTask.resume()
    }
    
    func getImage(withURL url: URL, completion: @escaping (_ image: UIImage?)->()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            downloadImage(withURL: url, completion: completion)
        }
    }
}
