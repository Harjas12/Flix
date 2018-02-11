//
//  DetailViewController.swift
//  Flix
//
//  Created by Harjas Monga on 1/16/18.
//  Copyright © 2018 Harjas Monga. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class DetailViewController: UIViewController {

    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
        var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Detail"
        if let movie = movie {
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.text = movie.title
            releaseDateLabel.text = movie.releaseDate
            descriptionTextView.text = movie.description
            backDropImageView.af_setImage(withURL: (movie.backDropUrl!))
            posterImageView.af_setImage(withURL: (movie.posterUrl!))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! TrailerViewController
        destinationViewController.movieId = movie!.id
    }


}
