//
//  MoviesTopRatedViewModel.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/10.
//

import Foundation

struct MoviesTopRatedViewModelActions {
//    let showMovieDetails: (MovieWhenSearch) -> Void
}

protocol MoviesTopRatedModelInput {
    
}

protocol MoviesTopRatedModelOutput {
    
}

typealias MoviesTopRatedViewModel = MoviesTopRatedModelInput & MoviesTopRatedModelOutput

final class DefaultMoviesTopRatedViewModel: MoviesTopRatedViewModel {
    
    private let topRatedMoviesUseCase: TopRatedMoviesUseCase!
    private let actions: MoviesTopRatedViewModelActions!
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    private var pages: [MoviesSearchPage] = []
    private let mainQueue: DispatchQueueType
    
    init(
        topRatedMoviesUseCase: TopRatedMoviesUseCase,
        actions: MoviesTopRatedViewModelActions,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.topRatedMoviesUseCase = topRatedMoviesUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }
}
