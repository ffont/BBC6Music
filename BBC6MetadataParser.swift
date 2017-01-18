//
//  BBC6MetadataParser.swift
//  BBC 6Music
//
//  Created by Frederic Font Corbera on 08/01/16.
//  Copyright © 2016 Frederic Font Corbera. All rights reserved.
//

import Foundation

class BBC6MetadataParser {
    
    var html_content:NSString = ""
    var html_program_content:NSString = ""
    var program_id:NSString = ""
    var program_name:NSString = ""
    var recent_metadata: [NSDictionary] = []

    func getHTMLData(){
		let now = Date()
		let epoch = Int(now.timeIntervalSince1970)
		
        // Get track, artist name, and program id from realtime feed
        let myURLString = "http://polling.bbc.co.uk/radio/realtime/bbc_6music.jsonp?cachebash=\(epoch)"
		print("\(myURLString)")
        if let myURL = URL(string: myURLString) {
            do {
                let myHTMLString = try NSString(contentsOf: myURL, encoding: String.Encoding.utf8.rawValue)
                self.html_content = myHTMLString
            } catch {
                print("Error getting html: \(error)")
                self.html_content = ""
            }
        }
        // Get programme name from program id
        if program_id != ""{
            let myURLString = "http://www.bbc.co.uk/6music/"
            if let myURL = URL(string: myURLString) {
                do {
                    let myHTMLString = try NSString(contentsOf: myURL, encoding: String.Encoding.utf8.rawValue)
                    self.html_program_content = myHTMLString
                } catch {
                    print("Error getting program html: \(error)")
                    self.html_content = ""
                }
            }
        }
    }
    
    func parseMetadata() -> Bool {
        if self.html_content == "" { return false }
        
        // Extract artist, track and program id from stored html content
        var artist:NSString = ""
        var track:NSString = ""
        var started:Date
        var string = self.html_content
        string = string.substring(from: 17) as NSString
        string = string.substring(to: string.length - 1) as NSString
        let jsonData = string.data(using: String.Encoding.utf8.rawValue)
        var json:NSDictionary = [:]
        do {
            json = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        } catch {}
        let realtimeJson = json["realtime"] as? NSDictionary
        artist = (realtimeJson!["artist"] as? NSString)!
        track = (realtimeJson!["title"] as? NSString)!
        let r_seconds_ago:Int = realtimeJson!["seconds_ago"] as! Int
        let now = Date()
        started = now.addingTimeInterval(TimeInterval(-r_seconds_ago))
        let newItemWasAdded = self.addToRecentMetadata(artist, track:track, started:started)
        self.program_id = (realtimeJson!["episode_pid"] as? NSString)!
        return newItemWasAdded
    }
    
    func parseProgramMetadata(){
        // Extract program name from stored program page html content
        if self.html_program_content == "" { return }
        var processed_string = self.html_program_content.components(separatedBy: "<h3 class=\"on-air__episode-title\">")[1]
        let presenter:NSString = processed_string.components(separatedBy: "</h3>")[0] as NSString
        processed_string = processed_string.components(separatedBy: "<p class=\"on-air__episode-synopsis\">")[1]
        let name:NSString = processed_string.components(separatedBy: "</p>")[0] as NSString
        self.program_name = "\(presenter) \(name)" as NSString
    }
    
    func addToRecentMetadata(_ artist:NSString, track:NSString, started:Date) -> Bool {
        var newItemWasAdded = false
        if (self.recent_metadata.count == 0){
            self.recent_metadata.append(["artist": artist, "track": track, "started": started])
            newItemWasAdded = true
        } else {
            if !artist.isEqual(to: self.recent_metadata[self.recent_metadata.count - 1]["artist"] as! String) && !track.isEqual(to: self.recent_metadata[self.recent_metadata.count - 1]["track"] as! String){
                self.recent_metadata.append(["artist": artist, "track": track, "started": started])
                newItemWasAdded = true
            }
        }
        if (self.recent_metadata.count > 5) {
            self.recent_metadata.remove(at: 0)
        }
        return newItemWasAdded
    }
}
