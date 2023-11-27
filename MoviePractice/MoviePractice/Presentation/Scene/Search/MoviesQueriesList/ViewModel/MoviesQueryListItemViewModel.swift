//
//  MoviesQueryListItemViewModel.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/26.
//

import Foundation

class MoviesQueryListItemViewModel {
    let query: String
    
    init(query: String) {
        self.query = query
    }
}

extension MoviesQueryListItemViewModel: Equatable {
    static func == (lhs: MoviesQueryListItemViewModel, rhs: MoviesQueryListItemViewModel) -> Bool {
        return lhs.query == rhs.query
    }
}
