//
//  PosterImagesUseCase.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/12/01.
//

import Foundation

protocol PosterImagesUseCase {
    func execute(
        requestValue: PosterImagesPathRequestValue,
        completion: @escaping(Result<Data, Error>) -> Void
    ) -> Cancellable?
}

struct PosterImagesPathRequestValue {
    let imagePath: String
    let imageWidth: Int
}

final class DefaultPosterImagesUseCase: PosterImagesUseCase {
    
    private let posterImagesRepository: PosterImagesRepository
    
    init(
        posterImagesRepository: PosterImagesRepository
    ) {
        self.posterImagesRepository = posterImagesRepository
    }
    
    func execute(
        requestValue: PosterImagesPathRequestValue,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable? {
        return posterImagesRepository.fetchImage(
            with: requestValue.imagePath,
            width: requestValue.imageWidth) { result in
                completion(result)
            }
    }
}
