//
//  MoviesTopRatedRepository.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/10.
//

import Foundation

protocol MoviesTopRatedRepository {
    @discardableResult
    func fetchMoviesList(
        page: Int,
        completion: @escaping (Result<MoviesTopRatedPage, Error>) -> Void
    ) -> Cancellable?
}
