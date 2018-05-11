//
//  TrailerController_DataFetch.swift
//  TrailerM
//
//  Created by gisu kim on 2018-05-11.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

// fetch data

extension TrailerController {
    func attempToReloadCollection() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.08, target: self, selector: #selector(self.handleReloadCollection), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadCollection() {
        DispatchQueue.main.async {
            self.trailerCollectionView.reloadData()
        }
    }
    
    func addMovieToMovieList(movie: Movie) {
        if !(TrailerController.movies.first(where: { (element) -> Bool in
            return element.id == movie.id
        }) != nil) {
            TrailerController.movies.append(movie)
        }
    }
    
    func fetchTopRated() {
        if let request = createRequest(urlString: "https://api.themoviedb.org/3/movie/top_rated?api_key=24cfbd59fbd336bfd1a218ec40733d66&language=en-US&page=1") {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
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
                            
                            self.addMovieToMovieList(movie: movie)
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
            }).resume()
        }
    }
    
    func fetchPopular() {
        if let request = createRequest(urlString: "https://api.themoviedb.org/3/movie/popular?api_key=24cfbd59fbd336bfd1a218ec40733d66&language=en-US&page=1") {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
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
                            
                            self.addMovieToMovieList(movie: movie)
                        }
                        
                        DispatchQueue.main.async {
                            self.sortByReleaseDay(movies: &TrailerController.movies)
                            self.attempToReloadCollection()
                        }
                    }
                } catch {
                    
                }
            }).resume()
        }
    }
    
    func fetchUpComing() {
        if let request = createRequest(urlString: "https://api.themoviedb.org/3/movie/upcoming?api_key=24cfbd59fbd336bfd1a218ec40733d66&language=en-US&page=1") {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
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
                            self.addMovieToMovieList(movie: movie)
                        }
                        
                        DispatchQueue.main.async {
                            self.sortByReleaseDay(movies: &TrailerController.movies)
                            self.attempToReloadCollection()
                        }
                    }
                } catch {
                    
                }
            }).resume()
        }
    }
}

