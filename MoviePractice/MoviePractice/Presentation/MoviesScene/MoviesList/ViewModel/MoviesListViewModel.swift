//
//  MoviesListViewModel.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/25.
//

import Foundation

struct MoviesListViewModelActions {
    let showMovieDetails: (Movie) -> Void
    let showMovieQueriesSuggestions: (@escaping (_ disSelect: MovieQuery) -> Void) -> Void
    let closeMovieQueriesSuggestions: () -> Void
}

enum MoviesListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol MoviesListviewModelInput {
    
}

protocol MoviesListViewModelOutput {
    
}

typealias MoviesListViewModel = MoviesListviewModelInput & MoviesListViewModelOutput

final class DefaultMoviesListViewmodel: MoviesListViewModel {
    
}
