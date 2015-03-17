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

typealias VoidHandler = (Void) -> Void

extension UIImageView {

    func swl_setAvatarImageFromUrl(url:String) {
        swl_setAvatarImageFromUrl(url, size: 100, nil)
    }
    
    func swl_setAvatarImageFromUrl(url:String, size:Int, completeHandler: VoidHandler?) {
        let retina:Int = Int(UIScreen.mainScreen().scale)
        let sizeArgument = String(format:"&s=%d", size * retina)
        let urlString = url + sizeArgument
        
        swl_setImageFromUrl(urlString, handler: completeHandler)
    }
    
    func swl_setImageFromUrl(url:String, handler:VoidHandler?) {
        if (url.utf16Count == 0) {
            self.image = nil
        }
        
        ImageLoader.sharedInstance.downloadImage(url, view: self, handler: { (image, url) -> Void in
            self.image = image
            handler?()
        })
    
    }
    
    func swl_cancelImageLoading() -> Void {
        ImageLoader.sharedInstance.cancelTaskForView(self)
    }
}