//
//  UIViewController+ActivityIndicator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/25.
//

import UIKit

extension UITableViewController {
    func makeActivityIndicator(size: CGSize) -> UIActivityIndicatorView {
        let style: UIActivityIndicatorView.Style
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                style = .medium
            } else {
                style = .large
            }
        } else {
            style = .gray
        }
        
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: size)
        
        return activityIndicator
    }
}

