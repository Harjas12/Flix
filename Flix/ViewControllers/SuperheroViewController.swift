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
    
    var movies: [[String: Any]] = []
    let refreshControl = UIRefreshControl()
    
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
        if let posterPathString = movie["poster_path"] as? String {
            let baseUrlPath = "https://image.tmdb.org/t/p/w500"
            let posterPath = URL(string: baseUrlPath + posterPathString)
            cell.posterImageView.af_setImage(withURL: posterPath!)
            
        }
        
        
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
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=12%2C%2028%2C%20878&without_genres=14%2C%2053")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
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
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                self.present(alertViewController, animated: true, completion: nil)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                self.movies = dataDictionary["results"] as! [[String: Any]]
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
            if useActivityIndicator {
                self.activityIndicator.stopAnimating()
                self.loadingView.isHidden = true
            }
        }
        task.resume()
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getData(useActivityIndicator: false)
    }
}
