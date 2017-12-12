//
//  YoutubeTimelineViewController.swift
//  YoutubeApplication
//
//  Created by wSong on 12/5/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit
protocol YoutubeTimelineViewControllerInput: class {
    func didFinishUpdates()
    func didHandleError(_ error: String)
}
class YoutubeTimelineViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, YoutubeTimelineViewControllerInput, PresenterAlertHandler {
    
    fileprivate struct CellID {
        static let youtubeTimelineCellID = "youtubeTimelineCellID"
    }
    private lazy var backgroundImageView: UIImageView = self.createBackgroundImageView()
    private lazy var menuBar: UIView = self.createYoutubeMenuBar()
    private lazy var settingsMenuView: YoutubeSettingsMenuView = self.createYoutubeSettingsMenuView()
    private var cellsOffeset: CGFloat = 20.0
    fileprivate var collectionViewItemSizeToPortrait: CGSize {
        get {
            let width: CGFloat = view.frame.width - cellsOffeset
            let height: CGFloat = (width / 1.15)
            return CGSize(width: width, height: height)
        }
    }
    fileprivate var collectionViewitemSizeToLandscape: CGSize {
        get {
            let width: CGFloat = view.frame.width / 2.1
            let height: CGFloat = (width / 1.5) * (4 / 3)
            return CGSize(width: width, height: height)
        }
    }
    var viewModel = YoutubeTimelineViewModel()
    //MARK-Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        configureCollectionViewLayout()
        configureNavigationBar()
        addAllConstraintsToViews()
        configureTimelineCollectionView()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    //MARK:-YoutubeTimelineViewControllerInput
    func didFinishUpdates() {
        collectionView?.reloadData()
    }
    func didHandleError(_ error: String) {
        presentAlertWith(title: "Data Error", massage: error)
    }
    //MARK:-ConfigureMethods
    fileprivate lazy var navigationTitleView: YoutubeNavigationBarTitleView = {
        let titleView = YoutubeNavigationBarTitleView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        titleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return titleView
    }()
    private func configureCollectionViewLayout() {
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        flowLayout.minimumLineSpacing = 10
    }
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(r: 230, g: 32, b: 31, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationTitleView.titleLabel.text = "Home"
        navigationItem.titleView = navigationTitleView
        navigationItem.rightBarButtonItems = [setupMoreBarButtonItem(),setupSeratchBarButtonItem()]
    }
    private func configureTimelineCollectionView() {
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.contentInset = UIEdgeInsetsMake(50.0, 0, 0, 0)
        self.collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50.0, 0, 0, 0)
        collectionView?.register(YoutubeTimelineCollectionViewCell.self, forCellWithReuseIdentifier: CellID.youtubeTimelineCellID)
    }
    //MARK:-SetupViews
    private func setupSeratchBarButtonItem() -> UIBarButtonItem {
        let image = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(actionSearchButtonDidPressed(_ :)))
        return barButton
    }
    @objc private func actionSearchButtonDidPressed(_ sender: UIBarButtonItem) {
        print("Hello")
    }
    private func setupMoreBarButtonItem() -> UIBarButtonItem {
        let image = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(actionMoreButtonDidPressed(_ :)))
        return barButton
    }
    @objc private func actionMoreButtonDidPressed(_ sender: UIBarButtonItem) {
        settingsMenuView.showSettingsMenu()
    }
    //MARK:-CreateViews
    private func createBackgroundImageView() -> UIImageView {
        let imgeView = UIImageView()
        imgeView.translatesAutoresizingMaskIntoConstraints = false
        imgeView.image = UIImage(named:"Venice")
        imgeView.contentMode = .scaleAspectFill
        return imgeView
    }
    private func createYoutubeMenuBar() -> YoutubeMenuBarView {
        let menu = YoutubeMenuBarView()
        menu.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(menu)
        return menu
    }
    private func createYoutubeSettingsMenuView() -> YoutubeSettingsMenuView {
        let menu = YoutubeSettingsMenuView()
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.isHidden = true
        menu.backgroundColor = UIColor.clear
        self.view.addSubview(menu)
        return menu
    }
    //MARK:-SetupConstraints
    private func addAllConstraintsToViews() {
        addConstraintsToMenuBarView()
        addConstraintsToYoutubeSettingsMenuView()
    }
    private func addConstraintsToMenuBarView() {
        menuBar.leftAnchor.constraint(lessThanOrEqualTo: self.view.leftAnchor).isActive = true
        menuBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        menuBar.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    private func addConstraintsToYoutubeSettingsMenuView() {
        settingsMenuView.leftAnchor.constraint(lessThanOrEqualTo: self.view.leftAnchor).isActive = true
        settingsMenuView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        settingsMenuView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        settingsMenuView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    //MARK:-CollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numerOfItemsInSection(section: section)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let timelineCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.youtubeTimelineCellID, for: indexPath) as! YoutubeTimelineCollectionViewCell
        let video = viewModel.selectedItemAt(indexPath: indexPath)
        timelineCell.youtubeVideo = video
        timelineCell.layoutIfNeeded()
        return timelineCell
    }
    //MARK:-CollectionViewDelegate
    
    //MARK:-UICollectionViewFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            return collectionViewitemSizeToLandscape
        }else {
            return collectionViewItemSizeToPortrait
        }
    }
}














