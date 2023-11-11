//
//  MoviesPage.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/10.
//

import Foundation

struct MoviesSearchPage: Equatable {
    let page: Int
    let totalPages: Int
    let movies: [MovieWhenSearch]
}

struct MoviesTopRatedPage: Equatable {
    let page: Int
    let totalPages: Int
    let movies: [MovieWhenTopRated]
}
