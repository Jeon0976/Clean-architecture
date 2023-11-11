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
        cached: @escaping (MoviesSearchPage) -> Void,
        completion: @escaping (Result<MoviesSearchPage, Error>) -> Void
    ) -> Cancellable?
}

struct SearchMoviesUseCaseRequestValue {
    let query: MovieQuery
    let page: Int
}

final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {
    
    private let moviesRepository: MoviesSearchRepository
    private let moviesQueriesRepository: MoviesQueriesRepository
    
    init(
        moviesRepository: MoviesSearchRepository,
        moviesQueriesRepository: MoviesQueriesRepository
    ) {
        self.moviesRepository = moviesRepository
        self.moviesQueriesRepository = moviesQueriesRepository
    }
    
    // TODO: 뭘 의미하는걸까??
    // fetch해서 local에 있는지 없는지에 따라 분기 처리를 위해서 fetch movies list 사용
    func execute(
        requestValue: SearchMoviesUseCaseRequestValue,
        cached: @escaping (MoviesSearchPage) -> Void,
        completion: @escaping (Result<MoviesSearchPage, Error>) -> Void
    ) -> Cancellable? {
        return moviesRepository.fetchMoviesList(
            query: requestValue.query,
            page: requestValue.page,
            cached: cached
        ) { result in
            if case .success = result {
                self.moviesQueriesRepository.saveRecentQuery(query: requestValue.query) { _ in }
            }
            
            completion(result)
        }
    }
}
