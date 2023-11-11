//
//  MoviesRequestDTO+Mapping.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

struct MoviesSearchRequestDTO: Encodable {
    let query: String
    let page: Int
}
