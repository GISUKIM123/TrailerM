//
//  TrailerVideoController.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-30.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class TrailerVideosController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let trailerVideosCell = "trailerVideosCell"
    
    var movies : [Movie]?
    
    var videoLauncher   : VideoLauncher?
    
    var blackView       : UIView?
    
    var webView         : UIWebView?
    
    weak var trailerController: TrailerController? {
        didSet {
            self.movies = TrailerController.movies
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trailerVideosCell, for: indexPath) as! TrailerVideoCell
        setupCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func setupCell(cell: TrailerVideoCell, indexPath: IndexPath) {
        if cell.movie == nil {
            cell.movie = movies![indexPath.item]
        }
        cell.trailerVideoImageVIew.alpha = 0.8
        if let post_path = cell.movie?.poster_path {
            let urlString = imageFetchUrlHeader + post_path
            cell.trailerVideoImageVIew.loadImageUsingCacheWithUrlString(urlString: urlString)
        }
        
        cell.trailerVideoTitle.text = cell.movie?.original_title
        cell.trailerVideoDescription.text = cell.movie?.overview
        cell.dateLabel.text = formatDate(dateString: (cell.movie?.release_date!)!)
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showVideoTrailer)))
        
    }
    
    @objc func showVideoTrailer(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? TrailerVideoCell {
            setupBlackView(blackView: &blackView)
            blackView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleDismiss)))
            videoLauncher = VideoLauncher()
            videoLauncher?.blackView = blackView
            webView = UIWebView()
            videoLauncher?.setupVideoLauncher(webView: webView!)
            fetchVideUrlWith((cell.movie?.id)!, movie: cell.movie!) {
                DispatchQueue.main.async {
                    if let video_key = cell.movie?.video_key {
                        let urlString = videoUrlHeader + video_key
                        if let url = URL(string: urlString) {
                            let request = URLRequest(url: url)
                            self.webView?.loadRequest(request)
                            self.webView?.subviews[0].isUserInteractionEnabled = true
                            self.webView?.subviews[0].addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleSwipe)))
                        }
                    }
                }
            }
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView?.removeFromSuperview()
        }) { (completed) in
            if completed {
                self.videoLauncher = nil
            }
        }
    }
    
    
    var location = CGPoint(x: 0, y: 0)
    
    @objc func handleSwipe(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            location = gesture.translation(in: webView)
            trackVideoViewMoving(location: location, videoView: self.webView!, videoLauncher: self.videoLauncher!)
        }
        
        if gesture.state == .ended {
            if location.y < -180 || location.y > 180 {
                // dismiss video launcher
                webView?.removeFromSuperview()
                blackView?.removeFromSuperview()
                videoLauncher = nil
            } else {
                // return original position
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.fadeBackToOriginal(videoView: self.webView!, videoLauncher: self.videoLauncher!)
                }, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 4)
    }
    
}
