//
//  ViewController-iOS.swift
//  BBC 6 Music
//
//  Created by Frederic Font Corbera on 30/12/15.
//  Copyright © 2015 Frederic Font Corbera. All rights reserved.
//

import Foundation
import UIKit

class BBC6MusicViewController_iOS: BBC6MusicViewController {
    @IBOutlet weak var label: UITextView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var programNameLabel: UITextView!
    
    override func setLogoAlpha(_ alpha: CGFloat) {
        self.logo.alpha = alpha
    }
    
    override func setLabelText(_ text: String) {
        self.label.text = text
    }
    
    override func setProgrameNameLabelText(_ text: String) {
        self.programNameLabel.text = text
    }
    
    override func adaptSizes(){
        
        // Also reduce logo size
        //let screenSize: CGRect = UIScreen.mainScreen().bounds
        //self.logo.frame = CGRectMake(0,0, screenSize.height * 0.2, 50)
        //self.logo.setNeedsLayout()
        //self.logo.setNeedsDisplay()
        
        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                // If device is iPhone, reduce label and programNameLabel font sizes
                self.label.font = UIFont.systemFont(ofSize: 18)
                self.programNameLabel.font = UIFont.systemFont(ofSize: 24)
            case .pad:
                break
            default:
                break
        }
    }
    
    // MARK: UI actions
    @IBAction func onPressLogo(_ sender: UIButton) {
        self.togglePlayPause()
    }
}
