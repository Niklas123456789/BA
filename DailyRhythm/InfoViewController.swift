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
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var swipeRightArrow: UIImageView!
    
    var imageArray = [UIImage]()
    
    var currentImage = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeRightArrow.alpha = 0.0
        textView.isScrollEnabled = false
        //Image Literal
        imageArray = [#imageLiteral(resourceName: "Zeichenfläche 1-1"), #imageLiteral(resourceName: "ok_weiss"), #imageLiteral(resourceName: "hintergrundHell")]
    
        mainScrollView.frame = view.frame
        for i in 0..<imageArray.count{
            
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleAspectFit
            
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
            
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i + 1)
            mainScrollView.addSubview(imageView)
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        textView.isScrollEnabled = true
        swipeRightArrow.fadeIn()
        var timer = Timer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.6, repeats: false, block: { (timer) in
            self.swipeRightArrow.fadeOut()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
