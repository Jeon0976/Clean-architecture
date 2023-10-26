//
//  MoviesSearchFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import UIKit

protocol MoviesSearchFlowCoordinatorDependencies {
    func makeMoviesListViewController(actions: MoviesListViewModelActions) -> MoviesListViewController
//    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController
    func makeMoviesQueriesSuggestionsListViewController(
        didSelect: @escaping MoviesQueryListViewModelDidSelectAction
    ) -> UIViewController
}

final class MoviesSearchFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: MoviesSearchFlowCoordinatorDependencies
    
    private weak var moviesListVC: MoviesListViewController?
    private weak var moviesQueriesSuggestionsVC: UIViewController?
    
    init(
        navigationController: UINavigationController,
        dependencies: MoviesSearchFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = MoviesListViewModelActions(
            showMovieDetails: showMovieDetails,
            showMovieQueriesSuggestions: showMovieQueriesSuggestions,
            closeMovieQueriesSuggestions: closeMovieQueriesSuggestions
        )
        
        let vc = dependencies.makeMoviesListViewController(actions: actions)
        
        navigationController?.pushViewController(vc, animated: false)
        
        moviesListVC = vc
    }
    
    private func showMovieDetails(movie: Movie) {
        
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
