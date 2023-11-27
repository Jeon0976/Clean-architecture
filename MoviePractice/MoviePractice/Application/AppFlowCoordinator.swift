//
//  AppFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import UIKit

/// 앱의 최초 화면 플로우를 정하는 클래스 입니다.
final class AppFlowCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
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
    
    /// <#Description#>
    /// - Parameters:
    ///   - navigationController: <#navigationController description#>
    ///   - appDIContainer: <#appDIContainer description#>
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
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
        let flow = loginSceneDIContainer.makeLoginFlowCoordinator(navigationController: navigationController)
        flow.finishDelegate = self
        flow.start()
        childCoordinators.append(flow)
    }
    
    func showTab() {
        let tabBarController = DefaultTabBarController()
        let tabBarFlowCoordinator = TabBarFlowCoordinator(navigationController: navigationController, tabBarController: tabBarController)
        tabBarFlowCoordinator.finishDelegate = self
        
        let sceneDIContainer = appDIContainer.makeMoviesSearchDIContainer()
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
            navigationController.viewControllers.removeAll()
            showLoginFlow()
        case .login:
            isLogin = true
            navigationController.viewControllers.removeAll()
            showTab()
        default:
            break
        }
    }
}
