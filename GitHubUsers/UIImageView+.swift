//
//  UIImageView+.swift
//  GitHubUsers
//
//  Created by atMamont on 22.07.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImageFrom(link link:String, contentMode: UIViewContentMode) {
        NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}