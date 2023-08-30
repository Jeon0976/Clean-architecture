//
//  MovieDetail.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/08/30.
//

import Foundation

struct MovieDetail: Equatable, Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    let title: String?
    let posterPath: String?
    let genres: [Genre]?
    let overview: String?
    let voteAverage: Double?
}

struct Genre: Equatable {
    let genre: String?
}
