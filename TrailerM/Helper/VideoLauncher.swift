//
//  VideoLauncher.swift
//  TrailerM
//
//  Created by gisu kim on 2018-04-30.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit
//import AVFoundation
//
//class VideoView: UIView {
//    var isPlaying       : Bool = false
//    var player          : AVPlayer?
//    var playerLayer     : AVPlayerLayer?
//
//    let controlContainer : UIView = {
//        let view = UIView()
//        view.backgroundColor        = .clear
//        view.isHidden               = true
//
//        return view
//    }()
//
//    let activityIndicatorView : UIActivityIndicatorView = {
//        let ati = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
//        ati.startAnimating()
//        ati.translatesAutoresizingMaskIntoConstraints = false
//
//        return ati
//    }()
//
//    lazy var playAndPauseButton : UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "videoPauseIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.addTarget(self, action: #selector(handlePlayAndPause), for: .touchUpInside)
//        button.tintColor                = .white
//        return button
//    }()
//
//    let videoLengthLabel : UILabel = {
//        let label = UILabel()
//        label.text                          = "00:00"
//        label.textColor                     = .white
//        label.font                          = UIFont.systemFont(ofSize: 12)
//        label.textAlignment                 = .right
//
//        return label
//    }()
//
//    let currentTimeLabel : UILabel = {
//        let label = UILabel()
//        label.text                          = "00:00"
//        label.textColor                     = .white
//        label.font                          = UIFont.systemFont(ofSize: 12)
//        label.textAlignment                 = .right
//
//        return label
//    }()
//
//    lazy var videoSlider : UISlider = {
//        let slider = UISlider()
//        slider.setThumbImage(UIImage(named: "videoSliderThumbnail"), for: .normal)
//        slider.addTarget(self, action: #selector(handleSliderChanged), for: .valueChanged)
//        slider.minimumTrackTintColor                        = .red
//        slider.maximumTrackTintColor                        = .white
//
//        return slider
//    }()
//
//    @objc func handleSliderChanged() {
//        if let duration = player?.currentItem?.duration {
//            let totalSeconds        = CMTimeGetSeconds(duration)
//            let value               = Float64(videoSlider.value) * totalSeconds
//            let seekTIme            = CMTime(value: CMTimeValue(value), timescale: 1)
//
//            player?.seek(to: seekTIme, completionHandler: { (completed) in
//
//            })
//        }
//    }
//
//    @objc func handlePlayAndPause() {
//        if isPlaying {
//            player?.pause()
//            playAndPauseButton.setImage(UIImage(named: "videoPlayIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        } else {
//            player?.play()
//            playAndPauseButton.setImage(UIImage(named: "videoPauseIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        }
//
//        isPlaying = !isPlaying
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .black
//        addSubview(controlContainer)
//
//        controlContainer.addSubview(playAndPauseButton)
//        playAndPauseButton.translatesAutoresizingMaskIntoConstraints = false
//        [
//            playAndPauseButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
//            playAndPauseButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//            playAndPauseButton.widthAnchor.constraint(equalToConstant: 20),
//            playAndPauseButton.heightAnchor.constraint(equalToConstant: 20)
//        ].forEach{ $0.isActive = true }
//
//        controlContainer.addSubview(videoLengthLabel)
//        videoLengthLabel.translatesAutoresizingMaskIntoConstraints = false
//        [
//            videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
//            videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//            videoLengthLabel.widthAnchor.constraint(equalToConstant: 40),
//            videoLengthLabel.heightAnchor.constraint(equalToConstant: 20)
//        ].forEach{ $0.isActive = true }
//
//        controlContainer.addSubview(currentTimeLabel)
//        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
//        [
//            currentTimeLabel.leftAnchor.constraint(equalTo: playAndPauseButton.rightAnchor, constant: 4),
//            currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//            currentTimeLabel.widthAnchor.constraint(equalToConstant: 40),
//            currentTimeLabel.heightAnchor.constraint(equalToConstant: 20)
//        ].forEach{ $0.isActive = true }
//
//        controlContainer.addSubview(videoSlider)
//        videoSlider.translatesAutoresizingMaskIntoConstraints = false
//        [
//            videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor, constant: 2),
//            videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//            videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor, constant: -2),
//            videoSlider.heightAnchor.constraint(equalToConstant: 20)
//        ].forEach{ $0.isActive = true }
//
//        addSubview(activityIndicatorView)
//        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func playVideo() {
//        // TODO: get url from Movide detail Controller
//        if let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/gisuchat.appspot.com/o/message_movies%2F2E41BC21-3280-4CF1-9A5B-2749D2DD7587.mov?alt=media&token=30233126-7bff-495d-9f76-21cc76164e1c") {
//            // setup video player
//            player                          = AVPlayer(url: url)
//            playerLayer                     = AVPlayerLayer(player: player)
//            playerLayer?.frame              = self.bounds
//            playerLayer?.videoGravity       = .resizeAspectFill
//
//            layer.addSublayer(playerLayer!)
//
//            player?.play()
//            isPlaying                       = true
//            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
//
//            // tracking the progress
//            let timeInterval = CMTime(value: 1, timescale: 2)
//            player?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main, using: { (progress) in
//                // update current time label
//                let seconds                 = CMTimeGetSeconds(progress)
//                let secondsText             = String(format: "%02d", Int(seconds) % 60 )
//                let minutesText             = String(format: "%02d", Int(seconds) / 60 )
//                self.currentTimeLabel.text  = "\(minutesText):\(secondsText)"
//
//                // update slider's thumb image
//                if let duration = self.player?.currentItem?.duration {
//                    let durationSeconds     = CMTimeGetSeconds(duration)
//                    // value range is 0 ... 1
//                    self.videoSlider.value  = Float(seconds / durationSeconds)
//
//                    // update video legnth label
//                    let remindSeconds       = CMTimeGetSeconds(duration)
//                    guard !(remindSeconds.isNaN) || remindSeconds.isInfinite else {
//                        return
//                    }
//
//                    let remindSecondsText       = String(format: "%02d", (Int(remindSeconds) - Int(seconds)) % 60 )
//                    let remindMinutesText       = String(format: "%02d", (Int(remindSeconds) - Int(seconds)) / 60 )
//                    self.videoLengthLabel.text  = "\(remindMinutesText):\(remindSecondsText)"
//                }
//            })
//
//            // bring the control panel to front
//            bringSubview(toFront: controlContainer)
//            controlContainer.frame = self.bounds
//        }
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "currentItem.loadedTimeRanges" {
//            activityIndicatorView.stopAnimating()
//            controlContainer.isHidden = false
//
//            if let duration = player?.currentItem?.duration {
//                let second      = CMTimeGetSeconds(duration)
//                let secondText  = Int(second) % 60
//                let minuteText  = String(format: "%02d", Int(second) / 60)
//                videoLengthLabel.text = " \(minuteText):\(secondText)"
//            }
//        }
//    }
//}

class VideoLauncher: NSObject {
    var blackView : UIView?
    func setupVideoLauncher(webView: UIWebView) {
        if let keyWindow = UIApplication.shared.keyWindow {
            blackView?.backgroundColor = .black
            blackView?.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            let height = keyWindow.frame.width * 9 / 16
            let videoViewFrame  = CGRect(x: 0, y: (keyWindow.frame.height / 2) - (height / 2), width: keyWindow.frame.width, height: height)

            webView.frame = videoViewFrame
            blackView?.addSubview(webView)
            

            keyWindow.addSubview(blackView!)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView?.frame = keyWindow.frame
            }, completion: { (completedAnimation) in
                // TOOD: after the animation 
            })
        }
    }
    
    
}
