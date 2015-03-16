//
//  UIImageView+ImageFromURL.swift
//  SwivlExam
//
//  Created by Sergiy Suprun on 3/15/15.
//  Copyright (c) 2015 Sergiy Suprun. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

extension UIImageView {

    func swl_setAvatarImageFromUrl(url:String) {
        swl_setAvatarImageFromUrl(url, size: 100)
    }
    
    func swl_setAvatarImageFromUrl(url:String, size:Int) {
        let sizeArgument = String(format:"&s=%d",size)
        let urlString = url + sizeArgument
        
        swl_setImageFromUrl(urlString)
    }
    
    func swl_setImageFromUrl(url:String) {
        if (url.utf16Count == 0) {
            self.image = nil
        }
        
        ImageLoader.sharedInstance.downloadImage(url, view: self, handler: { (image, url) -> Void in
            self.image = image
        })
    
    }
    
    func swl_cancelImageLoading() -> Void {
        ImageLoader.sharedInstance.cancelTaskForView(self)
    }
}