//
//  SuperheroViewController.swift
//  Flix
//
//  Created by Harjas Monga on 1/20/18.
//  Copyright © 2018 Harjas Monga. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movies: [Movie] = []
    let refreshControl = UIRefreshControl()
    let api = MovieApiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self as UICollectionViewDataSource
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        getData(useActivityIndicator: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "posterCell", for: indexPath) as! PosterCell
        
        let movie = movies[indexPath.item]
        cell.posterImageView.af_setImage(withURL: movie.posterUrl!)
//        if let posterPathString = movie.posterUrl {
//            let baseUrlPath = "https://image.tmdb.org/t/p/w500"
//            let posterPath = URL(string: baseUrlPath + posterPathString)
//            cell.posterImageView.af_setImage(withURL: posterPath!)
//
//        }
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {
            let movie = movies[indexPath.item]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }

    func getData(useActivityIndicator: Bool) {
        if useActivityIndicator {
            loadingView.isHidden = false
            activityIndicator.startAnimating()
        }
        
        let alertViewController = UIAlertController(title: "Error", message: "Could not connect to Movie Database", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            self.refreshControl.endRefreshing()
        })
        let tryAgain = UIAlertAction(title: "Try Again", style: .default, handler: { action in
            self.getData(useActivityIndicator: false)
            self.refreshControl.endRefreshing()
            
        })
        alertViewController.addAction(tryAgain)
        alertViewController.addAction(cancelAction)
        
        api.superHeroMovies { (movies: [Movie]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.present(alertViewController, animated: true, completion: nil)
            } else if let movies = movies {
                self.movies = movies
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
            if useActivityIndicator {
                self.activityIndicator.stopAnimating()
                self.loadingView.isHidden = true
            }

        }
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getData(useActivityIndicator: false)
    }
}
