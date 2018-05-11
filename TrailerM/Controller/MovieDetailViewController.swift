//
//  MovieDetailViewController.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-29.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

let videoUrlHeader = "https://www.youtube.com/embed/"

class MovieDetailViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet var videoLengthLabel: UILabel!
    @IBOutlet var movietitle: UILabel!
    @IBOutlet var movieDescription: UITextView!
    @IBOutlet var videoTrailView: UIImageView!
    @IBOutlet var backButton: UIButton!
    
    var movie           : Movie?
    var videoLauncher   : VideoLauncher?
    var blackView       : UIView?
    var webView         : UIWebView?
    
    @IBAction func playTrailer(_ sender: Any) {
        setupVideoLauncher()
        fetchVideUrlWith((movie?.id)!, movie: movie!) {
            DispatchQueue.main.async {
                let urlString = videoUrlHeader + (self.movie?.video_key)!
                if let url = URL(string: urlString) {
                    let request = URLRequest(url: url)
                    self.webView?.loadRequest(request)
                    self.webView?.subviews[0].addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleSwipe)))
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle         = .lightContent
        view.backgroundColor                        = UIColor.init(red: 198/255, green: 226/255, blue: 255/255, alpha: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden     = false
        UIApplication.shared.statusBarStyle             = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Detail"
        
        setupContainer()
        setupDescrition()
        setupContentContainerView()
        setupDateLabel()
        setupVideoLengthLabel()
        setupRateBar()
        setupTitle()
        setupVideoTrailer()
    }
    
    func setupVideoLauncher() {
        videoLauncher                       = VideoLauncher()
        setupBlackView(blackView: &blackView)
        blackView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        videoLauncher?.blackView            = blackView
        webView                             = UIWebView()
        webView?.backgroundColor            = .black
        webView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleSwipe)))
        videoLauncher?.setupVideoLauncher(webView: webView!)
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
    
   var location : CGPoint = CGPoint(x: 0, y: 0)
    
    @objc func handleSwipe(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            location = gesture.translation(in: webView)
            trackVideoViewMoving(location: location, videoView: self.webView!, videoLauncher: self.videoLauncher!)
        }
        
        if gesture.state == .ended {
            if location.y < -180 || location.y > 180 {
                // dismiss video launcher
                self.blackView?.removeFromSuperview()
                self.webView?.removeFromSuperview()
                videoLauncher = nil
            } else {
                // return original position
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.fadeBackToOriginal(videoView: self.webView!, videoLauncher: self.videoLauncher!)
                }, completion: nil)
            }
        }
    }
    
    @IBAction func dismissPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        _ = navigationController?.popToViewController((navigationController?.viewControllers[0])!, animated: true)
    }    
}

// layout and style components

extension MovieDetailViewController {
    func setupVideoTrailer() {
        // TODO: make an extra obj contains of view having AVFoundation video player
        if let post_path = movie?.belongs_to_collection {
            if let belongs_to_collection = post_path["poster_path"] as? String {
                let urlString = "https://image.tmdb.org/t/p/w500" + belongs_to_collection
                videoTrailView.loadImageUsingCacheWithUrlString(urlString: urlString)
            }
        } else {
            if let post_path = movie?.backdrop_path {
                let urlString = "https://image.tmdb.org/t/p/w500" + post_path
                videoTrailView.loadImageUsingCacheWithUrlString(urlString: urlString)
            }
        }
        
        videoTrailView.contentMode = .scaleToFill
    }
    
    func setupTitle() {
        // TODO: get title data from movie object and assign to it
        guard let title = movie?.original_title else {
            return
        }
        
        let attributes = [NSAttributedStringKey.font: UIFont(name: "AmericanTypewriter-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white]
        movietitle.attributedText   = createAtrributes(text: title, attributes: attributes)
        movietitle.numberOfLines    = estimateNumberOfLinesNeeded(text: title, attributes: attributes)
        movietitle.lineBreakMode    = .byTruncatingTail
        movietitle.sizeToFit()
    }
    
    func setupDescrition() {
        // TODO: calculate height of text and resize textbox
        guard let description = movie?.overview else {
            return
        }
        
        let attributes                      = [NSAttributedStringKey.font: UIFont(name: "Baskerville-BoldItalic", size: 14) ?? UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.init(red: 241/255, green: 245/255, blue: 255/255, alpha: 1)]
        movieDescription.attributedText     = createAtrributes(text: description, attributes: attributes)
        let estimateSize                    = estimateWidthAndHeightFor(text: description, attributes: attributes)
        let numberOfLines                   = estimateNumberOfLinesNeeded(text: description, attributes: attributes)
        let height                          = CGFloat(numberOfLines) * estimateSize.height
        let decriptionY                     = movieDescription.frame.origin.y
        let extensiveHeight                 = abs(decriptionY - height)
        movieDescription.sizeToFit()
        scrollView.contentSize.height = contentView.frame.height + extensiveHeight
    }
    
    func setupDateLabel() {
        guard let date = movie?.release_date else {
            return
        }
        
        dateLabel.attributedText = createAtrributes(text: date, attributes: [NSAttributedStringKey.font: UIFont(name: "AmericanTypewriter-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.init(red: 255/255, green: 173/255, blue: 49/255, alpha: 1)])
    }
    
    func setupVideoLengthLabel() {
        guard let legnth = movie?.runtime else {
            return
        }
        
        let legnthString                    = "\(Int(legnth)) mins"
        videoLengthLabel.attributedText     = createAtrributes(text: legnthString, attributes: [NSAttributedStringKey.font: UIFont(name: "AmericanTypewriter-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.init(red: 255/255, green: 173/255, blue: 49/255, alpha: 1)])
    }
    
    func setupRateBar() {
        // TODO: calculate rate and swtich with colored stars
        guard let rate = movie?.vote_average else {
            return
        }
        
        let rateFormate             = "\(rate)/10"
        rateLabel.attributedText    = createAtrributes(text: rateFormate, attributes: [NSAttributedStringKey.font: UIFont(name: "AmericanTypewriter-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.init(red: 255/255, green: 173/255, blue: 49/255, alpha: 1)])
        
    }
    
    func setupContainer() {
        // TODO: assign background image as a movie post
        let backgroundImage                 = UIImageView(frame: UIScreen.main.bounds)
        if let poster_path = movie?.poster_path {
            let urlString                   = "https://image.tmdb.org/t/p/w500\(poster_path)"
            backgroundImage.loadImageUsingCacheWithUrlString(urlString: urlString)
            backgroundImage.contentMode     = .scaleToFill
            containerView.insertSubview(backgroundImage, at: 0)
        }
    }
    
    func setupContentContainerView() {
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
    }
}





