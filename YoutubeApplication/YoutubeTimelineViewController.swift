//
//  YoutubeTimelineViewController.swift
//  YoutubeApplication
//
//  Created by wSong on 12/5/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

protocol YoutubeMenuBarDidSelectItemAtInexPath: class {
    func didSelectMenuBarItemAtIndexPath(_ indexPath: IndexPath)
    func didSelectYoutubeMenuItem(_ item: YoutubeMenuBarItem)
}
protocol YoutubeTimelineContainerViewCellHandler: class {
    func didSelectTimelineYoutubeVideoItem(_ video: YoutubeVideoModel, _ selectedCell: YoutubeTimelineVideoCollectionViewCell)
}
protocol YoutubeTimelineViewControllerInput: YoutubeMainTimelineViewModelOutput {
    
}
class YoutubeTimelineViewController: UICollectionViewController, YoutubeTimelineViewControllerInput, UICollectionViewDelegateFlowLayout, PresenterAlertHandler {
    
    fileprivate enum TimelineMenu: Int {
        case home, trending, subscriptions, account
    }
    
    fileprivate lazy var backgroundImageView: UIImageView = self.createBackgroundImageView()
    fileprivate lazy var menuBar: YoutubeMenuBarView = self.createYoutubeMenuBar()
    fileprivate lazy var settingsMenuView: YoutubeSettingsMenuView = self.createYoutubeSettingsMenuView()
    fileprivate var cellOffset: CGFloat = 20.0
    private var menuBarHeight: CGFloat  = 50.0
    private var itemInsets: CGFloat = 50.0
    weak var selectedYoutubeCell: YoutubeTimelineVideoCollectionViewCell?
    
    fileprivate let viewModel: YoutubeMainTimelineViewModelInput
    //MARK-Loading
    init(viewModel: YoutubeMainTimelineViewModelInput, collectionViewLayout layout: UICollectionViewLayout) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: layout)
        self.viewModel.view = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadVideoData()
        viewModel.updateHomeVideos()
        viewModel.updateAccountVideos()
        viewModel.updateTrendingVideos()
        viewModel.updateSubscriptionVideos()
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
        DispatchQueue.main.async {
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
            self.collectionView.invalidateIntrinsicContentSize()
            self.collectionView.reloadData()
        }
        flowLayout.invalidateLayout()
    }
    //MARK:-TimelineViewControllerInput
    func viewModelDidLoadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func viewModelWillLoadData() {
        //TODO:-Show activity view
    }
    
    func viewModelDidHandleError(_ error: String) {
        DispatchQueue.main.async {
        }
    }
    
    func viewModelDidSelectVideoModel(_ model: YotubeTimelineVideoCellModel, cell: YoutubeTimelineVideoCollectionViewCell) {
        selectedYoutubeCell = cell
        let video = YoutubeVideo(videoTitle: model.videoTitle, thumbnailImage: model.thumbnailImage, videoLinkUrl: model.videoLinkUrl, videoNumberOfViews: model.videoNumberOfViews, videoDuration: model.videoDuration, channel: model.channel)
        viewModel.coordinator?.showYoutubeDetailViewController(YoutubeDetailVideoViewModel(videoItem: video))
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
        flowLayout.sectionHeadersPinToVisibleBounds = false
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = navigationTitleView
        navigationItem.rightBarButtonItems = [setupMoreBarButtonItem(),setupSeratchBarButtonItem()]
    }
    
    private func configureTimelineCollectionView() {
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.contentInset = UIEdgeInsets.init(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets.init(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.decelerationRate = .fast
        self.collectionView.register(YoutubeTimelineContainerCollectionViewCell.self, forCellWithReuseIdentifier: YoutubeTimelineContainerCollectionViewCell.reuseIdentifier)
        self.collectionView.alwaysBounceHorizontal = true
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
        menu.settingsMenuHandler = viewModel
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
        return viewModel.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let iphoneCellModel = viewModel.selectedItemAt(section: indexPath.section, atIndex: indexPath.row)
        let iphoneCell = collectionView.dequeueReusableCell(withReuseIdentifier: iphoneCellModel.cellIdentifier, for: indexPath) as! IdentifiableCollectionViewCell
        iphoneCell.updateModel(iphoneCellModel, viewModel: viewModel)
        return iphoneCell
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
            let width: CGFloat = collectionView.bounds.width
            let height: CGFloat = collectionView.bounds.height - (menuBarHeight + cellOffset)
            let size = CGSize(width: width, height: height)
            return size
        } else {
            let width: CGFloat = collectionView.bounds.width
            let height: CGFloat = collectionView.bounds.height - (menuBarHeight + cellOffset)
            let size = CGSize(width: width, height: height)
            return size
        }
    }
}
extension YoutubeTimelineViewController: YoutubeMenuBarDidSelectItemAtInexPath {
    
    func didSelectMenuBarItemAtIndexPath(_ indexPath: IndexPath) {
        let sctionIndexPath = IndexPath(item: 0, section: indexPath.row)
        self.collectionView.scrollToItem(at: sctionIndexPath, at: .right, animated: true)
        self.collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()
    }
    
    func didSelectYoutubeMenuItem(_ item: YoutubeMenuBarItem) {
        self.navigationTitleView.titleLabel.text = item.itemTitleName.description
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
