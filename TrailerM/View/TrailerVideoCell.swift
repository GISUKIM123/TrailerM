//
//  TrailerVideoCell.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-30.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class TrailerVideoCell: UICollectionViewCell {
    
    var movie : Movie?
    
    @IBOutlet var trailerVideoDescription: UITextView!
    
    @IBOutlet var trailerVideoTitle: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var trailerVideoImageVIew: TrailerCellImageView!
    
    @IBOutlet var playButton: UIButton!
}
