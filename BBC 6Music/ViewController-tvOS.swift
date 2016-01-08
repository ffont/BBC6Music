//
//  ViewController-tvOS.swift
//  BBC 6 Music
//
//  Created by Frederic Font Corbera on 30/12/15.
//  Copyright © 2015 Frederic Font Corbera. All rights reserved.
//

import Foundation
import UIKit

class BBC6MusicViewController_tvOS: BBC6MusicViewController {
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
    
    // MARK: tvos button pressed handler
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            if(press.type == UIPressType.PlayPause) {
                self.togglePlayPause()
            } else {
                super.pressesEnded(presses, withEvent: event)
            }
        }
    }
}