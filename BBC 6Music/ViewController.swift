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
    var html_content:NSString = ""
    var html_program_content:NSString = ""
    var program_id:NSString = ""
    var program_name:NSString = ""
    var recent_metadata: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("updateLabels"), userInfo: nil, repeats: true)
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
    
    func updateMetadata(){
        getHTMLData()
        parseMetadata()
        parseProgramMetadata()
    }
    
    func setUp(){
        print("Loading")
        self.setLabelText("")
        self.setProgrameNameLabelText("")
        updateMetadata()
        _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("updateMetadata"), userInfo: nil, repeats: true)
        
        self.playerItem = AVPlayerItem(URL:NSURL(string: "http://www.listenlive.eu/bbc6music.m3u")!)
        self.playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        self.player = AVPlayer(playerItem: self.playerItem)
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
    
    func getHTMLData(){
        // Get track, artist name, and program id from realtime feed
        let myURLString = "http://polling.bbc.co.uk/radio/realtime/bbc_6music.jsonp"
        if let myURL = NSURL(string: myURLString) {
            do {
                let myHTMLString = try NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding)
                self.html_content = myHTMLString
            } catch {
                print("Error getting html: \(error)")
                self.html_content = ""
            }
        }
        // Get programme name from program id
        if program_id != ""{
            let myURLString = "http://www.bbc.co.uk/6music/"
            if let myURL = NSURL(string: myURLString) {
                do {
                    let myHTMLString = try NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding)
                    self.html_program_content = myHTMLString
                } catch {
                    print("Error getting program html: \(error)")
                    self.html_content = ""
                }
            }
        }
    }
    
    func parseMetadata(){
        if self.html_content == "" { return }
        
        // Extract artist, track and program id from stored html content
        var artist:NSString = ""
        var track:NSString = ""
        var started:NSDate
        var string = self.html_content
        string = string.substringFromIndex(17)
        string = string.substringToIndex(string.length - 1)
        let jsonData = string.dataUsingEncoding(NSUTF8StringEncoding)
        var json:NSDictionary = [:]
        do {
            json = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        } catch {}
        let realtimeJson = json["realtime"] as? NSDictionary
        artist = (realtimeJson!["artist"] as? NSString)!
        track = (realtimeJson!["title"] as? NSString)!
        let r_seconds_ago:Int = realtimeJson!["seconds_ago"] as! Int
        let now = NSDate()
        started = now.dateByAddingTimeInterval(NSTimeInterval(-r_seconds_ago))
        self.addToRecentMetadata(artist, track:track, started:started)
        program_id = (realtimeJson!["episode_pid"] as? NSString)!
    }
    
    func parseProgramMetadata(){
        // Extract program name from stored program page html content
        if self.html_program_content == "" { return }
        var processed_string = self.html_program_content.componentsSeparatedByString("<span class=\"titling-title-inline-1\">")[1]
        let presenter:NSString = processed_string.componentsSeparatedByString("</span><span class=\"titling-title-inline-2\">")[0]
        processed_string = processed_string.componentsSeparatedByString("</span><span class=\"titling-title-inline-2\">")[1]
        let name:NSString = processed_string.componentsSeparatedByString("</span>")[0]
        self.program_name = (presenter as String) + " - " + (name as String)
    }
    
    func addToRecentMetadata(artist:NSString, track:NSString, started:NSDate){
        if (self.recent_metadata.count == 0){
            self.recent_metadata.append(["artist": artist, "track": track, "started": started])
        } else {
            if !artist.isEqualToString(self.recent_metadata[self.recent_metadata.count - 1]["artist"] as! String) && !track.isEqualToString(self.recent_metadata[self.recent_metadata.count - 1]["track"] as! String){
                self.recent_metadata.append(["artist": artist, "track": track, "started": started])
            }
        }
        if (self.recent_metadata.count > 5) {
            self.recent_metadata.removeAtIndex(0)
        }
    }
    
    func updateLabels() {
        var label_contents = ""
        for element in self.recent_metadata.reverse() {
            let artist:NSString = element["artist"]! as! NSString
            let track:NSString = element["track"]! as! NSString
            let now = NSDate()
            let started:NSDate = element["started"]! as! NSDate
            let seconds_ago = now.timeIntervalSinceDate(started)
            let mintues_ago:Int = Int(seconds_ago / 60.0)
            label_contents += "\(artist) - \(track) - \(mintues_ago) minutes ago\n"
        }
        self.setLabelText(label_contents)
        self.setProgrameNameLabelText(self.program_name as String)
    }
}

