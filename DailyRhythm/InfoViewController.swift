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
    
    
    override func viewDidLoad() {
        textView.isScrollEnabled = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.isScrollEnabled = true
    }
}
