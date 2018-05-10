//
//  CalendarController.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-27.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class CalendarController: UIViewController {
    let calendarMoviePostCell = "calendarMoviePostCell"
    let calendarHeaderCell = "calendarHeaderCell"
    
    @IBOutlet var calendarCollectionView: UICollectionView!
    
    var movies : [Movie] = [Movie]()
    var headerDates : [String]?
    
    var moivesSeparatedByDate : [[Movie]]?
    
    var selectedMovie : Movie?
    
    let dateFormat = DateFormatter()
    override func viewWillAppear(_ animated: Bool) {
        movies = TrailerController.movies
        sortByReleaseDay(movies: &movies)
        setupDistinctiveDates()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupDistinctiveDates() {
        
        headerDates = [String]()
        moivesSeparatedByDate = [[Movie]]()
        
        var previousMonth : String = ""
        for i in 0..<(movies.count - 1) {
            dateFormat.dateFormat = "yyyy-MM-dd"
            if let date = dateFormat.date(from: movies[i].release_date!) {
                dateFormat.dateFormat = "MMM yyyy"
                let movie1Date = dateFormat.string(from: date)
                if previousMonth != movie1Date {
                    headerDates?.append(movie1Date)
                    previousMonth = movie1Date
                    
                    var newDateMovies = [Movie]()
                    newDateMovies.append(movies[i])
                    moivesSeparatedByDate?.append(newDateMovies)
                } else {
                    moivesSeparatedByDate![(moivesSeparatedByDate?.count)! - 1].append(movies[i])
                }
            }
        }
        
        calendarCollectionView.reloadData()
    }
    
}

extension CalendarController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return headerDates?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = headerDates?.count {
            for index in 0..<count {
                if section == index {
                    return moivesSeparatedByDate![index].count
                }
            }
        }
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarMoviePostCell, for: indexPath) as! MoviePostCell
        setupCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func setupCell(cell: MoviePostCell, indexPath: IndexPath) {
        cell.calendarMovieTitle.text = moivesSeparatedByDate![indexPath.section][indexPath.item].original_title!
        if let post_path = moivesSeparatedByDate![indexPath.section][indexPath.item].poster_path {
            let urlString = imageFetchUrlHeader + post_path
            cell.calendarMoiveImageView.loadImageUsingCacheWithUrlString(urlString: urlString)
        }
        cell.calendarMovieDescriptionView.text = moivesSeparatedByDate![indexPath.section][indexPath.item].overview!
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDetailPage)))
        cell.movie = moivesSeparatedByDate![indexPath.section][indexPath.item]
    }
    
    @objc func openDetailPage(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? MoviePostCell {
            selectedMovie = cell.movie
            performSegue(withIdentifier: "openDetailFromCalendarPage", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDetailFromCalendarPage" {
            let nav = segue.destination as! UINavigationController
            let movieDetailVC = nav.topViewController as! MovieDetailViewController
            movieDetailVC.movie = selectedMovie
            selectedMovie = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: calendarHeaderCell, for: indexPath) as! TrailerHeaderCell
        if let count = headerDates?.count {
            for index in 0..<count {
                if indexPath.section == index {
                    headerCell.calendarMovieDateLabel.text = headerDates![index]
                    return headerCell
                }
            }
        }
        
        
        return headerCell
    }
    
}


