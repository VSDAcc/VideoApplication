//
//  YoutubeExtensions.swift
//  YoutubeApplication
//
//  Created by wSong on 12/5/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
import AVFoundation

protocol PresenterAlertHandler {
    func presentAlertWith(title: String, massage: String)
}

extension PresenterAlertHandler where Self: UIViewController {
    func presentAlertWith(title: String, massage: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
}

protocol PresenterVideoHandler {
    func presentVideoWith(url: URL)
}

extension PresenterVideoHandler where Self: UIViewController {
    func presentVideoWith(url: URL) {
        let playerController = AVPlayerViewController()
        let player = AVPlayer(url: url)
        playerController.player = player
        present(playerController, animated: true, completion: nil)
    }
}

extension UIFont {
    var avenirNextRegularTitleFont: UIFont! {
        return UIFont(name: "AvenirNext-Regular", size: 18.0)
    }
    var avenirNextRegularDescriptionFont: UIFont! {
        return UIFont(name: "AvenirNext-Regular", size: 14.0)
    }
    var avenirNextRegularTimeFont: UIFont! {
        return UIFont(name: "AvenirNext-Regular", size: 16.0)
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
    }
}

extension UIImageView {
    func downloadImageUsingCache(stringURL: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            let imageManager = SDWebImageManager.shared()
            if let image = imageManager.imageCache?.imageFromCache(forKey: stringURL) {
                DispatchQueue.main.async {
                    self.image = image
                }
                return
            }else {
                if let imageURL = URL(string: stringURL) {
                    _ = imageManager.imageDownloader?.downloadImage(with: imageURL, options: [.continueInBackground,.progressiveDownload], progress: nil, completed: {  (image, data, error, completed) in
                        if completed {
                            DispatchQueue.main.async {
                                self.image = image
                            }
                            imageManager.imageCache?.store(image, forKey: stringURL, completion: nil)
                        }
                    })
                }
            }
        }
    }
}

extension UIView {
    
    func snapshotView(view: UIView, afterUpdates: Bool) -> UIView {
        let snapshot = view.snapshotView(afterScreenUpdates: afterUpdates)!
        self.addSubview(snapshot)
        snapshot.frame = convert(view.bounds, from: view)
        return snapshot
    }
    
    func snapshotViews(views: [UIView], afterUpdates: Bool) -> [UIView] {
        return views.map({snapshotView(view: $0, afterUpdates: afterUpdates)})
    }
    
    func scaleSnapshotToView(toView: UIView) -> CGAffineTransform {
        return CGAffineTransform(scaleX: bounds.width / toView.bounds.width,
                                 y: bounds.height / toView.bounds.height)
    }
}

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
