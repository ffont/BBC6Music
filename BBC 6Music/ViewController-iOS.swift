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
    
    @IBAction func onPressLogo(sender: UIButton) {
        self.togglePlayPause()
    }
}