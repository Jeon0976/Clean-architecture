//
//  MoviesTopRatedCollectionItemViewModel.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/11.
//

import Foundation

struct MoviesTopRatedCollectionItemViewModel: Equatable {
    let posterImagePath: String?
}

extension MoviesTopRatedCollectionItemViewModel {
    init(movie: MovieWhenTopRated) {
        self.posterImagePath = movie.posterPath
    }
}

