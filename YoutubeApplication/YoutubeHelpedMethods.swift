//
//  YoutubeHelpedMethods.swift
//  YoutubeApplication
//
//  Created by wSong on 12/7/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
struct YoutubeHelpedMethods {
    
    func formateNumberToStringInDecimalFormat(_ number: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = true
        return formatter.string(from: number)!
    }
    func configureEstimatedHeightForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200.0, height: 1000.0)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [:], context: nil)
    }
    func formateCMTimeToString(time: CMTime) -> String {
        var textTime = "00:00"
        let seconds = CMTimeGetSeconds(time)
        let textSeconds = Int(seconds) % 60
        let textMinutes = String(format: "%02d", Int(seconds) / 60)
        textTime = "\(textMinutes):\(textSeconds)"
        return textTime
    }
    func downloadImageUsingCacheWithComplitionBlock(stringURL: String, onSuccess: @escaping(_ image: UIImage) -> (), onFailure: @escaping() -> ()) {
        let imageManager = SDWebImageManager.shared()
        if let image = imageManager.imageCache?.imageFromCache(forKey: stringURL) {
            DispatchQueue.main.async {
                onSuccess(image)
            }
        }else {
            if let imageURL = URL(string: stringURL) {
                _ = imageManager.imageDownloader?.downloadImage(with: imageURL, options: [.continueInBackground,.progressiveDownload], progress: nil, completed: {  (image, data, error, completed) in
                    if completed {
                        DispatchQueue.main.async {
                            onSuccess(image!)
                        }
                        imageManager.imageCache?.store(image, forKey: stringURL, completion: nil)
                    }else if error != nil {
                        DispatchQueue.main.async {
                            onFailure()
                        }
                    }
                })
            }
        }
    }
}
