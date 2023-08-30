//
//  LoadMovieDetailUseCase.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/08/30.
//

import Foundation

protocol LoadMovieDetailUseCase {
    func execute(
        requestValue: LoadMovieDetailUseCaseRequestValue,
        completion: @escaping (Result<MovieDetail, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultLoadMovieDetailUseCase: LoadMovieDetailUseCase {
    
    private let movieDetailRepository : MovieDetailRepository
    
    init(movieDetailRepository: MovieDetailRepository) {
        self.movieDetailRepository = movieDetailRepository
    }
  
    func execute(
        requestValue: LoadMovieDetailUseCaseRequestValue,
        completion: @escaping (Result<MovieDetail, Error>) -> Void
    ) -> Cancellable? {
        return movieDetailRepository.fetchMovieDetail(
            movieId: requestValue.moveId,
            language: requestValue.language
        ) { result in
            completion(result)
        }
    }
}

struct LoadMovieDetailUseCaseRequestValue {
    let moveId: Int
    let language: String
}

