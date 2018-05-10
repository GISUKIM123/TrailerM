//
//  MoviePostView.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-29.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class MoviePostCell: UICollectionViewCell {
    var movie : Movie?
    @IBOutlet var moviePostDateLabel: UILabel!
    @IBOutlet var moviePostDescriptionTextView: UITextView!
    @IBOutlet var moviePostTiltleLabel: UILabel!
    @IBOutlet var moviePostImageView: TrailerCellImageView!
    
    @IBOutlet var calendarMoiveImageView: UIImageView!
    @IBOutlet var calendarMovieTitle: UILabel!
    @IBOutlet var calendarMovieDescriptionView: UITextView!
}
