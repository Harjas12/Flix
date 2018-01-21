//
//  ViewController.swift
//  Flix
//
//  Created by Harjas Monga on 1/8/18.
//  Copyright © 2018 Harjas Monga. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    
    var movies: [[String: Any]] = []
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        getData(useActivityIndicator: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }
    func getData(useActivityIndicator: Bool) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                self.movies = dataDictionary["results"] as! [[String: Any]]
                self.tableView.reloadData()
                self.tableView.separatorStyle = .singleLine
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.descLabel.text = movie["overview"] as? String
        let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500/" + (movie["poster_path"] as! String))!
        cell.posterImage.af_setImage(withURL: posterUrl)
        return cell
    }
    
    
}

