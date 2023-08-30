//
//  Movie.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/08/30.
//

import Foundation

struct Movie: Equatable, Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    let title: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: Date?
    let voteAverage: Double?
}

struct MoviesPage: Equatable {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}
