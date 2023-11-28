//
//  MoviesTopRatedDIContainer.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/01.
//

import UIKit

final class MoviesTopRatedDIContainer: MoviesTopRatedFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: Use Case
extension MoviesTopRatedDIContainer {
    func makeTopRatedMoviesUseCase() -> TopRatedMoviesUseCase {
        DefaultTopRatedMoviesUseCase(moviesTopRatedRepository: makeTopRatedMoviesRepository())
    }
}

// MARK: Repositories
extension MoviesTopRatedDIContainer {
    private func makeTopRatedMoviesRepository() -> MoviesTopRatedRepository {
        DefaultMoviesTopRatedRepository(
            dataTransferService: dependencies.apiDataTransferService
        )
    }
    
    private func makePosterImagesRepository() -> PosterImagesRepository {
        DefaultPosterImagesRepository(dataTransferService: dependencies.imageDataTransferService)
    }
}

// MARK: Presentation
extension MoviesTopRatedDIContainer {
    /// ViewController
    func makeMoviesTopRatedViewController(actions: MoviesTopRatedViewModelActions) -> MoviesTopRatedViewController {
        MoviesTopRatedViewController.create(
            with: makeMoviesTopRatedViewModel(actions: actions),
            posterImageRepository: makePosterImagesRepository()
        )
    }
    
    private func makeMoviesTopRatedViewModel(actions: MoviesTopRatedViewModelActions) -> MoviesTopRatedViewModel {
        DefaultMoviesTopRatedViewModel(
            topRatedMoviesUseCase: makeTopRatedMoviesUseCase(),
            actions: actions
        )
    }
    
    func makeMoviesTopRatedFlowCoordinator(navigationController: UINavigationController) -> MoviesTopRatedFlowCoordinator {
        MoviesTopRatedFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
}
