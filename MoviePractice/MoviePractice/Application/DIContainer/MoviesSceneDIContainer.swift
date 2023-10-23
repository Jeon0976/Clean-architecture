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
    
    func makeSearchMoviesUseCase() -> SearchMoviesUseCase
}
