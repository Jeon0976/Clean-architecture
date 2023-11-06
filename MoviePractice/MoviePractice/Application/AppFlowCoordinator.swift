//
//  AppFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import UIKit

final class AppFlowCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var childCoordinators: [Coordinator] = []
    
    var viewController: UINavigationController
    
    var viewTitle: String? = nil
    
    var tabBarViewController: TabBarDelegate? = nil
    var type: CoordinatorType { .app }
    
    private let appDIContainer: AppDIContainer
    
    private var isLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLogin")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLogin")
        }
    }

    
    init(
        viewController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.viewController = viewController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        if isLogin {
            showTab()
        } else {
            showLoginFlow()
        }
    }
    
    func showLoginFlow() {
        let loginSceneDIContainer = appDIContainer.makeLoginSceneDIContainer()
        let flow = loginSceneDIContainer.makeLoginFlowCoordinator(navigationController: viewController)
        flow.finishDelegate = self
        flow.start()
        childCoordinators.append(flow)
    }
    
    func showTab() {
        let tabBarController = DefaultTabBarController()
        let tabBarFlowCoordinator = TabBarFlowCoordinator(viewController: viewController, tabBarController: tabBarController)
        tabBarFlowCoordinator.finishDelegate = self
        
        let moviesSceneDIContainer = appDIContainer.makeMoviesSceneDIContainer()
        let flow = moviesSceneDIContainer.makeMovieSearchFlowCoordinator(navigationController: UINavigationController())
        
        let moviesSceneDIContainer2 = appDIContainer.makeMoviesSceneDIContainer()
        let flow2 = moviesSceneDIContainer2.makeMovieSearchFlowCoordinator(navigationController: UINavigationController())
        
        let moviesSceneDIContainer3 = appDIContainer.makeMoviesSceneDIContainer()
        let flow3 = moviesSceneDIContainer3.makeMovieSearchFlowCoordinator(navigationController: UINavigationController())
        
        tabBarFlowCoordinator.setupTabs(with: [flow, flow2, flow3])
        
        tabBarFlowCoordinator.start()
        childCoordinators.append(tabBarFlowCoordinator)
    }
}

extension AppFlowCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        print("Tab")
        switch childCoordinator.type {
        case .tab:
            viewController.viewControllers.removeAll()
            showLoginFlow()
        case .login:
            viewController.viewControllers.removeAll()
            showTab()
        default:
            break
        }
    }
}
