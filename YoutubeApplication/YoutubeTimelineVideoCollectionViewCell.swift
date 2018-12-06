//
//  YoutubeTimelineCollectionViewCell.swift
//  YoutubeApplication
//
//  Created by wSong on 12/5/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

class YoutubeTimelineVideoCollectionViewCell: IdentifiableCollectionViewCell {
    
    private lazy var videoContentBubbleView: UIView = self.createContentBubbleView()
    private lazy var separatingLineView: UIView = self.createSeparatingLineView()
    
    lazy var videoAuthorImageView: UIImageView = self.createVideoAuthorImageView()
    lazy var videoSubtitleLabel: UILabel = self.createVideoSubtitleLabelWith(font: UIFont().avenirNextRegularTitleFont)
    lazy var videoSubtitleDescriptionLabel: UILabel = self.createVideoSubtitleLabelWith(font: UIFont().avenirNextRegularDescriptionFont)
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    //MARK:-Loading
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImageView.image = nil
        self.videoAuthorImageView.image = nil
        self.videoSubtitleLabel.text = ""
        self.videoSubtitleDescriptionLabel.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        videoContentBubbleView.addSubview(thumbnailImageView)
        setupAllConstraintsToViews()
        contentView.layer.cornerRadius = 12.0
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.videoAuthorImageView.layer.cornerRadius = self.videoAuthorImageView.bounds.width / 2
        self.videoAuthorImageView.clipsToBounds = true
    }
    //MARK:-CellModelRepresentable
    override func updateModel(_ model: CellIdentifiable?, viewModel: ViewModelCellPresentable?) {
        guard let model = model as? YotubeTimelineVideoCellModel else { return }
        
        self.thumbnailImageView.downloadImageUsingCache(stringURL: model.thumbnailImage)
        
        if let channel = model.channel {
            self.videoAuthorImageView.downloadImageUsingCache(stringURL: channel.channelImageURL)
            self.videoSubtitleDescriptionLabel.text = channel.channelName + " ● \(String().formateNumberToStringInDecimalFormat(NSNumber(value: model.videoNumberOfViews))) views"
        }
        
        self.videoSubtitleLabel.text = model.videoTitle
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
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
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
    private var videoSubtitleLabelHeightAnchor: NSLayoutConstraint?
    private func setupAllConstraintsToViews() {
        addConstraintsToVideoContentBubbleView()
        addConstraintsToThumbnailImageView()
        addConstraintsToVideoAuthorImageView()
        addConstraintsToVideoSubtitleLabel()
        addConstraintsToVideoSubtitleDescriptionLabel()
        addConstraintsToSeparatingLineView()
    }
    
    private func addConstraintsToVideoContentBubbleView() {
        videoContentBubbleView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        videoContentBubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        videoContentBubbleView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        videoContentBubbleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 4/6).isActive = true
    }
    
    private func addConstraintsToThumbnailImageView() {
        thumbnailImageView.centerXAnchor.constraint(equalTo: videoContentBubbleView.centerXAnchor).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: videoContentBubbleView.centerYAnchor).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalTo: videoContentBubbleView.widthAnchor, multiplier: 1).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalTo: videoContentBubbleView.heightAnchor, multiplier: 1).isActive = true
    }
    
    private func addConstraintsToVideoAuthorImageView() {
        videoAuthorImageView.leftAnchor.constraint(equalTo:  leftAnchor).isActive = true
        videoAuthorImageView.topAnchor.constraint(equalTo: videoContentBubbleView.bottomAnchor, constant: 15).isActive = true
        videoAuthorImageView.widthAnchor.constraint(equalTo: videoAuthorImageView.heightAnchor).isActive = true
        videoAuthorImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
    }
    
    private func addConstraintsToVideoSubtitleLabel() {
        videoSubtitleLabel.leftAnchor.constraint(equalTo: videoAuthorImageView.rightAnchor, constant: 10).isActive = true
        videoSubtitleLabel.topAnchor.constraint(equalTo: videoContentBubbleView.bottomAnchor, constant: 10).isActive = true
        videoSubtitleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    private func addConstraintsToVideoSubtitleDescriptionLabel() {
        videoSubtitleDescriptionLabel.leftAnchor.constraint(equalTo: videoSubtitleLabel.leftAnchor).isActive = true
        videoSubtitleDescriptionLabel.topAnchor.constraint(equalTo: videoSubtitleLabel.bottomAnchor).isActive = true
        videoSubtitleDescriptionLabel.rightAnchor.constraint(equalTo: videoSubtitleLabel.rightAnchor).isActive = true
        videoSubtitleDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
    
    private func addConstraintsToSeparatingLineView() {
        separatingLineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        separatingLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separatingLineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatingLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
