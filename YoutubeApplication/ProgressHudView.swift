//
//  ProgressHudView.swift
//  YoutubeApplication
//
//  Created by wSong on 12/20/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit
protocol ProgressHudManager {
    func show()
    func hide()
}
class ProgressHudView: UIVisualEffectView, ProgressHudManager {
    private var text: String? {
        didSet {
            label.text = text
        }
    }
    private lazy var activityIndictor: UIActivityIndicatorView = self.createActivityIndicatorView()
    private lazy var label: UILabel = self.createTextLabel()
    private let blurEffect = UIBlurEffect(style: .extraLight)
    private lazy var vibrancyView: UIVisualEffectView = self.createVibrancyViewWith(effect: UIVibrancyEffect(blurEffect: self.blurEffect))
    //MAKR:-Loading
    init(text: String) {
        self.text = text
        super.init(effect: blurEffect)
        addAllConstraintsToViews()
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        super.init(coder: aDecoder)
        addAllConstraintsToViews()
    }
    //MAKR:-SetupViews
    private func createActivityIndicatorView() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(indicator)
        return indicator
    }
    private func createTextLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont().avenirNextRegularTitleFont
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.text = self.text
        contentView.addSubview(label)
        return label
    }
    private func createVibrancyViewWith(effect: UIVibrancyEffect) -> UIVisualEffectView {
        let vibrancyView: UIVisualEffectView = UIVisualEffectView(effect: effect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vibrancyView)
        return vibrancyView
    }
    //MARK:-AddConstraints
    private func addAllConstraintsToViews() {
        addConstraintsToVibrancyView()
        addConstraintsToTextLabel()
        addConstraintsToActivityIndicatorView()
    }
    private func addConstraintsToVibrancyView() {
        vibrancyView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        vibrancyView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        vibrancyView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        vibrancyView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    private func addConstraintsToTextLabel() {
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: activityIndictor.leftAnchor, constant: -5).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    private func addConstraintsToActivityIndicatorView() {
        activityIndictor.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        activityIndictor.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndictor.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        activityIndictor.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
    public func show() {
        self.isHidden = false
        activityIndictor.startAnimating()
    }
    public func hide() {
        self.isHidden = true
        activityIndictor.stopAnimating()
    }
}









