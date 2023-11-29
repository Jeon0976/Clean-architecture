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
}

final class MoviesTopRatedFlowCoordinator: Coordinator {
    var type: CoordinatorType { .topRated }
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var tabBarDelegate: TabBarDelegate?

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var viewTitle: String? = nil
    
    private let dependencies: MoviesTopRatedFlowCoordinatorDependencies!
    
    private weak var moviesTopRatedVC: MoviesTopRatedViewController?
    
    init(
        navigationController: UINavigationController,
        dependencies: MoviesTopRatedFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    deinit {
//        moviesTopRatedVC?.moviesCollectionViewController?.remove()
        print("Movies Top Rated Flow Coordinator Deinit")
    }
    
    func start() {
        let actions = MoviesTopRatedViewModelActions()
        let vc = dependencies.makeMoviesTopRatedViewController(actions: actions)
        
        if let title = viewTitle {
            vc.title = title
        }
        
        navigationController.pushViewController(vc, animated: false)
        
        moviesTopRatedVC = vc
    }

    
}
