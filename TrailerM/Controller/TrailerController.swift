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
    let trailerHeaderCell = "trailerHeaderCell"
    
    @IBOutlet var trailerCollectionView: UICollectionView!

    @IBOutlet var imagesCarousel: UIScrollView!
    
    @IBOutlet var pageIndicator: UIPageControl!
    
    @IBAction func openMoviesCollectionViewController(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let moviesCollectionViewController = storyboard.instantiateViewController(withIdentifier: "MoviesCollectionViewController")
        
        navigationController?.pushViewController(moviesCollectionViewController, animated: true)
    }
    
    var imagesForCarousel: [String] = ["memorybook_category1", "memorybook_category2", "memorybook_category3", "memorybook_category4", "memorybook_category5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCarousel()
//        fetchMovies()
        
    }
    
//    func fetchMovies() {
//        if let url = URL(string: "https://theimdbapi.org/api/find/movie?title=transformers&year=2007") {
//            var request = URLRequest(url: url)
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpMethod = "GET"
//
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                guard let data = data, error == nil else {
//                    return
//                }
//
//            }
//            task.resume()
//        }
//    }
    var imageContentWidthForScrollView : CGFloat = 0.0
    var timerForCarousel : Timer?
}

extension TrailerController: UIScrollViewDelegate {
    func setupCarousel() {
        imagesCarousel.delegate = self
        imagesCarousel.showsHorizontalScrollIndicator = false
        imagesCarousel.isPagingEnabled = true
        setupPageIndicator()
        
        for i in 0..<imagesForCarousel.count {
            let imageView = UIImageView()
            imageView.image = UIImage(named: imagesForCarousel[i])
            imageView.contentMode = .scaleToFill
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: imagesCarousel.frame.width, height: view.frame.height * 0.35)
            imagesCarousel.contentSize.width = imagesCarousel.frame.width * (CGFloat(i) + 1)
            imageContentWidthForScrollView += imagesCarousel.frame.width
            imagesCarousel.addSubview(imageView)
        }
        
        setupAutomateSlider()
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
        if indexPath.section == 0 {
            cell.movieTitleLabel.text = "Gisu Kim"
        } else if indexPath.section == 1 {
            cell.movieTitleLabel.text = "Gisu Kim"
        } else if indexPath.section == 2 {
            cell.movieTitleLabel.text = "Gisu Kim"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: trailerHeaderCell, for: indexPath) as! TrailerHeaderCell

        if indexPath.section == 0 {
            headerCell.headerNameLabel.text = "In Theaters"
        } else if indexPath.section == 1 {
            headerCell.headerNameLabel.text = "Top box office"
        } else if indexPath.section == 2 {
            headerCell.headerNameLabel.text = "Your favorite"
        }
        
        return headerCell
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
