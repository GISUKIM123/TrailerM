//
//  GenreController_DataFetch.swift
//  TrailerM
//
//  Created by gisu kim on 2018-05-11.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

// fetch data

extension GenreController {
    func fetchGenreList() {
        genres = [Genre]()
        if genres?.count == 0 {
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
