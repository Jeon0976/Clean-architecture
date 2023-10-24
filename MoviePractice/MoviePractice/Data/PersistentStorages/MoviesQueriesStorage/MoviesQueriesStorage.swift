//
//  MovieQueriesStorage.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

protocol MoviesQueriesStorage {
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[MovieQuery], Error>) -> Void
    )
    
    func saveRecentQuery(
        query: MovieQuery,
        completion: @escaping (Result<MovieQuery, Error>) -> Void
    )
}
