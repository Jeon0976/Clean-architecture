//
//  PopularMoviesRepository.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/08/30.
//

import Foundation

protocol PopularMoviesRepository {
    @discardableResult
    func fetchMoviesList(
        language: String,
        page: Int,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable? 
}
