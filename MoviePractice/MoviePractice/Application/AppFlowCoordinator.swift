//
//  AppFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import UIKit

/// 앱의 최초 화면 플로우를 정하는 클래스 입니다.
///
/// 시작할 화면 플로우를 childCoordinator에 저장 후 해당 플로우를 시작합니다.
final class AppFlowCoordinator: Coordinator {
    var type: CoordinatorType { .app }

    var finishDelegate: CoordinatorFinishDelegate? = nil
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    var viewTitle: String? = nil
    
    var tabBarDelegate: TabBarDelegate? = nil
        
    private let appDIContainer: AppDIContainer
    
    /// 로그인 분기 처리입니다.
    ///
    /// 연산 프로퍼티(Computed Property)를 사용하였고, UserDefaults에 Bool 값을 저장 및 불러옵니다.
    private var isLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLogin")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLogin")
        }
    }
    
    /// 최초 Scene Delegate에서 초기화 시킬 init 입니다.
    /// - Parameters:
    ///   - navigationController: 최초 navigationController를 주입합니다.
    ///   - appDIContainer: networkService, 화면 Delegate를 생성하는 App DI Container를 주입합니다.
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    /// 조건에 맞는 flow를 실행하는 메서드 입니다.
    func start() {
        if isLogin {
            showTab()
        } else {
            showLoginFlow()
        }
    }
    
    /// login flow coordinator를 생성하는 메서드 입니다.
    ///
    /// - login DI Conatiner를 생성 후 해당 DI Container에서 LoginFlowCoordinator를 생성해서, 해당 FlowCoordinator를 childCoordinators 배열에 append해줍니다.
    /// - login flow coordinator의 finishDelegate를 CoordinatorFinishDelegate protocol를 채택한 App DI Container으로 주입해서 DIP을 준수합니다.
    ///     - 해당 Protocol은 login flow coordinator가 삭제될 때 알려주기 위함 입니다.
    private func showLoginFlow() {
        let loginSceneDIContainer = appDIContainer.makeLoginSceneDIContainer()
        let flow = loginSceneDIContainer.makeLoginFlowCoordinator(navigationController: navigationController)
        flow.finishDelegate = self
        flow.start()
        childCoordinators.append(flow)
        print(CFGetRetainCount(self))

    }
    
    /// Tabbar Flow Coordinator를 생성하는 메서드 입니다.
    ///
    /// - TabBar Flow Coordinator와 각 화면에 대한 DI Container, FlowCoordinator를 생성 합니다.
    /// - 이때 각 화면 flow coordinator는 tabBarFlowCoordinator `setupTabs`메서드를 활용해서 주입해주고, tabBarFlowCoordinator를 childCoordinators에 append 해줍니다.
    private func showTab() {
        let tabBarController = DefaultTabBarController()
        let tabBarFlowCoordinator = TabBarFlowCoordinator(
            navigationController: navigationController,
            tabBarController: tabBarController
        )
                
        let sceneDIContainer = appDIContainer.makeMoviesSearchDIContainer()
        let sceneFlow = sceneDIContainer.makeMovieSearchFlowCoordinator(
            navigationController: UINavigationController()
        )
        
        let topRatedDIContainer = appDIContainer.makeMoviesTopRatedDIContainer()
        let topRated = topRatedDIContainer.makeMoviesTopRatedFlowCoordinator(
            navigationController: UINavigationController()
        )
        
        let myPageDIContainer = appDIContainer.makeMyPageDIContainer()
        let myPageFlow = myPageDIContainer.makeMyPageFlowCoordinator(
            navigationController: UINavigationController()
        )
        
        tabBarFlowCoordinator.setupTabs(with: [
            sceneFlow,
            topRated,
            myPageFlow
        ])
        
        tabBarFlowCoordinator.finishDelegate = self
        
        tabBarFlowCoordinator.start()
        
        childCoordinators.append(tabBarFlowCoordinator)
    }
}


extension AppFlowCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        navigationController.viewControllers.removeAll()

        switch childCoordinator.type {
        case .tab:
            isLogin = false
            showLoginFlow()
        case .login:
            isLogin = true
            showTab()
        default:
            break
        }
    }
}
