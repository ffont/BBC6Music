//
//  ViewController-OSX.swift
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
    var artworkNeedsUpdate:Bool = false
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var onOff: NSSegmentedControl!
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var artwork: NSImageView!

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
        let newItemWasAdded = self.metadata_parser.parseMetadata()
        if newItemWasAdded {
            // Send notification to the notification center
            // Send notification
            let notification = NSUserNotification()
            notification.title = self.metadata_parser.recent_metadata.reversed()[0]["track"] as? String
            notification.informativeText = self.metadata_parser.recent_metadata.reversed()[0]["artist"] as? String
            NSUserNotificationCenter.default.deliver(notification)
        }
        let artworkChanged = self.metadata_parser.parseArtworkLink()
        if (artworkChanged) {
            self.artworkNeedsUpdate = true
        }
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
        
        if (self.artworkNeedsUpdate && self.metadata_parser.current_artwork_url != "") {
            // Update image from self.metadata_parser.current_artwork_url
            print("Setting image \(self.metadata_parser.current_artwork_url)")
            downloadImage(url: URL(string: self.metadata_parser.current_artwork_url as String)!)
        }
    }
    
    // Functions to get image data asynchornously (from http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift)
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { () -> Void in
                self.artwork.image = NSImage(data: data)
                self.artworkNeedsUpdate = false
            }
        }
    }
}
