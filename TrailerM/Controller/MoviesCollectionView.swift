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
    
    var isFetching : Bool = false
    
    var nextPageNumber : Int = 2
    
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
    
    private func fetchMoreMoveisWithCollectionName() {
        if navigationItem.title?.lowercased() == "Upcoming movies".lowercased() {
            fetchMoreMovies(urlString: "https://api.themoviedb.org/3/movie/upcoming?api_key=24cfbd59fbd336bfd1a218ec40733d66&language=en-US&page=\(nextPageNumber)")
        } else if navigationItem.title?.lowercased() == "Top Box Office".lowercased() {
            fetchMoreMovies(urlString: "https://api.themoviedb.org/3/movie/popular?api_key=24cfbd59fbd336bfd1a218ec40733d66&language=en-US&page=\(nextPageNumber)")
        } else if navigationItem.title?.lowercased() == "In Theaters".lowercased() {
            fetchMoreMovies(urlString: "https://api.themoviedb.org/3/movie/top_rated?api_key=24cfbd59fbd336bfd1a218ec40733d66&language=en-US&page=\(nextPageNumber)")
        }
    }
    
    private func fetchMoreMovies(urlString: String) {
        if let request = createRequest(urlString: urlString) {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    return
                }
                
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    if let results = dictionary!["results"] as? [AnyObject] {
                        for movieObj in results {
                            let movie = Movie(dictionary: (movieObj as? [String: Any])!)
                            self.movies?.append(movie)
                        }
                        
                        DispatchQueue.main.async {
                            self.nextPageNumber += 1
                            self.collectionView?.reloadData()
                        }
                    }
                } catch {
                    
                }
            }).resume()
        }
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrollViewHeight = collectionView?.frame.size.height else { return }
        guard let scrollContentSizeHeight = collectionView?.contentSize.height else { return }
        guard let scrollOffset = collectionView?.contentOffset.y else { return }
        
        if (scrollOffset + scrollViewHeight > scrollContentSizeHeight) {
            if !isFetching {
                isFetching = true
                fetchMoreMoveisWithCollectionName()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCollectionCell", for: indexPath) as! MoviePostCell
        setupActivityIndicator(cell: cell)
        setupCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func setupCell(cell: MoviePostCell, indexPath: IndexPath) {
        cell.movie =  movies![indexPath.item]
        if let post_path = movies![indexPath.item].poster_path {
            let urlString = imageFetchUrlHeader + post_path
            cell.moviePostImageView.loadImageUsingCacheWithUrlString(urlString: urlString)
        }
        
        adjustLabelToFitTitle(title: movies![indexPath.item].original_title!, cell: cell)
        cell.moviePostDescriptionTextView.textContainer.lineBreakMode   = .byTruncatingTail
        cell.moviePostDescriptionTextView.text                          = movies![indexPath.item].overview
        cell.moviePostDateLabel.text                                    = formatDate(dateString: movies![indexPath.item].release_date!)
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
