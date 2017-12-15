//
//  YoutubeSettingsMenuView.swift
//  YoutubeApplication
//
//  Created by wSong on 12/11/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

class YoutubeSettingsMenuView: UIView {
    fileprivate struct CellID {
        static let youtubeSettingsMenuCellID = "youtubeSettingsMenuCell"
    }
    weak var settingsMenuHandler: YoutubeSettingsMenuHandler?
    private lazy var backgroundSettingsMenuView: UIView = self.createYoutubeBlackBackgroundSettingsMenuView()
    private var collectionViewHeightConstaint: NSLayoutConstraint?
    private var backgroundSettingsMenuViewHeightConstaint: NSLayoutConstraint?
    lazy var collectionView: UICollectionView = self.createCollectionView()
    private var collectionViewHeight: CGFloat {
        get {
            return self.frame.height / 2.2
        }
    }
    private var backgroundSettingsMenuViewHeight: CGFloat {
        get {
            return self.frame.height - collectionViewHeight
        }
    }
    fileprivate var collectionViewItemSizeToPortrait: CGSize {
        get {
            let width: CGFloat = self.frame.width
            let height: CGFloat = collectionViewHeight / 6
            return CGSize(width: width, height: height)
        }
    }
    fileprivate var collectionViewitemSizeToLandscape: CGSize {
        get {
            let width: CGFloat = self.frame.width / 2.05
            let height: CGFloat = collectionViewHeight / 3
            return CGSize(width: width, height: height)
        }
    }
    var viewModel = YoutubeSettingsMenuViewModel()
    //MARK:-Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllConstraintsToViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        hideSettingsMenu() {}
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    //MARK:-Actions
    @objc private func actionBackgroundSettingsDidPressed(_ sender: UITapGestureRecognizer) {
        sender.numberOfTapsRequired = 1
        hideSettingsMenu() {}
    }
    public func showSettingsMenu() {
        if collectionView.isHidden && backgroundSettingsMenuView.isHidden && self.isHidden {
            DispatchQueue.main.async {
                self.isHidden = false
                self.collectionView.isHidden = false
                self.backgroundSettingsMenuView.isHidden = false
                self.collectionViewHeightConstaint?.constant = self.collectionViewHeight
                self.backgroundSettingsMenuViewHeightConstaint?.constant = self.backgroundSettingsMenuViewHeight
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                    self.layoutIfNeeded()
                }, completion: { (finished) in })
            }
        }else {
            hideSettingsMenu() {}
        }
    }
    public func hideSettingsMenu(onSuccess: @escaping() -> Void) {
        if !self.collectionView.isHidden && !self.backgroundSettingsMenuView.isHidden && !self.isHidden  {
            DispatchQueue.main.async {
                self.collectionViewHeightConstaint?.constant = 0
                self.backgroundSettingsMenuViewHeightConstaint?.constant = 0
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
                    self.layoutIfNeeded()
                }, completion: { (finished) in
                    self.collectionView.isHidden = true
                    self.backgroundSettingsMenuView.isHidden = true
                    self.isHidden = true
                    onSuccess()
                })
            }
        }
    }
    //MARK:-YoutubeSettingsMenuHandler
    fileprivate func actionSettingsMenuDidPressed(settings: YoutubeSettingsMenuItem) {
        hideSettingsMenu { [weak self] in
            switch settings.settingsTitle {
            case .settings: self?.settingsMenuHandler?.didPressedSettingsMenu(settings: settings)
            case .sendFeedback: self?.settingsMenuHandler?.didPressedSendFeedbackMenu(settings: settings)
            case .help: self?.settingsMenuHandler?.didPressedHelpMenu(settings: settings)
            case .cancel: self?.settingsMenuHandler?.didPressedCancelMenu(settings: settings)
            case .switchAccount: self?.settingsMenuHandler?.didPressedSwitchAccountMenu(settings: settings)
            case .termsPrivacy: self?.settingsMenuHandler?.didPressedTermsAndPrivacyMenu(settings: settings)
            }
        }
    }
    //MARK:-CreateConstraints
    private func createCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collection = UICollectionView(frame: self.frame, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(YoutubeSettingsMenuCollectionViewCell.self, forCellWithReuseIdentifier: CellID.youtubeSettingsMenuCellID)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        collection.alpha = 1
        collection.isHidden = true
        collection.isScrollEnabled = false
        addSubview(collection)
        return collection
    }
    private func createYoutubeBlackBackgroundSettingsMenuView() -> UIView {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.isHidden = true
        background.alpha = 0.5
        background.backgroundColor = UIColor.black
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionBackgroundSettingsDidPressed(_ :))))
        addSubview(background)
        bringSubview(toFront: background)
        return background
    }
    //MARK:-SetupConstraints
    private func addAllConstraintsToViews() {
        addConstraintsToCollectionView()
        addConstraintsToBackgroundSettingsMenuView()
    }
    private func addConstraintsToCollectionView() {
        collectionView.leftAnchor.constraint(lessThanOrEqualTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionViewHeightConstaint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstaint?.isActive = true
    }
    private func addConstraintsToBackgroundSettingsMenuView() {
        backgroundSettingsMenuView.leftAnchor.constraint(lessThanOrEqualTo: self.leftAnchor).isActive = true
        backgroundSettingsMenuView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundSettingsMenuView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        backgroundSettingsMenuViewHeightConstaint = backgroundSettingsMenuView.heightAnchor.constraint(equalToConstant: 0)
        backgroundSettingsMenuViewHeightConstaint?.isActive = true
    }
}
extension YoutubeSettingsMenuView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numerOfItemsInSection(section: section)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let settingsCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.youtubeSettingsMenuCellID, for: indexPath) as! YoutubeSettingsMenuCollectionViewCell
        let settingsMenu = viewModel.selectedItemAt(indexPath: indexPath)
        settingsCell.settingsMenu = settingsMenu
        return settingsCell
    }
}
extension YoutubeSettingsMenuView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let settingsMenu = viewModel.selectedItemAt(indexPath: indexPath)
        self.actionSettingsMenuDidPressed(settings: settingsMenu)
    }
}
extension YoutubeSettingsMenuView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            return collectionViewitemSizeToLandscape
        }else {
            return collectionViewItemSizeToPortrait
        }
    }
}
