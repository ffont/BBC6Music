//
//  RadioViewController.swift
//  BB6Status
//
//  Created by Frederic Font Corbera on 23/07/15.
//  Copyright (c) 2015 Frederic Font Corbera. All rights reserved.
//

import Cocoa
import AVFoundation

class BBC6MusicViewController: NSViewController {

    var playerItem:AVPlayerItem!
    var player:AVPlayer!
    var metadata_parser:BBC6MetadataParser!
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var onOff: NSSegmentedControl!
    @IBOutlet weak var label: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(BBC6MusicViewController.updateLabels), userInfo: nil, repeats: true)
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        updateLabels()
    }

    func setUp(){
        // Metadata parser stuff
        self.metadata_parser = BBC6MetadataParser()
        updateMetadata()
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(BBC6MusicViewController.updateMetadata), userInfo: nil, repeats: true)

        // Player stuff
        self.playerItem = AVPlayerItem(url:URL(string: "http://www.listenlive.eu/bbc6music.m3u")!)
        self.player = AVPlayer(playerItem:self.playerItem)
        self.player.play()
    }


    // MARK: UI actions

    @IBAction func onSwitchChange(_ sender: AnyObject) {
        if sender.selectedSegment == 1 {
            self.player.play()
            self.slider.isEnabled = true
        } else {
            self.player.pause()
            self.slider.isEnabled = false
        }
    }

    @IBAction func onSliderChange(_ sender: AnyObject) {
        self.player.volume = self.slider.floatValue
    }

    // MARK: update metadata and labels handlers

    func updateMetadata(){
        self.metadata_parser.getHTMLData()
        self.metadata_parser.parseMetadata()
    }

    func updateLabels() {
        let attributedLabelContents = NSMutableAttributedString()
        for element in self.metadata_parser.recent_metadata.reversed() {
            let artist:NSString = element["artist"]! as! NSString
            let track:NSString = element["track"]! as! NSString
            let now = Date()
            let started:Date = element["started"]! as! Date
            let seconds_ago = now.timeIntervalSince(started)
            let minutes_ago:Int = Int(seconds_ago / 60.0)
			
            let labelContents = "\(track) by \(artist) (\(minutes_ago) minutes ago)\n"
            let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: labelContents)
            attributedText.addAttributes([NSFontAttributeName: NSFont.boldSystemFont(ofSize:13)], range: NSRange(location:0, length:track.length))
            attributedLabelContents.append(attributedText)
        }
        self.label.attributedStringValue = attributedLabelContents
    }
}
