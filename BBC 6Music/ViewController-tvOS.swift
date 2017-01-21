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
    
    override func setProgrameNameLabelText(_ text: String) {
        self.programNameLabel.text = text
    }
    
    override func updateLabels() {
        var label_contents = ""
        let attributedLabelContents = NSMutableAttributedString()
        for element in self.metadata_parser.recent_metadata.reversed() {
            let artist:NSString = element["artist"]! as! NSString
            let track:NSString = element["track"]! as! NSString
            let now = Date()
            let started:Date = element["started"]! as! Date
            let seconds_ago = now.timeIntervalSince(started)
            let minutes_ago:Int = Int(seconds_ago / 60.0)
            label_contents += "\(track) by \(artist) (\(minutes_ago) minutes ago)\n"
            let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: "\(track) by \(artist) (\(minutes_ago) minutes ago)\n")
            attributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 23)], range: NSRange(location:0, length:track.length))
            attributedLabelContents.append(attributedText)
        }
        self.label.attributedText = attributedLabelContents
        self.setProgrameNameLabelText(self.metadata_parser.program_name as String)
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
