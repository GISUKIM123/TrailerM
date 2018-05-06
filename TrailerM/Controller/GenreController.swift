//
//  FavoriteController.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-27.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class GenreController: UIViewController {
    let genreCell = "genreCell"
    
    @IBOutlet var genreCollectionView: UICollectionView!
    
    
    @IBOutlet var segmentBar: UISegmentedControl!
    @IBAction func handleSegmentChanged(_ sender: Any) {
        genreCollectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        colorNavigationBar(barColor: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), tintColor: .orange)
    }
    
    
}

extension GenreController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: genreCell, for: indexPath) as! GenreCell
        if segmentBar.selectedSegmentIndex == 0 {
//            cell.moiveTitleLabel.text = "Transformers: The last king"
            adjustLabelToFitTitle(title: "Transformers: The last king", cell: cell)
            cell.moviePostImageView.image = UIImage(named: "moviePost2")
        } else if segmentBar.selectedSegmentIndex == 1 {
            adjustLabelToFitTitle(title: "Transformers: Age of Extinction", cell: cell)
            cell.moviePostImageView.image = UIImage(named: "moviePost3")
        } else if segmentBar.selectedSegmentIndex == 2 {
            adjustLabelToFitTitle(title: "Transformers: The New Start", cell: cell)
            cell.moviePostImageView.image = UIImage(named: "moviePost4")
        }
        
        cell.moiveTitleLabel.lineBreakMode = .byTruncatingTail
        cell.moiveTitleLabel.sizeToFit()
        
        return cell
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
