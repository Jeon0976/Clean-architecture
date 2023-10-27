//
//  UIImage+imageColor.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/27.
//

import Foundation

import UIKit

extension UIImage {
    func dominantColor() -> UIColor? {
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        let context = CGContext(data: &bitmap,
                                 width: 1,
                                 height: 1,
                                 bitsPerComponent: 8,
                                 bytesPerRow: 4,
                                 space: CGColorSpaceCreateDeviceRGB(),
                                 bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        return UIColor(red: CGFloat(bitmap[0]) / 255.0,
                       green: CGFloat(bitmap[1]) / 255.0,
                       blue: CGFloat(bitmap[2]) / 255.0,
                       alpha: CGFloat(bitmap[3]) / 255.0)
    }
}

extension UIColor {
    var isLight: Bool {
        var white: CGFloat = 0
        self.getWhite(&white, alpha: nil)
        return white > 0.5
    }

    static var appropriateTextColor: UIColor {
        return UIColor.white
    }

    func appropriateTextColor() -> UIColor {
        return self.isLight ? .black : .white
    }
}
