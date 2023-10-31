//
//  AppFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import UIKit

final class AppFlowCoordinator {
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let tabBarController = UITabBarController()
        let tabBarFlowCoordinator = TabBarFlowCoordinator(viewController: navigationController, tabBarController: tabBarController)
        
        let moviesSceneDIContainer = appDIContainer.makeMoviesSceneDIContainer()
        let flow = moviesSceneDIContainer.makeMovieSearchFlowCoordinator(navigationController: UINavigationController())
        
        let moviesSceneDIContainer2 = appDIContainer.makeMoviesSceneDIContainer()
        let flow2 = moviesSceneDIContainer2.makeMovieSearchFlowCoordinator(navigationController: UINavigationController())
        
        let moviesSceneDIContainer3 = appDIContainer.makeMoviesSceneDIContainer()
        let flow3 = moviesSceneDIContainer3.makeMovieSearchFlowCoordinator(navigationController: UINavigationController())
        
        tabBarFlowCoordinator.setupTabs(with: [flow, flow2, flow3])
        
        tabBarFlowCoordinator.start()
    }
    
    func showLoginFlow() {
        
    }
    
    func showMainFlow() {
        
    }
}
