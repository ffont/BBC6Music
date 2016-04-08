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
    
    override func setLogoAlpha(alpha: CGFloat) {
        self.logo.alpha = alpha
    }
    
    override func setLabelText(text: String) {
        self.label.text = text
    }
    
    override func setProgrameNameLabelText(text: String) {
        self.programNameLabel.text = text
    }
    
    override func adaptSizes(){
        
        // Also reduce logo size
        //let screenSize: CGRect = UIScreen.mainScreen().bounds
        //self.logo.frame = CGRectMake(0,0, screenSize.height * 0.2, 50)
        //self.logo.setNeedsLayout()
        //self.logo.setNeedsDisplay()
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
            case .Phone:
                // If device is iPhone, reduce label and programNameLabel font sizes
                self.label.font = UIFont.systemFontOfSize(16)
                self.programNameLabel.font = UIFont.systemFontOfSize(20)
            case .Pad:
                break
            default:
                break
        }
    }
    
    // MARK: UI actions
    @IBAction func onPressLogo(sender: UIButton) {
        self.togglePlayPause()
    }
}