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
        guard !(seconds.isNaN || seconds.isInfinite) else {
            return textTime // illegal value
        }
        let textSeconds = Int(seconds) % 60
        let textMinutes = String(format: "%02d", Int(seconds) / 60)
        textTime = "\(textMinutes):\(textSeconds)"
        return textTime
    }
    
    func thumbnailImageFromVideoURL(_ url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch {
            return nil
        }
    }
    
    func downloadImageUsingCacheWithComplitionBlock(stringURL: String, onSuccess: @escaping(_ image: UIImage) -> (), onFailure: @escaping() -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
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
}
