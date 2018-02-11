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
    
    var movies: [Movie] = []
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
        
        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.movies = movies
                self.tableView.reloadData()
                self.tableView.separatorStyle = .singleLine
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            } else if let error = error {
                print(error.localizedDescription)
                self.present(alertViewController, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.movie = movies[indexPath.row]
        return cell
    }
    
    
}

