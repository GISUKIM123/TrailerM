//
//  SearchViewController.swift
//  TrailerM
//
//  Created by gisu kim on 2018-05-01.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {
    let searchCell = "searchCell"
    
    var filteredMoviesInSearchbar : [Movie]?
    
    var movies : [Movie]? {
        didSet {
            filteredMoviesInSearchbar = movies!
        }
    }
    
    @IBOutlet var resultTableView: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    var movieSelected : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupEventWhenTouched(cell: UITableViewCell) {
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDetailPageWithMovieSelected)))
    }
    
    @objc func openDetailPageWithMovieSelected(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? UITableViewCell {
            movieSelected = filteredMoviesInSearchbar?[cell.tag]
            performSegue(withIdentifier: "openDetailPageFromSearchPage", sender: self)
            movieSelected = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDetailPageFromSearchPage" {
            let nav = segue.destination as! UINavigationController
            if let movieDetailPageVC = nav.topViewController as? MovieDetailViewController {
                movieDetailPageVC.movie = movieSelected
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMoviesInSearchbar?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCell, for: indexPath) as! SearchViewCell
        setupEventWhenTouched(cell: cell)
        setupCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func setupCell(cell: SearchViewCell, indexPath: IndexPath) {
        if let post_path = filteredMoviesInSearchbar![indexPath.row].poster_path {
            let urlString = imageFetchUrlHeader + post_path
            cell.searchViewCellImageView.loadImageUsingCacheWithUrlString(urlString: urlString)
        }
        cell.searchViewCellLabel.numberOfLines = 3
        cell.searchViewCellLabel.text = filteredMoviesInSearchbar![indexPath.row].original_title
        cell.tag = indexPath.row
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredMoviesInSearchbar = movies!
            resultTableView.reloadData()
            return
        }
        
        filteredMoviesInSearchbar = (movies?.filter({ (movie) -> Bool in
            (movie.original_title?.lowercased().contains(searchText.lowercased()))!
        }))!
        
        resultTableView.reloadData()
    }
}
