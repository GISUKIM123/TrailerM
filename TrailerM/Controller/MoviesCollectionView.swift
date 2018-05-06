//
//  MoviesCollectionView.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-29.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class MoviesCollectionViewController: UICollectionViewController {
    let moviesCollectionCell = "moviesCollectionCell"
    
    var movies : [Movie]?
    
    var movieSelected : Movie?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailSegueFromMovieCollectionPage" {
            let nav = segue.destination as! UINavigationController
            if let movieDetailVC = nav.topViewController as? MovieDetailViewController {
                movieDetailVC.movie = movieSelected
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCollectionCell", for: indexPath) as! MoviePostCell
       setupCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func setupCell(cell: MoviePostCell, indexPath: IndexPath) {
        cell.movie =  movies![indexPath.item]
        if let post_path = movies![indexPath.item].poster_path {
            let urlString = imageFetchUrlHeader + post_path
            cell.moviePostImageView.loadImageUsingCacheWithUrlString(urlString: urlString)
        }
        cell.moviePostTiltleLabel.text = movies![indexPath.item].original_title
        cell.moviePostDescriptionTextView.textContainer.lineBreakMode = .byTruncatingTail
        cell.moviePostDescriptionTextView.text = movies![indexPath.item].overview
        cell.moviePostDateLabel.text = formatDate(dateString: movies![indexPath.item].release_date!)
        setupEventWhenTouched(cell: cell)
        setupBottomBorder(cell: cell)
    }
    
    func setupEventWhenTouched(cell: MoviePostCell) {
        
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDetailPageWithMovieSelected)))
    }
    
    @objc func openDetailPageWithMovieSelected(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? MoviePostCell {
            movieSelected = cell.movie
            performSegue(withIdentifier: "movieDetailSegueFromMovieCollectionPage", sender: self)
            movieSelected = nil
        }
    }
    
}
