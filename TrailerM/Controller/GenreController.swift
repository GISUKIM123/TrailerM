//
//  FavoriteController.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-27.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

var navHeight : CGFloat?

class GenreController: UIViewController, UIScrollViewDelegate {
    let genreCell = "genreCell"
    
    @IBOutlet var genreCollectionView: UICollectionView!
    
    var movies : [Movie]?
    
    var sortedMovies : [Movie]?
    
    var selectedMovie : Movie?
    
    var genres : [Genre]?
    
    var selectedGenre : Genre?
    
    var nextPageNumber : Int = 1
    
    var isFetching : Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        movies = TrailerController.movies
        if sortedMovies == nil {
            sortedMovies = movies?.filter({ (movie) -> Bool in
                return Double(movie.vote_average ?? 0) > 7
            })
            
            genreCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchGenreList()
        
        navigationItem.title = "Genre"
        setupGenreButton()
        colorNavigationBar(barColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), tintColor: .orange)
    }
    
    func fetchGenreList() {
        genres = [Genre]()
        if let request = createRequest(urlString: "https://api.themoviedb.org/3/genre/movie/list?api_key=24cfbd59fbd336bfd1a218ec40733d66&language=en-US"){
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    return
                }
                
                do {
                    let data = try JSONSerialization.jsonObject(with: data!, options: [])
                    guard let dictionary = data as? [String : Any] else {
                        return
                    }
                    
                    if let genresArray = dictionary["genres"] as? [AnyObject] {
                        for rawGenreData in genresArray {
                            let genre = Genre(dictionary: rawGenreData as! [String : Any])
                            self.genres?.append(genre)
                        }
                    }
                }catch {
                    
                }
            }.resume()
        }
    }
    
    var leftBarButton : UIBarButtonItem?
    
    func setupGenreButton() {
        let button = UIButton()
        button.addTarget(self, action: #selector(slideInGenreView), for: .touchUpInside)
        button.setImage(UIImage(named: "menuButton_genrepage"), for: .normal)
        button.tintColor = .orange
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 40)
        leftBarButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    var slideInGenreViewLauncher : SlideInGenreView?
    
    @objc func slideInGenreView() {
        slideInGenreViewLauncher = SlideInGenreView()
        slideInGenreViewLauncher?.genreController = self
        navHeight = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!
        setupContainerViewForSlider()
        slideInGenreViewLauncher?.blackView = blackView
        slideInGenreViewLauncher?.shoowSlider()
    }
    
    var blackView : UIView?
    
    func setupContainerViewForSlider() {
        blackView = UIView()
        blackView?.isUserInteractionEnabled = true
        blackView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissSliderContainerView)))
        if leftBarButton?.customView?.transform == .identity {
            UIView.animate(withDuration: 0.4) {
                self.navigationItem.leftBarButtonItem?.customView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.navigationItem.leftBarButtonItem?.customView?.transform = CGAffineTransform(rotationAngle: 180 * (.pi / 180))
            }
            
        }
    }
    
    @objc func handleDismissSliderContainerView() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            if self.leftBarButton?.customView?.transform != .identity {
                self.leftBarButton?.customView?.transform = .identity
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            // animate slider to dismiss
            self.slideInGenreViewLauncher?.genreView?.frame = CGRect(x: -(self.view.frame.width * 0.7), y: navHeight!, width: self.view.frame.width * 0.7, height: self.view.frame.height)
        }, completion: {(completed) in
            self.blackView?.removeFromSuperview()
        })
    }
    
    func handleGenreSelected(genre: Genre) {
        sortedMovies = movies?.filter({ (movie) -> Bool in
            return (movie.genre?.name) == genre.name
        })
        
        resetNextPageNumber()
        selectedGenre = genre
        
        fetchMoreByGenre(id: genre.id!)
        
        navigationItem.title = genre.name
        
        handleDismissSliderContainerView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = genreCollectionView.frame.size.height
        let scrollContentSizeHeight = genreCollectionView.contentSize.height
        let scrollOffset = genreCollectionView.contentOffset.y

        if (scrollOffset + scrollViewHeight > scrollContentSizeHeight) {
            // then we are at the end
            
            if !isFetching {
                isFetching = true
                fetchMoreByGenre(id: selectedGenre?.id ?? 35)
            }
        }
    }
    
    func fetchMoreByGenre(id: Int) {
        if let request = createRequest(urlString: "https://api.themoviedb.org/3/genre/\(id)/movies?api_key=24cfbd59fbd336bfd1a218ec40733d66&language=en-US&include_adult=false&sort_by=created_at.asc&page=\(nextPageNumber)") {
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    return
                }
                
                do {
                    let dataJson = try JSONSerialization.jsonObject(with: data!, options: [])
                    guard let dictionary = dataJson as? [String : Any] else { return }
                    if let movies = dictionary["results"] as? [AnyObject] {
                        for movieDictionary in movies {
                            let movieUnderGenreSelected = Movie(dictionary: movieDictionary as! [String : Any])
                            self.sortedMovies?.append(movieUnderGenreSelected)
                            // fetch runtime from separate API
                            self.fetchMovieWith(movieUnderGenreSelected.id!) { (movie) in
                                self.sortedMovies?.first(where: { (element) -> Bool in
                                    return element.id == movie.id
                                })?.runtime = movie.runtime
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.nextPageNumber += 1
                        self.isFetching = false
                        self.genreCollectionView.reloadData()
                    }
                }catch {
                    
                }
            }.resume()
        }
    }
    
    func resetNextPageNumber() {
        nextPageNumber = 1
    }
}

extension GenreController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedMovies?.count ?? 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: genreCell, for: indexPath) as! GenreCell
        setupActivityIndicator(cell: cell)
        setupCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func setupCell(cell: GenreCell, indexPath: IndexPath) {
        if sortedMovies?.count != 0 {
            if let post_path = sortedMovies![indexPath.item].poster_path {
                let urlString = imageFetchUrlHeader + post_path
                cell.moviePostImageView.loadImageUsingCacheWithUrlString(urlString: urlString)
                adjustLabelToFitTitle(title: sortedMovies![indexPath.item].original_title!, cell: cell)
                cell.tag                        = indexPath.item
                cell.isUserInteractionEnabled   = true
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePostClicked)))
            }
        }
    }
    
    @objc func handlePostClicked(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? GenreCell {
            selectedMovie = sortedMovies![cell.tag]
            performSegue(withIdentifier: "openDetailPageFromGenreController", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDetailPageFromGenreController" {
            let nav = segue.destination as! UINavigationController
            if let movieDetailVC = nav.topViewController as? MovieDetailViewController {
                movieDetailVC.movie     = selectedMovie
                selectedMovie           = nil
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: view.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
