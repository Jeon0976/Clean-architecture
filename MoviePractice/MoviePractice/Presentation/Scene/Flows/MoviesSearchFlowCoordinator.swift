//
//  MoviesSearchFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import UIKit

/// FlowCoordinator에서 DI Container를 활용하기 위해 직접 DI Container를 주입받기보단, 상위 protocol을 활용해서 DIContainer를 직접 주입받지 않도록 합니다.
/// - 이는 DIP 원칙을 지키면서, DIContainer와 FlowCoordinator의 역할을 명확히 나눌 수 있습니다.
/// - FlowCoordinator에서는 화면 전환에 대한 부분을 담당하기 때문에 Presentation에서 ViewController를 생성하는 부분을 프로토콜의 메서드로 만듭니다.
/// - `makeMoviesListViewController`:  `MoviesSearchViewController`를 생성하는 메서드입니다.
/// - `makeMoviesDetailsViewController`: `MoviesDetailsViewController`를 생성하는 메서드입니다.
/// - `makeMoviesQuriesSuggestionsListViewController`: `MoviesQueriesTableViewController`를 생성하는 메서드입니다.
protocol MoviesSearchFlowCoordinatorDependencies {
    func makeMoviesSearchViewController(
        actions: MoviesSearchViewModelActions
    ) -> MoviesSearchViewController
    func makeMoviesDetailsViewController(movie: MovieWhenSearch) -> MovieDetailsViewController
    func makeMoviesQueriesSuggestionsListViewController(
        didSelect: @escaping MoviesQueryListViewModelDidSelectAction
    ) -> MoviesQueriesTableViewController
}

/// MoviesSearch 화면의 flow를 담당하는 클래스입니다.
final class MoviesSearchFlowCoordinator: NSObject, Coordinator {
    var type: CoordinatorType { .search }
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var tabBarDelegate: TabBarDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    var viewTitle: String? = nil

    private let dependencies: MoviesSearchFlowCoordinatorDependencies!
        
    private weak var moviesSearchVC: MoviesSearchViewController?
    /// `MoviesSearchViewController`에서 `addChild`, `removeParent`과 같이 하나의 ViewController안에 새로운 ViewController를 추가하는 로직이 있을 때 `flowCoordinator`에서 전체적인 관리를 위해 약한 참조로 변수를 만듭니다.
    private weak var moviesQueriesSuggestionsVC: MoviesQueriesTableViewController?
    
    init(
        navigationController: UINavigationController,
        dependencies: MoviesSearchFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = MoviesSearchViewModelActions(
            showMovieDetails: showMovieDetails,
            showMovieQueriesSuggestions: showMovieQueriesSuggestions,
            closeMovieQueriesSuggestions: closeMovieQueriesSuggestions
        )
        let vc = dependencies.makeMoviesSearchViewController(actions: actions)
        
        if let title = viewTitle {
            vc.title = title
        }
        
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: false)
        
        moviesSearchVC = vc
    }
    
    /// Details View Controller를 생성하며, navigationController에 push하는 메서드입니다.
    ///
    /// - Parameter movie: `MoviesDetailViewModel`에서 필요로하는 `Entity` 입니다.
    private func showMovieDetails(movie: MovieWhenSearch) {
        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        tabBarDelegate?.shouldHideTabBar(true)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    /// Moive Queries Suggestions ViewController를 생성하며, `MoviesSearchViewController`에 직접 생성하는 메서드입니다.
    /// - Parameter didSelect: typealias `MoviesQueryListViewModelDidSelectAction`를 파라미터로 받으며, 이는 `DefaultMoviesSearchViewModel` 클래스의 `update(movieQuery: MovieQuery)` 메서드 입니다.
    /// - QueriesSuggestionsViewController를 SearchViewController에 addChild해줍니다.
    private func showMovieQueriesSuggestions(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) {
        guard let moviesSearchViewController = moviesSearchVC,
              moviesQueriesSuggestionsVC == nil else { return }
              
        let container = moviesSearchViewController.suggestionsListContainer
        let vc = dependencies.makeMoviesQueriesSuggestionsListViewController(didSelect: didSelect)
        
        moviesSearchViewController.add(child: vc, container: container)
        moviesQueriesSuggestionsVC = vc

        container.isHidden = false
    }
    
    /// Moive Queries Suggestions ViewController를 삭제합니다.
    /// - AddChild된것을 삭제해주며, 참조되어있는것을 nil처리 해줘 해당 QueriesSuggestionsViewController를 삭제해줍니다.
    private func closeMovieQueriesSuggestions() {
        moviesQueriesSuggestionsVC?.remove()
        moviesQueriesSuggestionsVC = nil
        moviesSearchVC?.suggestionsListContainer.isHidden = true
    }
}

extension MoviesSearchFlowCoordinator: UINavigationControllerDelegate {
    /// 숨겨진 tabBar를 다시 보여주기 위해 활용되는 메서드입니다.
    /// - 이는 viewController가 `MoviesSearchViewController`일 시 tabBar hidden처리를 false해줍니다.
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is MoviesSearchViewController {
            tabBarDelegate?.shouldHideTabBar(false)
        }
    }
}
