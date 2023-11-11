//
//  MovieWhenTopRated.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/10.
//

import Foundation

struct MovieWhenTopRated: Equatable, Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    let title: String?
    let posterPath: String?
    let overview: String?
    let releaseDate: Date?
    let rating: Double?
    let ratingCount: Int
}
