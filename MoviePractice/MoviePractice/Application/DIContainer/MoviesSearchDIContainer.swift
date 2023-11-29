//
//  MoviesSceneDIContainer.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import UIKit
import SwiftUI

/// Movies Search 화면에 대한 의존성 주입을 관리하는 Container입니다.
final class MoviesSearchDIContainer: MoviesSearchFlowCoordinatorDependencies {
    
    // MARK: Dependencies
    
    /// MovieSearch 화면에서 필요한 Service를 주입 구조체로 갖고 해당 구조체는 Movie Search 화면에서 필요한 `ApiDataTransferService`, `ImageDataTransferService`를 갖고있습니다.
    /// - 해당 `Dependencies`는 `AppDIContainer`에서  `makeMoviesSearchDIContainer()` 메서드를 실행할 때 주입받습니다.
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    /// AppDIContainer에서 주입한 Service를 갖고있는 구조체 변수 입니다.
    private let dependencies: Dependencies
    
    // MARK: Persistent Storage
    
    /// Local DB에 저장된 Movies queries 저장소를 불러오는 protocol service 입니다.
    ///
    /// - 해당 service는 MoviesSearch에서만 수행하기 때문에 App DI Container에서 생성하지 않고, MoviesSearhDIContainer에서 직접 생성합니다.
    lazy var moviesQueriesStorage: MoviesQueriesStorage = CoreDataMoviesQueriesStorage(maxStorageLimit: 15)
    
    /// Local DB에 저장된 Movies Response Cahce를 활용하기 위한 Service입니다.
    ///
    /// - 해당 service는 MoviesSearch에서만 수행하기 때문에 App DI Container에서 생성하지 않고, MoviesSearhDIContainer에서 직접 생성합니다.
    lazy var moviesResponseCache: MoviesResponseStorage = CoreDataMoviesResponseStorage()
        
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: Use Cases - Domain
    
    /// 영화를 검색하는 Use Case입니다.
    ///
    /// - Returns: Domain의 Search Movies Use Case를 Return 합니다.
    func makeSearchMoviesUseCase() -> SearchMoviesUseCase {
        DefaultSearchMoviesUseCase(
            moviesRepository: makeMoviesRepository(),
            moviesQueriesRepository: makeMoviesQueriesRepository()
        )
    }
    
    /// 영화의 검색 결과를 불러오는 Use Case입니다.
    ///
    /// - 해당 Use Case는 `DefaultMoviesQueryListViewModel`에서 구체화 됩니다.
    /// - Parameters:
    ///   - requestValue: Queries의 개수를 나타냅니다.
    ///   - completion: Queries의 개수를 받고나서 나온 결과를 받습니다.
    /// - Returns: `FetchRecentMovieQueriesUseCase` 클래스를 Return합니다.
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

// MARK: Repositories - Data
extension MoviesSearchDIContainer {
    
    /// 영화를 검색하는 Repository를 불러오는 메서드입니다.
    ///
    /// - 해당 Repo는 `apiDataTransferService`와 `cache Local DB` 활용이 필요하며, 해당 Service들을 주입받고 생성합니다.
    /// - Returns: DIP 원칙을 준수하는 `MoviesSearchRepository` Protocol를 Return합니다.
    func makeMoviesRepository() -> MoviesSearchRepository {
        DefaultMoviesSearchRepository(
            dataTransferService: dependencies.apiDataTransferService,
            cache: moviesResponseCache
        )
    }
    
    /// 영화의 최근 검색 결과를 저장한 데이터를 보여주는 Repository를 불러오는 메서드입니다.
    ///
    /// - 해당 Repo는 `moviesQueriesStorage` 활용이 필요하며, 해당 Service를 주입받고 생성합니다.
    /// - Returns: DIP 원칙을 준수하는 `MoviesQueriesRepository` Protocol를 Return합니다.
    func makeMoviesQueriesRepository() -> MoviesQueriesRepository {
        DefaultMoviesQueriesRepository(
            moviesQueriesPersistentStorage: moviesQueriesStorage
        )
    }
    
    /// 영화 Poster Image를 불러오는 Repository를 불러오는 메서드입니다.
    ///
    /// - 해당 Repo는 `imageDataTransferService` 활용이 필요하며, 해당 Service를 주입받고 생성합니다.
    /// - Returns: DIP 원칙을 준수하는 `PosterImagesRepository` Protocol를 Return합니다.||
    func makePosterImagesRepository() -> PosterImagesRepository {
        DefaultPosterImagesRepository(
            dataTransferService: dependencies.imageDataTransferService
        )
    }
}

extension MoviesSearchDIContainer {
    // MARK: Movie List - Presentation
    
    /// Movie Search Scene View Controller를 불러오는 메서드입니다.
    ///
    /// - Parameter actions: flow coordinator에서 활용되는 actions 구조체입니다. 이는 ViewModel을 만드는 메서드에 직접 주입합니다.
    /// - Returns: `MoviesListViewController`를 Return 합니다.
    func makeMoviesListViewController(
        actions: MoviesListViewModelActions) -> MoviesListViewController {
        MoviesListViewController.create(
            with: makeMoviesListViewModel(actions: actions),
            posterImagesRepostiory: makePosterImagesRepository()
        )
    }
    
    /// Movie Search View Model를 불러오는 메서드입니다.
    /// - Parameter actions: flow coordinator에서 활용되는 actions 구조체입니다.
    /// - Returns: `MoviesListViewModel` Return합니다.
    private func makeMoviesListViewModel(actions: MoviesListViewModelActions) -> MoviesListViewModel {
        
        DefaultMoviesListViewModel(
            searchMoviesUseCase: makeSearchMoviesUseCase(),
            actions: actions
        )
    }
    
    // MARK: Movie Details - Presentation
    
    /// Movie Detail View Controller를 불러오는 메서드입니다.
    /// - Parameter movie: 클릭된 데이터, `MovieWhenSearch` Domain의 Entity를 파라미터로 받습니다. 해당 구조체는 Detail View Model에 주입합니다.
    /// - Returns: `MovieDetailsViewController`를 Return합니다.
    func makeMoviesDetailsViewController(movie: MovieWhenSearch) -> MovieDetailsViewController {
        MovieDetailsViewController.create(with: makeMoviesDetailViewModel(movie: movie))
    }
    
    /// Movie Detail View Model를 불러오는 메서드입니다.
    ///
    /// - Parameter movie: 클릭된 데이터, `MovieWhenSearch` Domain의 Entity를 파라미터로 받습니다.
    /// - Returns: `MovieDetailsViewModel`를 Return합니다.
    private func makeMoviesDetailViewModel(movie: MovieWhenSearch) -> MovieDetailsViewModel {
        DefaultMovieDetailsViewModel(
            movie: movie,
            posterImagesRepository: makePosterImagesRepository()
        )
    }
    
    
    // MARK: Movies Queries Suggestions List - Presentation
    
    /// Movie Query List View Controller를 불러오는 메서드입니다.
    /// - Parameter didSelect: typealias `MoviesQueryListViewModelDidSelectAction`를 파라미터로 받습니다. 해당 액션은 (`MovieQuery`) -> Void 클로저 함수 입니다. 해당 클로저는 `DefaultMoviesListViewModel`의 `update` 메서드 입니다.
    /// - Returns: `MoviesQueriesTableViewController`를 Return합니다.
    func makeMoviesQueriesSuggestionsListViewController(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> MoviesQueriesTableViewController {
        MoviesQueriesTableViewController.create(with: makeMoviesQueryListViewModel(didSelect: didSelect))
    }
    
    /// Movie Query List View Model를 불러오는 메서드입니다.
    ///
    /// - Parameter didSelect: typealias `MoviesQueryListViewModelDidSelectAction`를 파라미터로 받습니다. 해당 액션은 (`MovieQuery`) -> Void 클로저 함수 입니다. 해당 클로저는 `DefaultMoviesListViewModel`의 `update` 메서드 입니다.
    /// - Returns: `MoviesQueryListViewModel`를 Return합니다.
    func makeMoviesQueryListViewModel(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> MoviesQueryListViewModel {
        DefaultMoviesQueryListViewModel(
            numberOfQueriesToShow: 10,
            fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase,
            didSelect: didSelect
        )
    }
    
    // MARK: Flow Coordinators - Presentation
    
    /// MoviesSearchFlowCoordinator를 불러오는 메서드입니다.
    ///
    /// - 해당 함수는 `AppFlowCoordinator`에서 실행합니다.
    /// - Parameter navigationController: 해당 화면의 `UINavigationController`를 파라미터로 받습니다.
    /// - Returns: `MoviesSearchFlowCoordinator`를 Return합니다.
    func makeMovieSearchFlowCoordinator(navigationController: UINavigationController) -> MoviesSearchFlowCoordinator {
        MoviesSearchFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
