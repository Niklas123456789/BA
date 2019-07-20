//
//  InfoViewController.swift
//  DailyRhythm
//
//  Created by Niklas Großmann on 17.05.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import UIKit


class InfoViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imagesView: UIImageView!
    let imageNames = ["info_blau","hintergrundBlau","hintergrundHell","hintergrundBlau","hintergrundHell"]
    var currentImage = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        textView.isScrollEnabled = false
        view.addSubview(imagesView)
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture")
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.imagesView.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture")
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.imagesView.addGestureRecognizer(swipeLeft)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        textView.isScrollEnabled = true
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            print("SWIPE \(swipeGesture.direction)")
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if currentImage == imageNames.count - 1 {
                    currentImage = 0
                    
                }else{
                    currentImage += 1
                }
                imagesView.image = UIImage(named: "info_blau.png")
                
            case UISwipeGestureRecognizer.Direction.right:
                if currentImage == 0 {
                    currentImage = imageNames.count - 1
                }else{
                    currentImage -= 1
                }
                imagesView.image = UIImage(named: imageNames[currentImage])
            default:
                break
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
