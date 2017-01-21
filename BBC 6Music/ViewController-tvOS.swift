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
    var backgroundArtwork: UIImageView!
    
    override func setUp() {
        super.setUp()
        setUpBackgroundArtwork()
    }
    
    func setUpBackgroundArtwork() {
        self.backgroundArtwork = UIImageView()
        self.backgroundArtwork.frame = CGRect(x: 0, y: -(self.view.frame.size.width-self.view.frame.size.height)/2, width: self.view.frame.size.width, height: self.view.frame.size.width)
        self.view.insertSubview(self.backgroundArtwork, at: 0)
        self.backgroundArtwork.addBlurEffect()
        self.backgroundArtwork.alpha = 1.0
    }
    
    override func setLogoAlpha(_ alpha: CGFloat) {
        self.logo.alpha = alpha
    }
    
    override func setProgrameNameLabelText(_ text: String) {
        
        let decodedText = text.stringByDecodingHTMLEntities
        let allRange = NSRange(location:0, length:decodedText.characters.count)
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: decodedText)
        attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 60)], range: allRange)
        attributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 60)], range: allRange)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes: [String : Any] = [NSParagraphStyleAttributeName: paragraph]
        attributedText.addAttributes(attributes, range: allRange)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 39/255, green: 111/255, blue: 133/255, alpha: 1), range: allRange)
        self.programNameLabel.attributedText = attributedText
    }
    
    override func updateLabels() {
        let attributedLabelContents = NSMutableAttributedString()
        var nAddedLines = 1
        for element in self.metadata_parser.recent_metadata.reversed() {
            let artist:NSString = element["artist"]! as! NSString
            let track:NSString = element["track"]! as! NSString
            let now = Date()
            let started:Date = element["started"]! as! Date
            let seconds_ago = now.timeIntervalSince(started)
            let minutes_ago:Int = Int(seconds_ago / 60.0)
            let label_contents:NSString = "\(track) by \(artist) (\(minutes_ago) minutes ago)\n" as NSString
            let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: label_contents as String)
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 40)], range: NSRange(location:0, length:label_contents.length))
            attributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 40)], range: NSRange(location:0, length:track.length))
            if (nAddedLines <= 5) {
                attributedLabelContents.append(attributedText)
            }
            nAddedLines += 1
        }
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes: [String : Any] = [NSParagraphStyleAttributeName: paragraph]
        attributedLabelContents.addAttributes(attributes, range: NSRange(location:0, length:attributedLabelContents.length))

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
        self.backgroundArtwork.image = image
    }
}
