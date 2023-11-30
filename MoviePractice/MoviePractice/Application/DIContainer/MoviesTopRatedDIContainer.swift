//
//  MoviesTopRatedDIContainer.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/01.
//

import UIKit

/// Movies TopRated 화면에 대한 의존성 주입을 관리하는 Container입니다.
final class MoviesTopRatedDIContainer: MoviesTopRatedFlowCoordinatorDependencies {
    
    // MARK: Dependencies
    
    /// Movie Top Rated 화면에서 필요한 Service를 구조체로 갖고 해당 구조체는 `ApiDataTransferService`, `ImageDataTransferService`를 갖고있습니다.
    /// - 해당 `Dependencies`는 `AppDIContainer`에서  `makeMoviesTopRatedDIContainer()` 메서드를 실행할 때 주입받습니다.
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    /// AppDIContainer에서 주입한 Service를 갖고있는 구조체 변수 입니다.
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: Use Case - Domain
extension MoviesTopRatedDIContainer {
    
    /// 평점순 영화를 불러오는 Use Case입니다.
    /// - Returns: Domain의 `TopRatedMoviesUseCase` protocol을 Return합니다.
    func makeTopRatedMoviesUseCase() -> TopRatedMoviesUseCase {
        DefaultTopRatedMoviesUseCase(moviesTopRatedRepository: makeTopRatedMoviesRepository())
    }
}

// MARK: Repositories - Data
extension MoviesTopRatedDIContainer {
    
    /// 평점순 영화 api와 직접 연결해서, raw data를 관리하는 Repository를 불러오는 메서드입니다.
    ///
    /// - 해당 Repo는 `apiDataTransferService` Service를 주입받고 생성합니다.
    /// - Returns: DIP 원칙을 준수하는 `MoviesTopRatedRepository` protocol를 Return합니다.
    private func makeTopRatedMoviesRepository() -> MoviesTopRatedRepository {
        DefaultMoviesTopRatedRepository(
            dataTransferService: dependencies.apiDataTransferService
        )
    }
    
    /// 영화 Poster Image를 불러오는 Repository를 불러오는 메서드입니다.
    ///
    /// - 해당 Repo는 `imageDataTransferService` 활용이 필요하며, 해당 Service를 주입받고 생성합니다.
    /// - Returns: DIP 원칙을 준수하는 `PosterImagesRepository` Protocol를 Return합니다.
    private func makePosterImagesRepository() -> PosterImagesRepository {
        DefaultPosterImagesRepository(dataTransferService: dependencies.imageDataTransferService)
    }
}

// MARK: Presentation
extension MoviesTopRatedDIContainer {
    
    /// Movie TopRated ViewController를 불러오는 메서드입니다.
    ///
    /// - Parameter actions: flow coordinator에서 활용되는 actions 구조체입니다. 이는 ViewModel을 만드는 메서드에 직접 주입합니다.
    /// - Returns: `MoviesTopRatedViewController`를 Return합니다.
    func makeMoviesTopRatedViewController(actions: MoviesTopRatedViewModelActions) -> MoviesTopRatedViewController {
        MoviesTopRatedViewController.create(
            with: makeMoviesTopRatedViewModel(actions: actions),
            posterImageRepository: makePosterImagesRepository()
        )
    }
    
    /// Movie TopRated ViewModel를 불러오는 메서드입니다.
    /// - Parameter actions: flow coordinator에서 활용되는 actions 구조체입니다.
    /// - Returns: `MoviesTopRatedViewModel`를 Return합니다.
    private func makeMoviesTopRatedViewModel(actions: MoviesTopRatedViewModelActions) -> MoviesTopRatedViewModel {
        DefaultMoviesTopRatedViewModel(
            topRatedMoviesUseCase: makeTopRatedMoviesUseCase(),
            actions: actions
        )
    }
    
    /// Movie TopRated Flow Coordinator를 불러오는 메서드입니다.
    /// - 해당 함수는 `AppFlowCoordinator`에서 실행합니다.
    /// - Parameter navigationController: 해당 화면의 `UINavigationController`를 파라미터로 받습니다.
    /// - Returns: `MoviesTopRatedFlowCoordinator`를 Return합니다.
    func makeMoviesTopRatedFlowCoordinator(navigationController: UINavigationController) -> MoviesTopRatedFlowCoordinator {
        MoviesTopRatedFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
}
