//
//  YoutubeVideoPlayerView.swift
//  YoutubeApplication
//
//  Created by wSong on 12/19/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit
import AVFoundation
protocol YoutubeVideoPlayerManager: class {
    func actionStopPlayingVideo()
    func actionPrepareVideoForPlayingWith(_ url: String)
}
class YoutubeVideoPlayerView: UIView, YoutubeVideoPlayerManager {
    
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var loadedTimeRanges: String = "currentItem.loadedTimeRanges"
    private lazy var progressHUD: ProgressHudView = self.createProgressHudView()
    private lazy var controlsContainerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor(white: 0, alpha: 1)
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
    }
    deinit {
        player?.removeObserver(self, forKeyPath: loadedTimeRanges)
    }
    //MARK:-YoutubeVideoPlayerManager
    func actionPrepareVideoForPlayingWith(_ url: String) {
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            playerLayer?.frame = self.bounds
            layer.addSublayer(playerLayer!)
            bringSubview(toFront: controlsContainerView)
            player?.play()
            player?.addObserver(self, forKeyPath: self.loadedTimeRanges, options: .new, context: nil)
        }
    }
    func actionStopPlayingVideo() {
        DispatchQueue.main.async {
            self.playerLayer?.player?.pause()
            self.playerLayer?.removeFromSuperlayer()
        }
    }
    //MARK:-Observers
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == loadedTimeRanges {
            hideControlsContainerView()
        }
    }
    private func hideControlsContainerView() {
        progressHUD.hide()
        UIView.animate(withDuration:0.3, animations: { [weak self] in
            self?.controlsContainerView.alpha = 0
        }, completion: { [weak self] (finished) in
            self?.controlsContainerView.isHidden = true
        })
    }
    //MAKR:-SetupViews
    private func createProgressHudView() -> ProgressHudView {
        let hud = ProgressHudView(text: "Loading")
        hud.translatesAutoresizingMaskIntoConstraints = false
        controlsContainerView.addSubview(hud)
        return hud
    }
    //MARK:-AddConstraints
    private func addAllConstraintsToViews() {
        addConstraintsToControlsContainerView()
        addConstraintsToProgressHUDView()
    }
    private func addConstraintsToControlsContainerView() {
        controlsContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        controlsContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        controlsContainerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        controlsContainerView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    private func addConstraintsToProgressHUDView() {
        progressHUD.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        progressHUD.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        progressHUD.widthAnchor.constraint(equalTo: controlsContainerView.widthAnchor, multiplier: 1/3)
        progressHUD.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
}









