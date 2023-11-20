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
        
        let sceneDIContainer = appDIContainer.makeMoviesSceneDIContainer()
        let sceneFlow = sceneDIContainer.makeMovieSearchFlowCoordinator(navigationController: UINavigationController())
        
        let topRatedDIContainer = appDIContainer.makeMoviesTopRatedDIContainer()
        let topRated = topRatedDIContainer.makeMoviesTopRatedFlowCoordinator(navigationController: UINavigationController())
        
        let myPageDIContainer = appDIContainer.makeMyPageDIContainer()
        let myPageFlow = myPageDIContainer.makeMyPageFlowCoordinator(navigationController: UINavigationController())
        
        tabBarFlowCoordinator.setupTabs(with: [
            sceneFlow,
            topRated,
            myPageFlow]
        )
        
        tabBarFlowCoordinator.start()
        childCoordinators.append(tabBarFlowCoordinator)
    }
}

extension AppFlowCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {

        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        switch childCoordinator.type {
        case .tab:
            isLogin = false
            viewController.viewControllers.removeAll()
            showLoginFlow()
        case .login:
            isLogin = true
            viewController.viewControllers.removeAll()
            showTab()
        default:
            break
        }
    }
}
