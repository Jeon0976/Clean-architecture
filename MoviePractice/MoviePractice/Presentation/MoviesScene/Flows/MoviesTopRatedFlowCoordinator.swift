//
//  MoviesPopularFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/01.
//

import UIKit

protocol MoviesTopRatedFlowCoordinatorDependencies {
    func makeMoviesTopRatedViewController(
        actions: MoviesTopRatedViewModelActions
    ) -> MoviesTopRatedViewController
//    func makeMoviesDetailsViewController(movie: MovieWhenTopRated) -> UIViewController
}

final class MoviesTopRatedFlowCoordinator: Coordinator {
    var type: CoordinatorType { .topRated }
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var tabBarViewController: TabBarDelegate?

    var childCoordinators: [Coordinator] = []
    var viewController: UINavigationController
    
    var viewTitle: String? = nil
    
    private let dependencies: MoviesTopRatedFlowCoordinatorDependencies!
    
    private weak var moviesTopRatedVC: MoviesTopRatedViewController?
    
    init(
        viewController: UINavigationController,
        dependencies: MoviesTopRatedFlowCoordinatorDependencies
    ) {
        self.viewController = viewController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = MoviesTopRatedViewModelActions()
        let vc = dependencies.makeMoviesTopRatedViewController(actions: actions)
        
        if let title = viewTitle {
            vc.title = title
        }
        
        viewController.pushViewController(vc, animated: false)
        
        moviesTopRatedVC = vc
    }

    
}
