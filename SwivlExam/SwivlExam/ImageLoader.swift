//
//  ImageLoader.swift
//  SwivlExam
//
//  Created by Sergiy Suprun on 3/16/15.
//  Copyright (c) 2015 Sergiy Suprun. All rights reserved.
//

import UIKit

typealias ImageLoadCompleted = (image:UIImage?, url:String?) -> Void

class TaskDelegateAndStorage: NSObject {
    weak var imageView: UIImageView?
    var data: NSMutableData?
    let url: NSString
    let task: NSURLSessionDataTask?
    let handler: ImageLoadCompleted
    
    init (url:NSString, task:NSURLSessionDataTask, handler:ImageLoadCompleted) {
        self.handler = handler
        self.url = url
        super.init()
        self.task = task
    }
}


class ImageLoader: NSObject, NSURLSessionTaskDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate{
    class var sharedInstance: ImageLoader {
        struct Static {
            static let instance: ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    private var _imageSession: NSURLSession!
    
    private var _taskAndHandlers: [TaskDelegateAndStorage!] = []
    
    override init() {
        super.init()
        
        let imageCache = NSURLCache(memoryCapacity: 20*1024*1024, diskCapacity: 100*1024*1024, diskPath: "swl_imageCache")
        let imageSessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        imageSessionConfig.URLCache = imageCache
        imageSessionConfig.HTTPShouldUsePipelining = true;
        _imageSession = NSURLSession(configuration:imageSessionConfig , delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        _imageSession.sessionDescription = NSBundle.mainBundle().bundleIdentifier! + "image_download_session"
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        var completed: TaskDelegateAndStorage? = nil
        for (index, d) in enumerate(_taskAndHandlers) {
            if (d.task == task) {
                completed = d
                _taskAndHandlers.removeAtIndex(index)
                break
            }
        }
        if let delegate = completed {
            if delegate.data != nil &&  error == nil {
                let image = UIImage(data: delegate.data!)
                delegate.handler(image:image , url: delegate.task?.originalRequest.URL.absoluteString)
            }else {
                delegate.handler(image: nil, url:delegate.task?.originalRequest.URL.absoluteString)
            }
        }
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        for (index, d) in enumerate(_taskAndHandlers) {
            if (d.task! == dataTask) {
                if d.data == nil {
                    d.data = NSMutableData(data: data)
                } else {
                    d.data?.appendData(data)
                }
                break
            }
        }
    }
}


//mark public methods
extension ImageLoader {
    func downloadImage(path:String, view:UIImageView, handler:(image:UIImage?, url:String?) -> Void) {
        if path.utf16Count == 0 {
            handler(image: nil, url:nil)
        }

        cancelTaskForView(view)
        
        if let imgUrl = NSURL(string: path) {
            if let task = imageLoadingTask(path, view:view, handler: handler) {
                task.resume()
            } else {
                handler(image: nil, url:nil)
            }
        }else {
            handler(image: nil, url:nil)
        }
    }
    
    func imageLoadingTask(path:String, view:UIImageView, handler:ImageLoadCompleted) -> NSURLSessionDataTask? {
        if let imgUrl = NSURL(string: path) {
            
            let task = _imageSession.dataTaskWithURL(imgUrl)
            let newTaskDelegate = TaskDelegateAndStorage(url:path, task: task, handler: handler)
            newTaskDelegate.imageView = view
            _taskAndHandlers.append(newTaskDelegate)

            return task
        }
        return nil
    }
    
    func cancelTaskForView(view:UIImageView) {
        for (index, d) in enumerate(_taskAndHandlers) {
            if (d.imageView == view) {
                d.task?.cancel()
                d.data = nil
                _taskAndHandlers.removeAtIndex(index)
                break
            }
        }
    }
}