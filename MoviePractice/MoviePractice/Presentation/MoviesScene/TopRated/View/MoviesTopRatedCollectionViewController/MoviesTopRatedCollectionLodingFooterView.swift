//
//  MoviesTopRatedCollectionLodingFooterView.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/12.
//

import UIKit

final class MoviesTopRatedCollectionLodingFooterView: UICollectionReusableView {
    static let identifier = String(describing: MoviesTopRatedCollectionLodingFooterView.self)
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .black
        indicator.startAnimating()
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

