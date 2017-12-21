//
//  YoutubeVideoPlayerView.swift
//  YoutubeApplication
//
//  Created by wSong on 12/19/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit
import AVFoundation
protocol YoutubeVideoPlayerManager {
    func actionStopPlayingVideo()
    func actionPrepareVideoForPlayingWith(_ url: String)
}
class YoutubeVideoPlayerView: UIView, YoutubeVideoPlayerManager {
    struct VideoPlayerObserverConstants {
        static let loadedTimeRanges: String = "currentItem.loadedTimeRanges"
    }
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private let helpedMethods = YoutubeHelpedMethods()
    private lazy var progressHUD: ProgressHudView = self.createProgressHudView()
    private lazy var playButton: UIButton = self.createPlayerPlayButton()
    private lazy var videoDurationLabel: UILabel = self.createVideoDurationLabel()
    private lazy var videoCurrentTimeLabel: UILabel = self.createVideoDurationLabel()
    private lazy var videoPlayerSlider: UISlider = self.createVideoPlayerSlider()
    private lazy var gradientLayer: CAGradientLayer = self.createGradientLayer()
    private var isPlayerPlay: Bool = false
    private lazy var controlsContainerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.clear
        container.isHidden = true
        return container
    }()
    //MARK:-Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        addSubview(controlsContainerView)
        addAllConstraintsToViews()
        progressHUD.show()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer?.frame = self.bounds
        gradientLayer.frame = controlsContainerView.bounds
    }
    deinit {
        player?.removeObserver(self, forKeyPath: VideoPlayerObserverConstants.loadedTimeRanges)
        player?.removeTimeObserver(self.timeObserverToken ?? "")
        print("Hello")
    }
    //MARK:-YoutubeVideoPlayerManager
    func actionPrepareVideoForPlayingWith(_ url: String) {
        if let videoURL = URL(string: url) {
            setupVideoPlayerWith(url: videoURL)
        }
    }
    func actionStopPlayingVideo() {
        DispatchQueue.main.async {
            self.player?.pause()
            self.playerLayer?.removeFromSuperlayer()
        }
    }
    private var timeObserverToken: Any?
    private func setupVideoPlayerWith(url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer?.frame = self.bounds
        layer.addSublayer(playerLayer!)
        bringSubview(toFront: controlsContainerView)
        player?.play()
        isPlayerPlay = true
        addLoadedTimeRangeObserverToPlayer()
        addTimeObserverTokenToPlayer()
    }
    private func addLoadedTimeRangeObserverToPlayer() {
        player?.addObserver(self, forKeyPath: VideoPlayerObserverConstants.loadedTimeRanges, options: .new, context: nil)
    }
    private func addTimeObserverTokenToPlayer() {
        self.timeObserverToken = player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 2), queue: .main, using: {[weak self] (progressTime) in
            self?.videoCurrentTimeLabel.text = self?.helpedMethods.formateCMTimeToString(time: progressTime)
            if let totalSeconds = self?.actionGetCurrentPlayerSecondsDuration() {
                let seconds = CMTimeGetSeconds(progressTime)
                self?.videoPlayerSlider.value = Float(seconds / totalSeconds)
            }
        })
    }
    //MARK:-Observers
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == VideoPlayerObserverConstants.loadedTimeRanges {
            hideControlsContainerView()
            if let time = player?.currentItem?.duration {
                videoDurationLabel.text = helpedMethods.formateCMTimeToString(time: time)
            }
        }
    }
    private func hideControlsContainerView() {
        UIView.animate(withDuration:0.3, animations: { [weak self] in
            self?.progressHUD.hide()
            self?.controlsContainerView.isHidden = false
        }, completion: {  (finished) in })
    }
    //MARK:-Actions
    @objc private func actionPlayerPlayButtonDidPressed(_ sender: UIButton) {
        if isPlayerPlay {
            player?.pause()
            playButton.setImage(UIImage(named: "play"), for: .normal)
        }else {
            player?.play()
            playButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlayerPlay = !isPlayerPlay
    }
    @objc private func actionSliderValueDidChange(_ sender: UISlider) {
        if let totalSeconds = actionGetCurrentPlayerSecondsDuration() {
            let value = Float64(sender.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (finished) in })
        }
    }
    private func actionGetCurrentPlayerSecondsDuration() -> Float64? {
        if let duration = player?.currentItem?.duration{
            return CMTimeGetSeconds(duration)
        }
        return nil
    }
    //MAKR:-SetupViews
    private func createProgressHudView() -> ProgressHudView {
        let hud = ProgressHudView(text: "Loading")
        hud.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hud)
        return hud
    }
    private func createPlayerPlayButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "pause"), for: .normal)
        button.addTarget(self, action: #selector(actionPlayerPlayButtonDidPressed(_:)), for: .touchUpInside)
        controlsContainerView.addSubview(button)
        return button
    }
    private func createVideoDurationLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont().avenirNextRegularTimeFont
        label.contentMode = .center
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.text = "00:00"
        label.textColor = UIColor.white
        controlsContainerView.addSubview(label)
        return label
    }
    private func createVideoPlayerSlider() -> UISlider {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.minimumTrackTintColor = UIColor.red
        slider.maximumTrackTintColor = UIColor.white
        slider.addTarget(self, action: #selector(actionSliderValueDidChange(_:)), for: .valueChanged)
        controlsContainerView.addSubview(slider)
        return slider
    }
    private func createGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = controlsContainerView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.85, 1.2]
        controlsContainerView.layer.addSublayer(gradient)
        return gradient
    }
    //MARK:-AddConstraints
    private func addAllConstraintsToViews() {
        addConstraintsToControlsContainerView()
        addConstraintsToProgressHUDView()
        addConstraintsToPlayerPlayButton()
        addConstraintsToVideoDurationLabel()
        addConstraintsToVideoPlayerSlider()
        addConstraintsToVideoCurrentTimeLabel()
    }
    private func addConstraintsToControlsContainerView() {
        controlsContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        controlsContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        controlsContainerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        controlsContainerView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    private func addConstraintsToProgressHUDView() {
        progressHUD.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        progressHUD.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        progressHUD.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3)
        progressHUD.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
    }
    private func addConstraintsToPlayerPlayButton() {
        playButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalTo: controlsContainerView.widthAnchor, multiplier: 1/5).isActive = true
        playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor).isActive = true
    }
    private func addConstraintsToVideoCurrentTimeLabel() {
        videoCurrentTimeLabel.leftAnchor.constraint(equalTo: controlsContainerView.leftAnchor, constant: 5).isActive = true
        videoCurrentTimeLabel.bottomAnchor.constraint(equalTo: videoPlayerSlider.bottomAnchor).isActive = true
        videoCurrentTimeLabel.rightAnchor.constraint(equalTo: videoPlayerSlider.leftAnchor, constant: -5).isActive = true
        videoCurrentTimeLabel.heightAnchor.constraint(equalTo: videoPlayerSlider.heightAnchor).isActive = true
    }
    private func addConstraintsToVideoPlayerSlider() {
        videoPlayerSlider.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        videoPlayerSlider.widthAnchor.constraint(equalTo: controlsContainerView.widthAnchor, multiplier: 5/8).isActive = true
        videoPlayerSlider.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: -7).isActive = true
        videoPlayerSlider.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
    private func addConstraintsToVideoDurationLabel() {
        videoDurationLabel.rightAnchor.constraint(equalTo: controlsContainerView.rightAnchor, constant: -5).isActive = true
        videoDurationLabel.leftAnchor.constraint(equalTo: videoPlayerSlider.rightAnchor, constant: 5).isActive = true
        videoDurationLabel.bottomAnchor.constraint(equalTo: videoPlayerSlider.bottomAnchor).isActive = true
        videoDurationLabel.heightAnchor.constraint(equalTo: videoPlayerSlider.heightAnchor).isActive = true
    }
}








