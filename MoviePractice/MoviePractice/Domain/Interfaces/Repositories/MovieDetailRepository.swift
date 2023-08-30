//
//  MovieDetailRepository.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/08/30.
//

import Foundation

protocol MovieDetailRepository {
    @discardableResult
    func fetchMovieDetail(
        movieId: Int,
        language: String,
        completion: @escaping (Result<MovieDetail, Error>) -> Void
    ) -> Cancellable?
}
