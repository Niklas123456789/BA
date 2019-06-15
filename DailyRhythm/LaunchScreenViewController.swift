//
//  LaunchScreenViewController.swift
//  DailyRhythm
//
//  Created by Niklas Großmann on 13.06.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreenViewController: UIViewController {
    @IBOutlet weak var gifView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrundBlau")!)
        
        gifView.loadGif(name: "nobackground720")
        var timer = Timer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { (timer) in
            self.performSegue(withIdentifier: "afterLaunch", sender: nil)
        })
    }
}
