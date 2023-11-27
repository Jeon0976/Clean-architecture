//
//  MoviesTopRatedCollectionItemViewModel.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/11.
//

import Foundation

struct MoviesTopRatedCollectionItemViewModel: Equatable {
    let posterImagePath: String?
    let title: String
    let releaseDate: String
    let rating: String
    let ratingCount: String
}

extension MoviesTopRatedCollectionItemViewModel {
    init(movie: MovieWhenTopRated) {
        self.posterImagePath = movie.posterPath
        self.title = movie.title ?? ""
        self.rating = String(movie.rating ?? 0.0)
        self.ratingCount = String(movie.ratingCount)
        if let releaseDate = movie.releaseDate {
            self.releaseDate = "\(NSLocalizedString("Release Date", comment: "")): \(dateFormatter.string(from: releaseDate))"
        } else {
            self.releaseDate = NSLocalizedString("To be announced", comment: "")
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    
    formatter.dateStyle = .medium
    
    return formatter
}()
