//
//  TrailerViewController.swift
//  Flix
//
//  Created by Harjas Monga on 1/21/18.
//  Copyright © 2018 Harjas Monga. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import AVKit

class TrailerViewController: UIViewController {

    @IBOutlet weak var youtubePlayerView: YTPlayerView!
    
    var movieId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
        } catch {
        }
        getData()
    }

    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getData() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/" + String(movieId) + "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let alertViewController = UIAlertController(title: "Error", message: "Could not connect to Movie Database", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let tryAgain = UIAlertAction(title: "Try Again", style: .default, handler: { action in
            self.getData()
        })
        alertViewController.addAction(tryAgain)
        alertViewController.addAction(cancelAction)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                self.present(alertViewController, animated: true, completion: nil)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let results = dataDictionary["results"] as! [[String: Any]]
                let firstResult = results[0]
                let videoId = firstResult["key"] as! String
                self.youtubePlayerView.load(withVideoId: videoId)
                self.youtubePlayerView.playVideo()

            }
        }
        task.resume()
    }

}
