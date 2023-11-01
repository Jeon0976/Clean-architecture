//
//  MoviesSearchFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import UIKit

protocol MoviesSearchFlowCoordinatorDependencies {
    func makeMoviesListViewController(
        actions: MoviesListViewModelActions
    ) -> MoviesListViewController
    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController
    func makeMoviesQueriesSuggestionsListViewController(
        didSelect: @escaping MoviesQueryListViewModelDidSelectAction
    ) -> UIViewController
}

final class MoviesSearchFlowCoordinator: NSObject, UINavigationControllerDelegate, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var tabBarViewController: TabBarDelegate?
    
    var childCoordinators: [Coordinator] = []
    var viewController: UINavigationController

    var viewTitle: String? = nil

    private let dependencies: MoviesSearchFlowCoordinatorDependencies!
    
    private weak var moviesListVC: MoviesListViewController?
    private weak var moviesQueriesSuggestionsVC: UIViewController?
    
    init(
        viewController: UINavigationController,
        dependencies: MoviesSearchFlowCoordinatorDependencies
    ) {
        self.viewController = viewController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = MoviesListViewModelActions(
            showMovieDetails: showMovieDetails,
            showMovieQueriesSuggestions: showMovieQueriesSuggestions,
            closeMovieQueriesSuggestions: closeMovieQueriesSuggestions
        )
        let vc = dependencies.makeMoviesListViewController(actions: actions)
        
        if let title = viewTitle {
            vc.title = title
        }
        
        viewController.delegate = self
        viewController.pushViewController(vc, animated: false)

        
        moviesListVC = vc
    }
    
    private func showMovieDetails(movie: Movie) {
        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        tabBarViewController?.shouldHideTabBar(true)
        
        viewController.pushViewController(vc, animated: true)
    }
    
    private func showMovieQueriesSuggestions(didSelect: @escaping( MovieQuery) -> Void) {
        guard let moviesListViewController = moviesListVC,
              moviesQueriesSuggestionsVC == nil else { return }
              
        let container = moviesListViewController.suggestionsListContainer
        let vc = dependencies.makeMoviesQueriesSuggestionsListViewController(didSelect: didSelect)
        
        moviesListViewController.add(child: vc, container: container)
        moviesQueriesSuggestionsVC = vc

        container.isHidden = false
    }
    
    private func closeMovieQueriesSuggestions() {
        moviesQueriesSuggestionsVC?.remove()
        moviesQueriesSuggestionsVC = nil
        moviesListVC?.suggestionsListContainer.isHidden = true
    }
}

extension MoviesSearchFlowCoordinator {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is MoviesListViewController {
            tabBarViewController?.shouldHideTabBar(false)
        }
    }
}
