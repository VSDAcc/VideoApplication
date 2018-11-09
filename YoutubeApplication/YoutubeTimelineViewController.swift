//
//  YoutubeTimelineViewController.swift
//  YoutubeApplication
//
//  Created by wSong on 12/5/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

protocol YoutubeSettingsMenuHandler: class {
    func didPressedSettingsMenu(settings: YoutubeSettingsMenuItem)
    func didPressedTermsAndPrivacyMenu(settings: YoutubeSettingsMenuItem)
    func didPressedSendFeedbackMenu(settings: YoutubeSettingsMenuItem)
    func didPressedHelpMenu(settings: YoutubeSettingsMenuItem)
    func didPressedSwitchAccountMenu(settings: YoutubeSettingsMenuItem)
    func didPressedCancelMenu(settings: YoutubeSettingsMenuItem)
}
protocol YoutubeMenuBarDidSelectItemAtInexPath: class {
    func didSelectMenuBarItemAtIndexPath(_ indexPath: IndexPath)
    func didSelectYoutubeMenuItem(_ item: YoutubeMenuBarItem)
}
protocol YoutubeTimelineContainerViewCellHandler: class {
    func didSelectTimelineYoutubeVideoItem(_ video: YoutubeVideoModel, _ selectedCell: YoutubeTimelineCollectionViewCell)
}
class YoutubeTimelineViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PresenterAlertHandler {
    
    fileprivate struct CellID {
        static let youtubeTimelineHomeCellID = "youtubeTimelineHomeCell"
        static let youtubeTimelineTrendingCellID = "youtubeTimelineTrendingCell"
        static let youtubeTimelineSubscriptionsCellID = "youtubeTimelineSubscriptionsCell"
        static let youtubeTimelineAccountCellID = "youtubeTimelineAccountCell"
    }
    fileprivate enum TimelineMenu: Int {
        case home, trending, subscriptions, account
    }
    fileprivate lazy var backgroundImageView: UIImageView = self.createBackgroundImageView()
    fileprivate lazy var menuBar: YoutubeMenuBarView = self.createYoutubeMenuBar()
    fileprivate lazy var settingsMenuView: YoutubeSettingsMenuView = self.createYoutubeSettingsMenuView()
    private var menuBarHeight: CGFloat  = 50.0
    private var itemInsets: CGFloat = 50.0
    var selectedYoutubeCell: YoutubeTimelineCollectionViewCell?
    
    fileprivate var collectionViewItemSizeToPortrait: CGSize {
        get {
            let width: CGFloat = view.frame.width
            let height: CGFloat = view.frame.height - menuBarHeight * 2
            return CGSize(width: width, height: height)
        }
    }
    fileprivate var collectionViewitemSizeToLandscape: CGSize {
        get {
            let width: CGFloat = view.frame.width
            let height: CGFloat = view.frame.height - menuBarHeight * 2
            return CGSize(width: width, height: height)
        }
    }
    fileprivate let viewModel: YoutubeMainTimelineViewModelInput
    
    //MARK-Loading
    init(viewModel: YoutubeMainTimelineViewModelInput, collectionViewLayout layout: UICollectionViewLayout) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewLayout()
        configureNavigationBar()
        addAllConstraintsToViews()
        configureTimelineCollectionView()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView?.collectionViewLayout as? YoutubeCollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
        DispatchQueue.main.async {
          self.collectionView?.reloadData()
        }
    }
    //MARK:-ConfigureMethods
    fileprivate lazy var navigationTitleView: YoutubeNavigationBarTitleView = {
        let titleView = YoutubeNavigationBarTitleView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        titleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleView.titleLabel.text = "Home"
        return titleView
    }()
    
    private func configureCollectionViewLayout() {
        guard let flowLayout = collectionView?.collectionViewLayout as? YoutubeCollectionViewFlowLayout else {
            return
        }
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = navigationTitleView
        navigationItem.rightBarButtonItems = [setupMoreBarButtonItem(),setupSeratchBarButtonItem()]
    }
    
    private func configureTimelineCollectionView() {
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView?.scrollIndicatorInsets = UIEdgeInsets.init(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.register(YoutubeTimelineHomeCollectionViewCell.self, forCellWithReuseIdentifier: CellID.youtubeTimelineHomeCellID)
        self.collectionView?.register(YoutubeTimelineTrendingCollectionViewCell.self, forCellWithReuseIdentifier: CellID.youtubeTimelineTrendingCellID)
        self.collectionView?.register(YoutubeTimelineSubscriptionsCollectionViewCell.self, forCellWithReuseIdentifier: CellID.youtubeTimelineSubscriptionsCellID)
        self.collectionView?.register(YoutubeTimelineAccountCollectionViewCell.self, forCellWithReuseIdentifier: CellID.youtubeTimelineAccountCellID)
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
        menu.menuBarDidSelectItemAtInexPath = self
        self.view.addSubview(menu)
        return menu
    }
    
    private func createYoutubeSettingsMenuView() -> YoutubeSettingsMenuView {
        let menu = YoutubeSettingsMenuView()
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.isHidden = true
        menu.backgroundColor = UIColor.clear
        menu.settingsMenuHandler = self
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
        menuBar.heightAnchor.constraint(equalToConstant: menuBarHeight).isActive = true
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
        return menuBar.viewModel.numerOfItemsInSection()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifire: String
        if indexPath.row == TimelineMenu.home.rawValue {
            identifire = CellID.youtubeTimelineHomeCellID
        } else if indexPath.row == TimelineMenu.trending.rawValue {
            identifire = CellID.youtubeTimelineTrendingCellID
        } else if indexPath.row == TimelineMenu.subscriptions.rawValue {
            identifire = CellID.youtubeTimelineSubscriptionsCellID
        } else {
            identifire = CellID.youtubeTimelineAccountCellID
        }
        let timelineCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifire, for: indexPath) as! YoutubeTimelineContainerCollectionViewCell
        timelineCell.youtubeTimelineContainerViewCellHandler = self
        DispatchQueue.main.async {
            timelineCell.setNeedsLayout()
            timelineCell.layoutIfNeeded()
        }
        return timelineCell
    }
    //MARK:-ScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x / 4
        menuBar.underlineConstraintConstant = offset
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.menuSelectedItem = indexPath
    }
    //MARK:-UICollectionViewFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            return collectionViewitemSizeToLandscape
        }else {
            return collectionViewItemSizeToPortrait
        }
    }
}
extension YoutubeTimelineViewController: YoutubeSettingsMenuHandler {
    func didPressedSettingsMenu(settings: YoutubeSettingsMenuItem) {
        
        print(settings.settingsTitle)
    }
    
    func didPressedTermsAndPrivacyMenu(settings: YoutubeSettingsMenuItem) {
        print(settings.settingsTitle)
    }
    
    func didPressedSendFeedbackMenu(settings: YoutubeSettingsMenuItem) {
        print(settings.settingsTitle)
    }
    
    func didPressedHelpMenu(settings: YoutubeSettingsMenuItem) {
        print(settings.settingsTitle)
    }
    
    func didPressedSwitchAccountMenu(settings: YoutubeSettingsMenuItem) {
        print(settings.settingsTitle)
    }
    
    func didPressedCancelMenu(settings: YoutubeSettingsMenuItem) {
        print(settings.settingsTitle)
    }
}
extension YoutubeTimelineViewController: YoutubeMenuBarDidSelectItemAtInexPath {
    
    func didSelectMenuBarItemAtIndexPath(_ indexPath: IndexPath) {
        self.collectionView?.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    func didSelectYoutubeMenuItem(_ item: YoutubeMenuBarItem) {
        self.navigationTitleView.titleLabel.text = item.itemTitleName.description
    }
}
extension YoutubeTimelineViewController: YoutubeTimelineContainerViewCellHandler {
    
    func didSelectTimelineYoutubeVideoItem(_ video: YoutubeVideoModel, _ selectedCell: YoutubeTimelineCollectionViewCell) {
        selectedYoutubeCell = selectedCell
        viewModel.coordinator?.showYoutubeDetailViewController(YoutubeDetailVideoViewModel(videoItem: video))
    }
}
extension YoutubeTimelineViewController: ListToDetailAnimatable {

    var morphViews: [UIView] {
        return [selectedYoutubeCell!.thumbnailImageView]
    }
    
    var animatableCells: [UICollectionViewCell] {
        return (collectionView?.visibleCells.filter({$0 != selectedYoutubeCell}))!
    }
}
