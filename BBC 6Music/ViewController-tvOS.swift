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
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var label: UITextView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var programNameLabel: UITextView!
    
    override func setLogoAlpha(_ alpha: CGFloat) {
        self.logo.alpha = alpha
    }
    
    override func setLabelText(_ text: String, attributedText: NSAttributedString?) {
        if (attributedText != nil){
            self.label.attributedText = attributedText
        } else {
            self.label.text = text
        }
        
    }
    
    override func setProgrameNameLabelText(_ text: String) {
        self.programNameLabel.text = text
    }
    
    // MARK: tvos button pressed handler
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            if(press.type == UIPressType.playPause) {
                self.togglePlayPause()
            } else {
                super.pressesEnded(presses, with: event)
            }
        }
    }
    
    // MARK: set image handler
    override func setImage(image: UIImage) {
        self.artwork.image = image
    }
}
