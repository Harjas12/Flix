//
//  File.swift
//  Flix
//
//  Created by Harjas Monga on 2/7/18.
//  Copyright © 2018 Harjas Monga. All rights reserved.
//

import Foundation

class Movie {
    var title: String
    var posterUrl: URL?
    var backDropUrl: URL?
    var description: String
    var releaseDate: String
    var id: Int
    
    init(dictionary: [String: Any], baseUrlPathForImages: String) {
        title = dictionary["title"] as? String ?? "No title"
        posterUrl = URL(string: baseUrlPathForImages + (dictionary["poster_path"] as! String))!
        description = dictionary["overview"] as? String ?? "No description"
        releaseDate = dictionary["release_date"] as? String ?? "Release Date Unknown"
        backDropUrl = URL(string: baseUrlPathForImages + (dictionary["backdrop_path"] as! String))!
        id = dictionary["id"] as! Int
    }
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary, baseUrlPathForImages: "https://image.tmdb.org/t/p/w500")
            movies.append(movie)
        }
        
        return movies
    }
}
