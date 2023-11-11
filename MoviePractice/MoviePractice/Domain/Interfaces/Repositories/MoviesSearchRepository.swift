//
//  MoviesSearchRepository.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

protocol MoviesSearchRepository {
    @discardableResult
    func fetchMoviesList(
        query: MovieQuery,
        page: Int,
        cached: @escaping (MoviesSearchPage) -> Void,
        completion: @escaping (Result<MoviesSearchPage, Error>)-> Void
    ) -> Cancellable?
}
