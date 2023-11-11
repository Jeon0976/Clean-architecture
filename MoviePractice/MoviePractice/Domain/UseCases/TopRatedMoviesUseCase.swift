//
//  TopRatedMoviesUseCase.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/10.
//

import Foundation

protocol TopRatedMoviesUseCase {
    func execute(
        requestValue: TopRatedMoviesUseCaseRequestValue,
        completion: @escaping (Result<MoviesTopRatedPage, Error>) -> Void
    ) -> Cancellable?
}

struct TopRatedMoviesUseCaseRequestValue {
    let page: Int
}

final class DefaultTopRatedMoviesUseCase: TopRatedMoviesUseCase {
    
    private let moviesTopRatedRepository: MoviesTopRatedRepository
    
    init(
        moviesTopRatedRepository: MoviesTopRatedRepository
    ) {
        self.moviesTopRatedRepository = moviesTopRatedRepository
    }
    
    func execute(
        requestValue: TopRatedMoviesUseCaseRequestValue,
        completion: @escaping (Result<MoviesTopRatedPage, Error>) -> Void
    ) -> Cancellable? {
        return moviesTopRatedRepository.fetchMoviesList(page: requestValue.page) { result in
            completion(result)
        }
    }
}
