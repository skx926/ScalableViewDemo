//
//  ViewController.swift
//  ScalableViewDemo
//
//  Created by Kyle Sun on 2017/6/21.
//  Copyright © 2017年 Kyle Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var initialFrame = CGRect.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        view.addGestureRecognizer(pinch)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        view.addGestureRecognizer(pan)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initialFrame = imageView.frame
    }
    
    func didPinch(_ pinch: UIPinchGestureRecognizer) {
        if pinch.state != .changed {
            return
        }
        let scale = pinch.scale
        let location = pinch.location(in: view)
        let scaleTransform = imageView.transform.scaledBy(x: scale, y: scale)
        imageView.transform = scaleTransform
        
        let dx = imageView.frame.midX - location.x
        let dy = imageView.frame.midY - location.y
        let x = dx * scale - dx
        let y = dy * scale - dy
        
        // 这样的话计算会有错误
        //imageView.transform = imageView.transform.translatedBy(x: x, y: y);
        
        let translationTransform = CGAffineTransform(translationX: x, y: y)
        imageView.transform = imageView.transform.concatenating(translationTransform)
        
        pinch.scale = 1
    }
    
    // 单纯的缩放
//    func didPinch(_ pinch: UIPinchGestureRecognizer) {
//        if pinch.state != .changed {
//            return
//        }
//        let scale = pinch.scale
//        let scaleTransform = imageView.transform.scaledBy(x: scale, y: scale)
//        imageView.transform = scaleTransform
//        pinch.scale = 1
//    }
    
    func didPan(_ pan: UIPanGestureRecognizer) {
        if pan.state != .changed {
            return
        }
        let scale = imageView.frame.size.width / initialFrame.size.width
        let translation = pan.translation(in: view)
        let transform = imageView.transform.translatedBy(x: translation.x / scale, y: translation.y / scale)
        imageView.transform = transform
        pan.setTranslation(.zero, in: view)
    }
}

