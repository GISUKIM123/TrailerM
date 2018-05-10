//
//  TrailerCell.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-27.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class TrailerCellImageView: UIImageView {
    let activityIndicatior : UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.isUserInteractionEnabled = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        
        return ai
    }()
}

class TrailerCell: UICollectionViewCell {
    
    var movie: Movie?
    
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var moviePostImageVIew: TrailerCellImageView!
}
