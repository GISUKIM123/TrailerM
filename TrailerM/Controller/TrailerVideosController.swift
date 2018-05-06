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
    weak var trailerController: TrailerController? {
        didSet {
            movies = trailerController?.movies
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
        cell.trailerVideoImageVIew.alpha = 0.8
        if let post_path = movies![indexPath.item].poster_path {
            let urlString = imageFetchUrlHeader + post_path
            cell.trailerVideoImageVIew.loadImageUsingCacheWithUrlString(urlString: urlString)
        }
        
        cell.trailerVideoTitle.text = movies![indexPath.item].original_title
        cell.trailerVideoDescription.text = movies![indexPath.item].overview
        cell.dateLabel.text = formatDate(dateString: movies![indexPath.item].release_date!)
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showVideoTrailer)))
        
    }
    
    
    
    var videoLauncher   : VideoLauncher?
    var videoView       :  VideoView?
    var blackView       : UIView?
    @objc func showVideoTrailer() {
        setupBlackView(blackView: &blackView)
        blackView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        videoLauncher = VideoLauncher()
        videoLauncher?.blackView = blackView
        videoView = VideoView()
        videoView?.controlContainer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleSwipe)))
        videoLauncher?.setupVideoLauncher(videoView: videoView!)
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView?.removeFromSuperview()
        }) { (completed) in
            if completed {
                self.videoLauncher = nil
                self.videoView?.player?.pause()
                self.videoView?.playerLayer?.removeFromSuperlayer()
            }
        }
    }
    
    
    var location = CGPoint(x: 0, y: 0)
    
    @objc func handleSwipe(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            location = gesture.translation(in: videoView)
            trackVideoViewMoving(location: location, videoView: self.videoView!, videoLauncher: self.videoLauncher!)
        }
        
        if gesture.state == .ended {
            if location.y < -180 || location.y > 180 {
                // dismiss video launcher
                dismissVideoView(videoView: videoView!, videoLauncher: videoLauncher!)
                videoLauncher = nil
            } else {
                // return original position
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.fadeBackToOriginal(videoView: self.videoView!, videoLauncher: self.videoLauncher!)
                }, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 4)
    }
    
}
