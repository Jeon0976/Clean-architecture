//
//  MoviewDetailsViewModel.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/26.
//

import Foundation
import UIKit.UIColor

protocol MovieDetailsViewModelInput {
    func updatePosterImage(width: Int)
}

protocol MovieDetailsViewModelOutput {
    var title: String { get }
    var posterImage: Observable<Data?> { get }
    var isPosterImageHidden: Bool { get }
    var overview: String { get }
    var backgroundColor: Observable<UIColor?> { get }
    var textColor: Observable<UIColor?> { get }
    
}

typealias MovieDetailsViewModel = MovieDetailsViewModelInput & MovieDetailsViewModelOutput

final class DefaultMovieDetailsViewModel: MovieDetailsViewModel {
    
    private let posterImagePath: String?
    private let posterImagesRepository: PosterImagesRepository
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() }}
    private let mainQueue: DispatchQueueType
    
    // MARK: Output
    let title: String
    let isPosterImageHidden: Bool
    let overview: String
    let posterImage: Observable<Data?> = Observable(nil)
    let backgroundColor: Observable<UIColor?> = Observable(nil)
    let textColor: Observable<UIColor?> = Observable(nil)
    
    init(
        movie: Movie,
        posterImagesRepository: PosterImagesRepository,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.title = movie.title ?? ""
        self.overview = movie.overview ?? ""
        self.posterImagePath = movie.posterPath
        self.isPosterImageHidden = movie.posterPath == nil
        self.posterImagesRepository = posterImagesRepository
        self.mainQueue = mainQueue
    }
    
    private func updateColors(with data: Data?) {
        guard let data = data, let image = UIImage(data: data),
              let dominantColor = image.dominantColor() else {
            backgroundColor.value = .white
            textColor.value = .black
            return
        }
        
        backgroundColor.value = dominantColor
        textColor.value = dominantColor.appropriateTextColor()
    }
}

// MARK: Input
extension DefaultMovieDetailsViewModel {
    func updatePosterImage(width: Int) {
        guard let posterImagePath = posterImagePath else { return }
        
        imageLoadTask = posterImagesRepository.fetchImage(
            with: posterImagePath,
            width: width) { [weak self] result in
                self?.mainQueue.async {
                    guard self?.posterImagePath == posterImagePath else { return }
                    
                    switch result {
                    case .success(let data):
                        self?.posterImage.value = data
                        self?.updateColors(with: data)
                    case .failure:
                        break
                    }
                    
                    self?.imageLoadTask = nil
                }
            }
    }
}
