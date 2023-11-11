//
//  Movie.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/08/30.
//

import Foundation

struct MovieWhenSearch: Equatable, Identifiable {
    typealias Identifier = String
    
    enum Genre {
        case adventure
        case scienceFiction
    }
    
    let id: Identifier
    let title: String?
    let genre: Genre? 
    let posterPath: String?
    let overview: String?
    let releaseDate: Date?
}
