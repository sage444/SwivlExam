//
//  ImageViewerViewController.swift
//  SwivlExam
//
//  Created by Sergiy Suprun on 3/17/15.
//  Copyright (c) 2015 Sergiy Suprun. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController, UIScrollViewDelegate {

    var userData:User!
    var lastZoomScale: CGFloat = -1
    
    @IBOutlet weak var _scrollView: UIScrollView!
    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var _activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var _bottomConstaint: NSLayoutConstraint!
    @IBOutlet weak var _topConstaint: NSLayoutConstraint!
    @IBOutlet weak var _leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var _trailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = userData.login
        _activityIndicator.startAnimating()
        _imageView.swl_setAvatarImageFromUrl(userData.avatarUrl, size: 400) { () -> Void in
            self._activityIndicator.stopAnimating()
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fixImageViewConstaints()
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        updateZoom()
    }
    
    
    func fixImageViewConstaints() {
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        
        let wDelta = (self.view.bounds.width  - _imageView.bounds.width * _scrollView.zoomScale) / 2
        let hDelta = ((self.view.bounds.height - 64) - _imageView.bounds.height * _scrollView.zoomScale) / 2
        
        if (wDelta > 0) {
            _leadingConstraint.constant = wDelta
            _trailingConstraint.constant = wDelta
        }else {
            _leadingConstraint.constant = 0
            _trailingConstraint.constant = 0
        }
        if (hDelta > 0) {
            _topConstaint.constant = hDelta
            _bottomConstaint.constant = hDelta
        }else {
            _topConstaint.constant = 0
            _bottomConstaint.constant = 0
        }
        
        self.view.layoutIfNeeded()
    }
    
    private func updateZoom() {
        if let image = _imageView.image {
            var minZoom = min(view.bounds.size.width / image.size.width,
                view.bounds.size.height / image.size.height)
            
            if minZoom > 1 { minZoom = 1 }
            
            _scrollView.minimumZoomScale = minZoom
            
            if minZoom == lastZoomScale { minZoom += 0.000001 }
            
            _scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: scroll view
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return _imageView
    }

    func scrollViewDidZoom(scrollView: UIScrollView) {
        fixImageViewConstaints()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
