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
        let moviesSceneDIContainer = appDIContainer.makeMoviesSceneDIContainer()
        let flow = moviesSceneDIContainer.makeMovieSearchFlowCoordinator(navigationController: navigationController)
        
        flow.start()
    }
}
