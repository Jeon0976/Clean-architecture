//
//  MoviesPopularFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/01.
//

import UIKit

protocol MoviesPopularFlowCoordinatorDependencies {
    
}

final class MoviesPopularFlowCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var tabBarViewController: TabBarDelegate?

    var childCoordinators: [Coordinator] = []
    var viewController: UINavigationController
    
    var viewTitle: String? = nil
    
    private let dependencies: MoviesPopularFlowCoordinatorDependencies!
    
    
    init(
        viewController: UINavigationController,
        dependencies: MoviesPopularFlowCoordinatorDependencies
    ) {
        self.viewController = viewController
        self.dependencies = dependencies
    }
    
    func start() {
        
    }
    
    
}
