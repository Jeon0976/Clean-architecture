//
//  MoviesListItemCell.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/25.
//

import UIKit

final class MoviesListItemCell: UITableViewCell {
    static let reuseIdentifier = String(describing: MoviesListItemCell.self)
    static let height = CGFloat(130)
    
    private var viewModel: MoviesListViewModel!
    private var posterImagesRepository: PosterImagesRepository?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() }}
    private let mainQueue: DispatchQueueType = DispatchQueue.main
    
    func fill(
        with viewModel: MoviesListViewModel,
        posterImagesRepository: PosterImagesRepository?
    ) {
        self.viewModel = viewModel
        self.posterImagesRepository = posterImagesRepository
        
        
    }
}
