//
//  SearchMoviesUseCase.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

protocol SearchMoviesUseCase {
    func execute(
        requestValue: SearchMoviesUseCaseRequestValue,
        cached: @escaping (MoviesPage) -> Void,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable?
}

struct SearchMoviesUseCaseRequestValue {
    let query: MovieQuery
    let page: Int
}

final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {
    private let moviesRepository: MOviesRe
}
