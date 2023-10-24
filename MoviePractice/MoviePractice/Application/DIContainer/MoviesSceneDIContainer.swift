//
//  MoviesSceneDIContainer.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

final class MoviesSceneDIContainer: MoviesSearchFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
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
    
    func makeFetchRecentMovieQueriesUseCase(requestValue: FetchRecentMovieQueriesUseCase.RequestValue, completion: @escaping (FetchRecentMovieQueriesUseCase.ResultValue) -> Void) -> UseCase {
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
        let tet =  MoviesRepository.self
        return tet as! MoviesRepository
    }
    
    func makeMoviesQueriesRepository() -> MoviesQueriesRepository {
        let tet =  MoviesQueriesRepository.self
        return tet as! MoviesQueriesRepository
    }
    
}

extension MoviesSceneDIContainer {
    
}
