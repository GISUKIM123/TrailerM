//
//  TrailerController.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-27.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class TrailerController: UIViewController {
    let trailerCell = "trailerCell"
    @IBOutlet var trailerCollectionView: UICollectionView!
    
    @IBOutlet var favoriteCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchMovies()
    }
    
    func fetchMovies() {
        if let url = URL(string: "https://theimdbapi.org/api/find/movie?title=transformers&year=2007") {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
        
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                
            }
            
            task.resume()
        }
        
        
    }
}

extension TrailerController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trailerCell, for: indexPath) as! TrailerCell
        
        cell.movieTitleLabel.text = "Gisu Kim"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: view.frame.height / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
