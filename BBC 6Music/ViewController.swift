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
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(BBC6MusicViewController.updateLabels), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLogoAlpha(_ alpha: CGFloat) {
        // Method to override in subclass
    }
    
    func setLabelText(_ text: String) {
        // Method to override in subclass
    }
    
    func setProgrameNameLabelText(_ text: String) {
        // Method to override in subclass
    }
    
    func setUp(){
        // Labels and metadata stuff
        self.adaptSizes()
        self.setLabelText("")
        self.setProgrameNameLabelText("")
        self.metadata_parser = BBC6MetadataParser()
        updateMetadata()
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(BBC6MusicViewController.updateMetadata), userInfo: nil, repeats: true)
        
        // Player stuff
        self.playerItem = AVPlayerItem(url:URL(string: "http://www.listenlive.eu/bbc6music.m3u")!)
        self.playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        self.player = AVPlayer(playerItem: self.playerItem)
    }
    
    func adaptSizes(){
        // TO be overriden in spciefic view controllers
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
        let artworkChanged = self.metadata_parser.parseArtworkLink()
        if artworkChanged {
            // Update image from self.metadata_parser.current_artwork_url
            print("Setting image \(self.metadata_parser.current_artwork_url)")
            self.downloadImage(url: URL(string: self.metadata_parser.current_artwork_url as String)!)
        }

    }
    
    func updateLabels() {
        var label_contents = ""
        for element in self.metadata_parser.recent_metadata.reversed() {
            let artist:NSString = element["artist"]! as! NSString
            let track:NSString = element["track"]! as! NSString
            let now = Date()
            let started:Date = element["started"]! as! Date
            let seconds_ago = now.timeIntervalSince(started)
            let minutes_ago:Int = Int(seconds_ago / 60.0)
            label_contents += "\(track) by \(artist) (\(minutes_ago) minutes ago)\n"
        }
        self.setLabelText(label_contents)
        self.setProgrameNameLabelText(self.metadata_parser.program_name as String)
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
                self.setImage(image: UIImage(data: data)!)
            }
        }
    }
    
    func setImage(image: UIImage) {
       // To be implemented in particular subclass
    }
}

