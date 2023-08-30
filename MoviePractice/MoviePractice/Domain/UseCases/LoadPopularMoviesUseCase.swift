//
//  LoadPopularMoviesUseCase.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/08/30.
//

import Foundation

protocol LoadPopularMoviesUseCase {
    func execute(
        requestValue: LoadPopularMoviesUseCaseRequestValue,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultLoadPopularMoviesUseCase: LoadPopularMoviesUseCase {
    
    private let popularMoviesRepository: PopularMoviesRepository
    
    init(popularMoviesRepository: PopularMoviesRepository) {
        self.popularMoviesRepository = popularMoviesRepository
    }
    
    func execute(
        requestValue: LoadPopularMoviesUseCaseRequestValue,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable? {
        return popularMoviesRepository.fetchMoviesList(
            language: requestValue.language,
            page: requestValue.page
        ) { result in
            completion(result)
        }
    }
}

struct LoadPopularMoviesUseCaseRequestValue {
    let language: String
    let page: Int
}
