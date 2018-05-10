//
//  Extension.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-30.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        //no flshing image for the next list
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: (urlString as NSString)){
            if let trailerCellImageView = self as? TrailerCellImageView {
                trailerCellImageView.activityIndicatior.stopAnimating()
                trailerCellImageView.activityIndicatior.removeFromSuperview()
            }
            self.image = cachedImage
            return
        }
        
        let url = NSURL(string: urlString)
        let request = URLRequest(url: url! as URL)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request){
            (data, response, error) in
            //download hit an error so lets return out
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!), let compressedImageData = UIImageJPEGRepresentation(downloadedImage, 0.1), let compressedImage = UIImage(data: compressedImageData) {
                    imageCache.setObject( compressedImage, forKey: (urlString as NSString))
                   
                    if let trailerCellImageView = self as? TrailerCellImageView {
                        trailerCellImageView.activityIndicatior.stopAnimating()
                        trailerCellImageView.activityIndicatior.removeFromSuperview()
                    }
                    
                    self.image = compressedImage
                }
            }
        }
        dataTask.resume()
    }
}

extension UIViewController {
    func fetchVideUrlWith(_ movieId: Int, movie: Movie, completion: @escaping () -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=24cfbd59fbd336bfd1a218ec40733d66&language=en-US"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    return
                }
                
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    if let results = dictionary!["results"] as? [AnyObject] {
                        for video in results {
                            if let videoObj = video as? [String : Any] {
                                movie.video_key = videoObj["key"] as? String
                                break
                            }
                        }
                        
                        completion()
                    }
                } catch {
                    
                }
            })
            task.resume()
        }
        
    }
    func fetchMovieWith(_ id: Int, completion: @escaping (Movie) -> Void) {
        if let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=24cfbd59fbd336bfd1a218ec40733d66&language=en-US") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content_Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    let movie = Movie(dictionary: (json as? [String: Any])!)
                    completion(movie)
                } catch {
                    
                }
            }
            
            task.resume()
        }
    }
    func sortByReleaseDay(movies: inout [Movie]) {
        movies.sort(by: { (movie1, movie2) -> Bool in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            return dateFormatter.date(from: movie1.release_date!)! > dateFormatter.date(from: movie2.release_date!)!
        })
    }
    func formatDate(dateString: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        if let date = dateFormat.date(from: dateString) {
            dateFormat.dateFormat = "MMM yyyy"
            return dateFormat.string(from: date)
        }
        
        return "unidentified"
    }
    
    func setupBlackView(blackView: inout UIView?) {
        blackView = UIView()
        blackView?.isUserInteractionEnabled = true
    }
    
    func alertMessage(message : String, rootController : UIViewController) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = UIColor.black
        alert.view.tintColor = UIColor.black
        let messageAttributed = NSMutableAttributedString(
            string: alert.message!,
            attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 19),
                         NSAttributedStringKey.foregroundColor: UIColor.white])
        alert.setValue(messageAttributed, forKey: "attributedMessage")
        
        rootController.present(alert, animated: true, completion: nil)
        //TODO: set timer for dismiss
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(700)) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func estimateWidthAndHeightFor(text: String, attributes: [NSAttributedStringKey: Any]) -> CGSize {
        return (text as NSString).size(withAttributes: attributes)
    }
    
    func colorNavigationBar(barColor: UIColor, tintColor: UIColor) {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = barColor
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func createAtrributes(text: String, attributes: [NSAttributedStringKey: Any]) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func estimateNumberOfLinesNeeded(text: String, attributes: [NSAttributedStringKey : Any]) -> Int {
        let estimateSize = estimateWidthAndHeightFor(text: text, attributes: attributes)
        return Int(estimateSize.width / (view.frame.width * 0.5)) + 1
    }
    
    func setupBottomBorder<T>(cell: T) {
        if let cell = cell as? MoviePostCell {
            let bottomBorder = setupFrameAndColorOnBorder(color: UIColor.init(red: 176/255, green: 176/255, blue: 166/255, alpha: 1).cgColor, rect: CGRect(x: 15.0, y: cell.frame.size.height - 1, width: cell.frame.size.width - 30, height: 1.0), layer: CALayer())
            cell.layer.addSublayer(bottomBorder)
        }
        
        if let cell = cell as? SettingsCell {
            let bottomBorder = setupFrameAndColorOnBorder(color: UIColor.init(red: 215/255, green: 191/255, blue: 31/255, alpha: 1).cgColor, rect: CGRect(x: 30.0, y: cell.frame.size.height - 1, width: cell.frame.size.width - 60, height: 1.0), layer: CALayer())
            cell.layer.addSublayer(bottomBorder)
        }
        
        if let cell = cell as? UITableViewCell {
            let bottomBorder = setupFrameAndColorOnBorder(color: UIColor.init(red: 215/255, green: 191/255, blue: 31/255, alpha: 1).cgColor, rect: CGRect(x: 30.0, y: cell.frame.size.height - 1, width: cell.frame.size.width - 60, height: 1.0), layer: CALayer())
            cell.layer.addSublayer(bottomBorder)
        }
    }
    
    func setupFrameAndColorOnBorder(color: CGColor, rect: CGRect, layer: CALayer) -> CALayer {
        layer.frame = rect
        layer.backgroundColor = color
        
        return layer
    }
    
    
    func adjustLabelToFitTitle<T>(title: String, cell: T) {
        let size = estimateWidthAndHeightFor(text: title, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        if let cell = cell as? TrailerCell {
            let numberOfLine = Int(size.width / (cell.frame.width * 0.8 - 8)) + 1
            cell.movieTitleLabel.numberOfLines = numberOfLine
            cell.movieTitleLabel.text = title
            cell.movieTitleLabel.sizeToFit()
        } else if let cell = cell as? GenreCell {
            let numberOfLine = Int(size.width / (cell.frame.width * 0.8 - 8)) + 1
            cell.moiveTitleLabel.numberOfLines = numberOfLine
            cell.moiveTitleLabel.text = title
            cell.moiveTitleLabel.sizeToFit()
        } else if let cell = cell as? MoviePostCell {
            let numberOfLine = Int(size.width / (cell.frame.width * 0.8 - 8)) + 1
            cell.moviePostTiltleLabel.numberOfLines = numberOfLine
            cell.moviePostTiltleLabel.text = title
            cell.moviePostTiltleLabel.sizeToFit()
        }
        
    }
    
    func setupActivityIndicator<T>(cell: T) {
        if let trailerCellImageView = (cell as? TrailerCell)?.moviePostImageVIew {
            trailerCellImageView.addSubview(trailerCellImageView.activityIndicatior)
            trailerCellImageView.activityIndicatior.centerYAnchor.constraint(equalTo: trailerCellImageView.centerYAnchor).isActive = true
            trailerCellImageView.activityIndicatior.centerXAnchor.constraint(equalTo: trailerCellImageView.centerXAnchor).isActive = true
        } else if let genreCellImageView = (cell as? GenreCell)?.moviePostImageView  {
            genreCellImageView.addSubview(genreCellImageView.activityIndicatior)
            genreCellImageView.activityIndicatior.centerYAnchor.constraint(equalTo: genreCellImageView.centerYAnchor).isActive = true
            genreCellImageView.activityIndicatior.centerXAnchor.constraint(equalTo: genreCellImageView.centerXAnchor).isActive = true
        } else if let movieCollectionViewImageView = (cell as? MoviePostCell)?.moviePostImageView {
            movieCollectionViewImageView.addSubview(movieCollectionViewImageView.activityIndicatior)
            movieCollectionViewImageView.activityIndicatior.centerYAnchor.constraint(equalTo: movieCollectionViewImageView.centerYAnchor).isActive = true
            movieCollectionViewImageView.activityIndicatior.centerXAnchor.constraint(equalTo: movieCollectionViewImageView.centerXAnchor).isActive = true
        }
    }
    
    // tracking on a position of video view 
    
    func trackVideoViewMoving(location: CGPoint, videoView: UIWebView, videoLauncher: VideoLauncher) {
        let changedX =  location.x + view.frame.width / 2
        let changedY =  location.y + view.frame.height / 2
        videoView.center = CGPoint(x: changedX, y: changedY)
        videoView.alpha -= 0.003
        videoLauncher.blackView?.alpha -= 0.003
    }
    
    func fadeBackToOriginal(videoView: UIWebView, videoLauncher: VideoLauncher) {
        videoView.center = self.view.center
        videoLauncher.blackView?.alpha = 1
        videoView.alpha = 1
    }
}

extension UIView {
    func setGradientBackground(firstColour: UIColor, secondColour: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [firstColour.cgColor, secondColour.cgColor]
        gradientLayer.locations = [0.0, 0.8]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        layer.addSublayer(gradientLayer)
    }
}










