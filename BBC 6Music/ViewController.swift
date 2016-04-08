//
//  ViewController.swift
//  BBC 6 Music
//
//  Created by Frederic Font Corbera on 05/11/15.
//  Copyright © 2015 Frederic Font Corbera. All rights reserved.
//

import AVFoundation
import UIKit

class BBC6MusicViewController: UIViewController {

    var playerItem:AVPlayerItem!
    var player:AVPlayer!
    var metadata_parser:BBC6MetadataParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(BBC6MusicViewController.updateLabels), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLogoAlpha(alpha: CGFloat) {
        // Method to override in subclass
    }
    
    func setLabelText(text: String) {
        // Method to override in subclass
    }
    
    func setProgrameNameLabelText(text: String) {
        // Method to override in subclass
    }
    
    func setUp(){
        // Labels and metadata stuff
        self.adaptSizes()
        self.setLabelText("")
        self.setProgrameNameLabelText("")
        self.metadata_parser = BBC6MetadataParser()
        updateMetadata()
        _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(BBC6MusicViewController.updateMetadata), userInfo: nil, repeats: true)
        
        // Player stuff
        self.playerItem = AVPlayerItem(URL:NSURL(string: "http://www.listenlive.eu/bbc6music.m3u")!)
        self.playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        self.player = AVPlayer(playerItem: self.playerItem)
    }
    
    func adaptSizes(){
        // TO be overriden in spciefic view controllers
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "status" {
            print("Status: \(self.playerItem.status.rawValue)")
            print("Error: \(self.playerItem.error)")
            self.player.play()
        }
    }
    
    func togglePlayPause(){
        if (self.player.volume == 1.0){
            self.player.volume = 0.0
            self.setLogoAlpha(0.3)
        } else {
            self.player.volume = 1.0
            self.setLogoAlpha(1.0)
        }
    }
    
    // MARK: update labels and metadata
    
    func updateMetadata(){
        self.metadata_parser.getHTMLData()
        self.metadata_parser.parseMetadata()
        self.metadata_parser.parseProgramMetadata()
    }
    
    func updateLabels() {
        var label_contents = ""
        for element in self.metadata_parser.recent_metadata.reverse() {
            let artist:NSString = element["artist"]! as! NSString
            let track:NSString = element["track"]! as! NSString
            let now = NSDate()
            let started:NSDate = element["started"]! as! NSDate
            let seconds_ago = now.timeIntervalSinceDate(started)
            let mintues_ago:Int = Int(seconds_ago / 60.0)
            label_contents += "\(artist) - \(track) - \(mintues_ago) minutes ago\n"
        }
        self.setLabelText(label_contents)
        self.setProgrameNameLabelText(self.metadata_parser.program_name as String)
    }
}

