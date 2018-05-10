//
//  TrailerController.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-27.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit
import FirebaseDatabase


let imageFetchUrlHeader = "https://image.tmdb.org/t/p/w500"

class TrailerController: UIViewController {
    let trailerCell = "trailerCell"
    let trailerHeaderCell = "trailerHeaderCell"
    
    static var movies : [Movie] = [Movie]()
    
    @IBOutlet var trailerCollectionView: UICollectionView!

    @IBOutlet var imagesCarousel: UIScrollView!
    
    @IBOutlet var pageIndicator: UIPageControl!
    
    var imagesForCarousel: [Movie] = [Movie]()
    
    var popularMoviesInBoxOffice : [Movie] = [Movie]()
    
    var upcomingMovies : [Movie] = [Movie]()
    
    var topRatedMovies : [Movie] = [Movie]()
    
    var moviesReleasedLessThanMonth : [Movie] = [Movie]()
    
    var selectedMovie : Movie?
    
    var headerSelected : Int?
    
    var imageContentWidthForScrollView : CGFloat = 0.0
    
    var timerForCarousel : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupCarousel()
        
        fetchTopRated()
        fetchPopular()
        fetchUpComing()
    }
    
    private func fetchUpComing() {
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=24cfbd59fbd336bfd1a218ec40733d66&language=en-US&page=1"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    return
                }
                
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    if let results = dictionary!["results"] as? [AnyObject] {
                        for movieObj in results {
                            let movie = Movie(dictionary: (movieObj as? [String: Any])!)
                            self.upcomingMovies.append(movie)
                            // fetch runtime from separate API
                            self.fetchMovieWith(movie.id!) { (movie) in
                                self.upcomingMovies.first(where: { (element) -> Bool in
                                    return element.id == movie.id
                                })?.runtime = movie.runtime
                            }   
                        }
                        
                        DispatchQueue.main.async {
                            TrailerController.movies += self.upcomingMovies
                            self.sortByReleaseDay(movies: &TrailerController.movies)
                            self.attempToReloadCollection()
                        }
                    }
                } catch {
                    
                }
            })
            task.resume()
        }
    }
    
    private func fetchTopRated() {
        let urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=24cfbd59fbd336bfd1a218ec40733d66&language=en-US&page=1"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    return
                }
                
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    if let results = dictionary!["results"] as? [AnyObject] {
                        for movieObj in results {
                            let movie = Movie(dictionary: movieObj as! [String : Any])
                            self.topRatedMovies.append(movie)
                            // fetch runtime from separate API
                            self.fetchMovieWith(movie.id!) { (movie) in
                                self.topRatedMovies.first(where: { (element) -> Bool in
                                    return element.id == movie.id
                                })?.runtime = movie.runtime
                            }
                        }
                        
                        DispatchQueue.main.async {
                            if self.topRatedMovies.count > 6 {
                                for i in 0..<self.topRatedMovies.count {
                                    if i == 5 { break }
                                    self.imagesForCarousel.append(self.topRatedMovies[i])
                                }
                                
                                self.setupCarousel()
                            }
                            self.attempToReloadCollection()
                        }
                    }
                } catch {
                    
                }
            })
            task.resume()
        }
    }
    
    private func fetchPopular() {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=24cfbd59fbd336bfd1a218ec40733d66&language=en-US&page=1"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    return
                }
                
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    if let results = dictionary!["results"] as? [AnyObject] {
                        for movieObj in results {
                            let movie = Movie(dictionary: (movieObj as? [String: Any])!)
                            self.popularMoviesInBoxOffice.append(movie)
                            // fetch runtime from separate API
                            self.fetchMovieWith(movie.id!) { (movie) in
                                self.popularMoviesInBoxOffice.first(where: { (element) -> Bool in
                                    return element.id == movie.id
                                })?.runtime = movie.runtime
                            }
                        }
                        
                        DispatchQueue.main.async {
                            TrailerController.movies += self.popularMoviesInBoxOffice
                            self.sortByReleaseDay(movies: &TrailerController.movies)
                            
                            self.attempToReloadCollection()
                        }
                    }
                } catch {
                    
                }
            })
            task.resume()
        }
    }
    
    func setupNavigation() {
        navigationItem.title = "Menu Page"
        colorNavigationBar(barColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), tintColor: .orange)
        setupButtonsOnNavigationBar()
    }
    
    func setupButtonsOnNavigationBar() {
        let leftButton = createNavigationButton()
        leftButton.addTarget(self, action: #selector(openTrailCollectionView), for: .touchUpInside)
        leftButton.setTitle("Trailers", for: .normal)
        leftButton.layer.borderColor = UIColor.orange.cgColor
        leftButton.layer.borderWidth = 2
        leftButton.frame = CGRect(x: 0, y: 430, width: 70, height: 40)
        let rightButton = createNavigationButton()
        rightButton.setImage(UIImage(named: "magnifier")?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightButton.tintColor = .orange
        rightButton.frame = CGRect(x: 0, y: 430, width: 40, height: 40)
        rightButton.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    @objc func openSearch() {
        performSegue(withIdentifier: "openSearchPage", sender: self)
    }
    
    func createNavigationButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(.orange, for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        
        return button
    }
    
    @objc func openTrailCollectionView(gesture: UITapGestureRecognizer) {
        performSegue(withIdentifier: "openTrailerVideoPage", sender: self)
    }
    
    var timer : Timer?

    func attempToReloadCollection() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.08, target: self, selector: #selector(self.handleReloadCollection), userInfo: nil, repeats: false)
    }

    @objc func handleReloadCollection() {
        DispatchQueue.main.async {
            self.trailerCollectionView.reloadData()
        }
    }
}

extension TrailerController: UIScrollViewDelegate {
    func setupCarousel() {
        imagesCarousel.delegate = self
        imagesCarousel.showsHorizontalScrollIndicator = false
        imagesCarousel.isPagingEnabled = true
        setupPageIndicator()
        if imagesForCarousel.count == 0 {
            let imageView = TrailerCellImageView()
            imagesCarousel.addSubview(imageView)
            imageView.addSubview(imageView.activityIndicatior)
            imageView.activityIndicatior.centerYAnchor.constraint(equalTo: imagesCarousel.centerYAnchor).isActive = true
            imageView.activityIndicatior.centerXAnchor.constraint(equalTo: imagesCarousel.centerXAnchor).isActive = true
        } else {
            for i in 0..<imagesForCarousel.count {
                let imageView = UIImageView()
                if let post_path = imagesForCarousel[i].poster_path {
                    let urlString = imageFetchUrlHeader + post_path
                    imageView.loadImageUsingCacheWithUrlString(urlString: urlString)
                }
                imageView.contentMode = .scaleToFill
                let xPosition = self.view.frame.width * CGFloat(i)
                imageView.frame = CGRect(x: xPosition, y: 0, width: imagesCarousel.frame.width, height: view.frame.height * 0.35)
                imagesCarousel.contentSize.width = imagesCarousel.frame.width * (CGFloat(i) + 1)
                imageContentWidthForScrollView += imagesCarousel.frame.width
                imagesCarousel.addSubview(imageView)
            }
            
            setupAutomateSlider()
        }
    }
    
    func setupAutomateSlider() {
        var currentPage : CGFloat = 0.0
        timerForCarousel = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            if currentPage != CGFloat(self.imagesForCarousel.count) {
                // if there is next page to go
                self.animateSlider(currentPage: currentPage, completion: {
                    currentPage += 1.0
                })
            } else {
                // if there is no next page
                currentPage = 0.0
                self.animateSlider(currentPage: currentPage, completion: {
                    currentPage += 1.0
                })
            }
        })
    }
    
    func animateSlider( currentPage: CGFloat, completion: @escaping () -> Void ) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.imagesCarousel.contentOffset.x = currentPage * (self.imageContentWidthForScrollView / CGFloat(self.imagesForCarousel.count))
        }, completion: { (completed) in
            completion()
        })
    }
    
    func setupPageIndicator() {
        imageContentWidthForScrollView = 0.0
       pageIndicator.numberOfPages = imagesForCarousel.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageIndicator.currentPage = Int((imagesCarousel.contentOffset.x) / CGFloat(imageContentWidthForScrollView / CGFloat((imagesForCarousel.count))))
    }
}

extension TrailerController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trailerCell, for: indexPath) as! TrailerCell
        setupActivityIndicator(cell: cell)
        
        if indexPath.section == 0 {
            setupForFirstSection(cell: cell, indexPath: indexPath)
        } else if indexPath.section == 1 {
            setupForSecondSection(cell: cell, indexPath: indexPath)
        } else if indexPath.section == 2 {
            setupForThridSection(cell: cell, indexPath: indexPath)
        }
        
        setupGestureRecognizer(cell: cell)
        return cell
    }
    
    func setupForThridSection(cell: TrailerCell, indexPath: IndexPath) {
        if upcomingMovies.count > 6 {
            if cell.movie == nil {
                cell.movie = popularMoviesInBoxOffice[indexPath.item]
            }
            adjustLabelToFitTitle(title:  (cell.movie?.original_title)!, cell: cell)
            if let post_path = cell.movie?.poster_path {
                let urlString = imageFetchUrlHeader + post_path
                cell.moviePostImageVIew.loadImageUsingCacheWithUrlString(urlString: urlString)
            }
        }
    }
    
    func setupForSecondSection(cell: TrailerCell, indexPath: IndexPath) {
        if popularMoviesInBoxOffice.count > 6 {
            if cell.movie == nil {
                cell.movie = popularMoviesInBoxOffice[indexPath.item]
            }
            adjustLabelToFitTitle(title:  (cell.movie?.original_title)!, cell: cell)
            if let post_path = cell.movie?.poster_path {
                let urlString = imageFetchUrlHeader + post_path
                cell.moviePostImageVIew.loadImageUsingCacheWithUrlString(urlString: urlString)
            }
        }
    }
    
    func setupForFirstSection(cell: TrailerCell, indexPath: IndexPath) {
        if topRatedMovies.count > 6 {
            if cell.movie == nil {
                cell.movie = topRatedMovies[indexPath.item]
            }
            let title = cell.movie?.original_title
            adjustLabelToFitTitle(title: title!, cell: cell)
            if let post_path = cell.movie?.poster_path {
                let urlString = imageFetchUrlHeader + post_path
                cell.moviePostImageVIew.loadImageUsingCacheWithUrlString(urlString: urlString)
            }
        }
    }
    
    func setupGestureRecognizer(cell: TrailerCell) {
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDetailPage)))
    }
    
    @objc func showDetailPage(gesture: UITapGestureRecognizer) {
        if let view = gesture.view as? TrailerCell {
            selectedMovie = view.movie
            performSegue(withIdentifier: "movieDetailSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openTrailerVideoPage" {
            // when trailer button is clicked
            if let trailerVideoVC = segue.destination as? TrailerVideosController {
                trailerVideoVC.trailerController = self
            }
        } else if segue.identifier == "movieDetailSegue" {
            // when each one of the movie's post it clicked
            let nav = segue.destination as! UINavigationController
            let movieDetailVC = nav.topViewController as! MovieDetailViewController
            movieDetailVC.movie = selectedMovie
            selectedMovie = nil
        } else if segue.identifier == "openMovieCollectionPage" {
            // when each one of the section header is clicked
            if let movieCollectionVC = segue.destination as? MoviesCollectionViewController {
                if headerSelected == 0 {
                    movieCollectionVC.navigationItem.title = "In Theaters"
                    movieCollectionVC.movies = topRatedMovies
                } else if headerSelected == 1 {
                    movieCollectionVC.navigationItem.title = "Top box office"
                    movieCollectionVC.movies = popularMoviesInBoxOffice
                } else if headerSelected == 2 {
                    // when favorite header is clicked
                    movieCollectionVC.navigationItem.title = "Upcoming Movies"
                    movieCollectionVC.movies = upcomingMovies
                }
            }
        } else if segue.identifier == "openSearchPage" {
            // when magnifier icon is clicked
            if let searchPageVC = segue.destination as? SearchViewController {
                searchPageVC.movies = TrailerController.movies
                searchPageVC.navigationItem.title = "Search"
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: trailerHeaderCell, for: indexPath) as! TrailerHeaderCell
        setupEventWhenTouched(headerCell: headerCell)
        headerCell.tag = indexPath.section
        if indexPath.section == 0 {
            headerCell.headerNameLabel.text = "In Theaters"
        } else if indexPath.section == 1 {
            headerCell.headerNameLabel.text = "Top box office"
        } else if indexPath.section == 2 {
            headerCell.headerNameLabel.text = "Upcoming Movies"
        }
        
        return headerCell
    }
    
    func setupEventWhenTouched (headerCell: TrailerHeaderCell) {
        headerCell.isUserInteractionEnabled = true
        headerCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHeaderClicked)))
    }
    
    @objc func handleHeaderClicked(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? TrailerHeaderCell {
            headerSelected = cell.tag
            performSegue(withIdentifier: "openMovieCollectionPage", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: view.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
