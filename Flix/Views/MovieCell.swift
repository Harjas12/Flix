//
//  MovieCell.swift
//  Flix
//
//  Created by Harjas Monga on 1/8/18.
//  Copyright © 2018 Harjas Monga. All rights reserved.
//

import UIKit
import AlamofireImage


class MovieCell: UITableViewCell {

    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            descLabel.text = movie.description
            posterImage.af_setImage(withURL: movie.posterUrl!)
            self.preservesSuperviewLayoutMargins = false
            self.separatorInset = UIEdgeInsets.zero
            self.layoutMargins = UIEdgeInsets.zero
        
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descLabel.preferredMaxLayoutWidth = descLabel.frame.size.width
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
