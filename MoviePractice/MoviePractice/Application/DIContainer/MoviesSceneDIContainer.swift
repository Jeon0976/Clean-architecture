//
//  MoviesSceneDIContainer.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import UIKit
import SwiftUI

final class MoviesSceneDIContainer: MoviesSearchFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: Persistent Storage
    lazy var moviesQueriesStorage: MoviesQueriesStorage = CoreDataMoviesQueriesStorage(maxStorageLimit: 15)
    lazy var moviesResponseCache: MoviesResponseStorage = CoreDataMoviesResponseStorage()
        
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        print("Init")
    }
    
    deinit {
        print("Deinit")
    }
    
    // MARK: Use Cases
    func makeSearchMoviesUseCase() -> SearchMoviesUseCase {
        DefaultSearchMoviesUseCase(
            moviesRepository: makeMoviesRepository(),
            moviesQueriesRepository: makeMoviesQueriesRepository()
        )
    }
    
    func makeFetchRecentMovieQueriesUseCase(
        requestValue: FetchRecentMovieQueriesUseCase.RequestValue,
        completion: @escaping (FetchRecentMovieQueriesUseCase.ResultValue) -> Void
    ) -> UseCase {
        FetchRecentMovieQueriesUseCase(
            requestValue: requestValue,
            completion: completion,
            moviesQueriesRepository: makeMoviesQueriesRepository()
        )
    }
}

// MARK: Repositories
extension MoviesSceneDIContainer {
    func makeMoviesRepository() -> MoviesSearchRepository {
        DefaultMoviesSearchRepository(
            dataTransferService: dependencies.apiDataTransferService,
            cache: moviesResponseCache
        )
    }
    
    func makeMoviesQueriesRepository() -> MoviesQueriesRepository {
        DefaultMoviesQueriesRepository(
            moviesQueriesPersistentStorage: moviesQueriesStorage
        )
    }
    
    func makePosterImagesRepository() -> PosterImagesRepository {
        DefaultPosterImagesRepository(
            dataTransferService: dependencies.imageDataTransferService
        )
    }
}

extension MoviesSceneDIContainer {
    // MARK: Movie List
    func makeMoviesListViewController(
        actions: MoviesListViewModelActions) -> MoviesListViewController {
        MoviesListViewController.create(
            with: makeMoviesListViewModel(actions: actions),
            posterImagesRepostiory: makePosterImagesRepository()
        )
    }
    
    private func makeMoviesListViewModel(actions: MoviesListViewModelActions) -> MoviesListViewModel {
        
        DefaultMoviesListViewModel(
            searchMoviesUseCase: makeSearchMoviesUseCase(),
            actions: actions
        )
    }
    
    // MARK: Movie Details
    func makeMoviesDetailsViewController(movie: MovieWhenSearch) -> UIViewController {
        MovieDetailsViewController.create(with: makeMoviesDetailViewModel(movie: movie))
    }
    
    private func makeMoviesDetailViewModel(movie: MovieWhenSearch) -> MovieDetailsViewModel {
        DefaultMovieDetailsViewModel(
            movie: movie,
            posterImagesRepository: makePosterImagesRepository()
        )
    }
    
    
    // MARK: Movies Queries Suggestions List
    func makeMoviesQueriesSuggestionsListViewController(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> UIViewController {
        MoviesQueriesTableViewController.create(with: makeMoviesQueryListViewModel(didSelect: didSelect))
    }
    
    func makeMoviesQueryListViewModel(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> MoviesQueryListViewModel {
        DefaultMoviesQueryListViewModel(
            numberOfQueriesToShow: 15,
            fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase,
            didSelect: didSelect
        )
    }
    
    // MARK: Flow Coordinators
    func makeMovieSearchFlowCoordinator(navigationController: UINavigationController) -> MoviesSearchFlowCoordinator {
        MoviesSearchFlowCoordinator(
            viewController: navigationController,
            dependencies: self
        )
    }
}
