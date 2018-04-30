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
    
    @IBAction func movieCellIsClicked(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController")
        
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCollectionCell", for: indexPath) as! MoviePostCell
        
        
        return cell
    }
}
