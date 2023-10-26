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
    lazy var moviesQueriesStorage: MoviesQueriesStorage = CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
    lazy var moviesResponseCache: MoviesResponseStorage = CoreDataMoviesResponseStorage()
    
    // MARK: Persistent Storage
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
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
    func makeMoviesRepository() -> MoviesRepository {
        DefaultMoviesRepository(
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
    func makeMoviesListViewController(actions: MoviesListViewModelActions) -> MoviesListViewController {
        MoviesListViewController.create(
            with: makeMoviesListViewModel(actions: actions),
            posterImagesRepostiory: makePosterImagesRepository()
        )
    }
    
    func makeMoviesListViewModel(actions: MoviesListViewModelActions) -> MoviesListViewModel {
        DefaultMoviesListViewmodel(
            searchMoviesUseCase: makeSearchMoviesUseCase(),
            actions: actions
        )
    }
    
    // MARK: Movie Details
    
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
            navigationController: navigationController,
            dependencies: self
        )
    }
}
