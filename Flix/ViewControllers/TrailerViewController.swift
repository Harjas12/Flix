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
    let movieApiManager = MovieApiManager()
    
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
        
        let alertViewController = UIAlertController(title: "Error", message: "Could not connect to Movie Database", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let tryAgain = UIAlertAction(title: "Try Again", style: .default, handler: { action in
            self.getData()
        })
        alertViewController.addAction(tryAgain)
        alertViewController.addAction(cancelAction)
        
        movieApiManager.getVideoID(movieID: String(movieId)) { (videoID: String?, error: Error?) in
            if let videoID = videoID {
                self.youtubePlayerView.load(withVideoId: videoID)
                self.youtubePlayerView.playVideo()
            } else if let error = error {
                print(error.localizedDescription)
                self.present(alertViewController, animated: true, completion: nil)
            }
        }

    }

}
