//
//  YoutubeTimelineCollectionViewCell.swift
//  YoutubeApplication
//
//  Created by wSong on 12/5/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

class YoutubeTimelineCollectionViewCell: UICollectionViewCell {
    
    private lazy var videoContentBubbleView: UIView = self.createContentBubbleView()
    private lazy var separatingLineView: UIView = self.createSeparatingLineView()
    lazy var videoAuthorImageView: UIImageView = self.createVideoAuthorImageView()
    lazy var videoSubtitleLabel: UILabel = self.createVideoSubtitleLabelWith(font: UIFont().avenirNextRegularTitleFont)
    lazy var videoSubtitleDescriptionLabel: UILabel = self.createVideoSubtitleLabelWith(font: UIFont().avenirNextRegularDescriptionFont)
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var videoSubtitleLabelHeightAnchor: NSLayoutConstraint?
    var youtubeHelpedMethods = YoutubeHelpedMethods()
    var youtubeVideo: YoutubeVideoItem! {
        didSet {
            updateUI()
        }
    }
    private func updateUI() {
        self.thumbnailImageView.downloadImageUsingCache(stringURL: self.youtubeVideo.thumbnailImage)
        if let channel = self.youtubeVideo.channel {
            self.videoAuthorImageView.downloadImageUsingCache(stringURL: channel.channelProfileImageLink)
            self.videoSubtitleDescriptionLabel.text = channel.channelName + " ● \(youtubeHelpedMethods.formateNumberToStringInDecimalFormat(NSNumber(value: youtubeVideo.videoNumberOfViews))) views"
        }
        self.videoSubtitleLabel.text = self.youtubeVideo.videoTitle
        self.videoSubtitleLabelHeightAnchor?.constant = self.youtubeHelpedMethods.configureEstimatedHeightForText(self.youtubeVideo.videoTitle).height + 20.0
    }
    //MARK:-Loading
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.clear
        videoContentBubbleView.addSubview(thumbnailImageView)
        addAllConstraintsToViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 12.0
        self.layer.masksToBounds = true
        self.videoAuthorImageView.layer.cornerRadius = self.videoAuthorImageView.bounds.width / 2
        self.videoAuthorImageView.clipsToBounds = true
    }
    //MARK:-SetupViews
    private func createContentBubbleView() -> UIView {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = UIColor.white
        content.layer.cornerRadius = 12.0
        content.clipsToBounds = true
        addSubview(content)
        return content
    }
    private func createVideoAuthorImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        return imageView
    }
    private func createVideoSubtitleLabelWith(font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.contentMode = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    private func createSeparatingLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(r: 230, g: 230, b: 230, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    //MARK:-SetupConstraints
    private func addAllConstraintsToViews() {
        addConstraintsToVideoContentBubbleView()
        addConstraintsToThumbnailImageView()
        addConstraintsToVideoAuthorImageView()
        addConstraintsToVideoSubtitleLabel()
        addConstraintsToVideoSubtitleDescriptionLabel()
        addConstraintsToSeparatingLineView()
    }
    private func addConstraintsToVideoContentBubbleView() {
        videoContentBubbleView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        videoContentBubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        videoContentBubbleView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        videoContentBubbleView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 4/6).isActive = true
    }
    private func addConstraintsToThumbnailImageView() {
        thumbnailImageView.centerXAnchor.constraint(equalTo: videoContentBubbleView.centerXAnchor).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: videoContentBubbleView.centerYAnchor).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalTo: videoContentBubbleView.widthAnchor, multiplier: 1).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalTo: videoContentBubbleView.heightAnchor, multiplier: 1).isActive = true
    }
    private func addConstraintsToVideoAuthorImageView() {
        videoAuthorImageView.leftAnchor.constraint(equalTo:  self.leftAnchor).isActive = true
        videoAuthorImageView.topAnchor.constraint(equalTo: videoContentBubbleView.bottomAnchor, constant: 15).isActive = true
        videoAuthorImageView.widthAnchor.constraint(equalTo: videoAuthorImageView.heightAnchor).isActive = true
        videoAuthorImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
    }
    private func addConstraintsToVideoSubtitleLabel() {
        videoSubtitleLabel.leftAnchor.constraint(equalTo: videoAuthorImageView.rightAnchor, constant: 10).isActive = true
        videoSubtitleLabel.topAnchor.constraint(equalTo: videoAuthorImageView.topAnchor).isActive = true
        videoSubtitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        videoSubtitleLabelHeightAnchor = videoSubtitleLabel.heightAnchor.constraint(equalToConstant: 60.0)
        videoSubtitleLabelHeightAnchor?.isActive = true
    }
    private func addConstraintsToVideoSubtitleDescriptionLabel() {
        videoSubtitleDescriptionLabel.leftAnchor.constraint(equalTo: videoSubtitleLabel.leftAnchor).isActive = true
        videoSubtitleDescriptionLabel.topAnchor.constraint(equalTo: videoSubtitleLabel.bottomAnchor).isActive = true
        videoSubtitleDescriptionLabel.rightAnchor.constraint(equalTo: videoSubtitleLabel.rightAnchor).isActive = true
        videoSubtitleDescriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    private func addConstraintsToSeparatingLineView() {
        separatingLineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        separatingLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separatingLineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatingLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}















