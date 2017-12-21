//
//  YoutubeDetailVideoViewController.swift
//  YoutubeApplication
//
//  Created by wSong on 12/20/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

class YoutubeDetailVideoViewController: UIViewController {

    lazy var videoPlayerView: YoutubeVideoPlayerView = self.createVideoPlayerView()
    lazy var videoPlayerHideButton: UIButton = self.createVideoPlayerHideButton()
    fileprivate var viewModel: YoutubeDetailVideoViewModel?
    
    //MARK:-Loading
    convenience init(viewModel: YoutubeDetailVideoViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addAllConstraintsToViews()
        self.view.backgroundColor = UIColor.white
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        actionPrepareVideoForPlaying()
    }
    //MARK:-YoutubeVideoPlayerLauncherItem
    func actionPrepareVideoForPlaying() {
        viewModel?.videoURL.bind(listener: { [weak self] (videoURL) in
            self?.videoPlayerView.actionPrepareVideoForPlayingWith(videoURL!)
        })
        actionIsStatusBarHidden(true)
    }
    func actionHideVideoPlayer(_ sender: UIButton) {
        videoPlayerView.actionStopPlayingVideo()
        presentingViewController?.dismiss(animated: true, completion: nil)
        actionIsStatusBarHidden(false)
    }
    private func actionIsStatusBarHidden(_ hidden: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
            UIApplication.shared.isStatusBarHidden = hidden
        }, completion: { (completion) in })
    }
    //MAKR:-SetupViews
    private func createVideoPlayerView() -> YoutubeVideoPlayerView {
        let videoView = YoutubeVideoPlayerView()
        videoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoView)
        return videoView
    }
    private func createVideoPlayerHideButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Hide", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionHideVideoPlayer(_ :)), for: .touchUpInside)
        view.addSubview(button)
        return button
    }
    //MARK:-AddConstraints
    private func addAllConstraintsToViews() {
        addConstraintsToVideoPlayerView()
        addConstraintsToVideoPlayerHideButton()
    }
    private func addConstraintsToVideoPlayerView() {
        videoPlayerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        videoPlayerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        videoPlayerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
        videoPlayerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    private func addConstraintsToVideoPlayerHideButton() {
        videoPlayerHideButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        videoPlayerHideButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0).isActive = true
        videoPlayerHideButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        videoPlayerHideButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
    }
}
