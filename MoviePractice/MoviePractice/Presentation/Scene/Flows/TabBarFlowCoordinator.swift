//
//  TabBarFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/27.
//

import UIKit


/// TabBarController를 관리하는 클래스입니다.
final class TabBarFlowCoordinator: NSObject, Coordinator {
    var type: CoordinatorType { .tab }
    
    var viewTitle: String? = nil
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var tabBarDelegate: TabBarDelegate? = nil

    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    private var tabBarController: DefaultTabBarController!
    
    init(
        navigationController: UINavigationController,
        tabBarController: DefaultTabBarController
    ) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }
    
    func start() {
        tabBarController.selectedIndex = 1
        
        navigationController.pushViewController(tabBarController, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    /// App Flow Coordinator에서 `setupTabs`함수를 호출합니다.
    /// ``` swift
    /// let viewControllers = coordinators.enumerated().map { (index, coordinator) -> UINavigationController in
    ///     if let tabPage = TabBarPage(index: index) {
    ///         coordinator.tabBarDelegate = tabBarController
    ///
    ///         coordinator.viewTitle = NSLocalizedString(tabPage.pageTitleValue(), comment: "")
    ///     } else {
    ///        assertionFailure("Invalid tab index: \(index)")
    ///     }
    ///     coordinator.finishDelegate = self
    ///     coordinator.start()
    ///     childCoordinators.append(coordinator)
    ///
    ///     return coordinator.navigationController
    /// }
    ///
    /// tabBarController.setViewControllers(viewControllers)
    /// ```
    /// - 각 Coordinator의 `tabBarDelegate`를 `self`처리,
    /// - 각 Coordinator의 `finishDelegate`를 `self`처리,
    /// - 각 Coordinator의 `start` 함수를 호출하고, `childCoordinators`에 append하며, `tabBarController`의 `setViewControllers` 메서드를 호출하면서, 파라미터로 각 Coordinator의 `UINavigationController`를 추가합니다.
    /// - Parameter coordinators: coordinator 배열입니다.
    func setupTabs(with coordinators: [Coordinator]) {
        
        let viewControllers = coordinators.enumerated().map { (index, coordinator) -> UINavigationController in
            
            if let tabPage = TabBarPage(index: index) {
                coordinator.tabBarDelegate = tabBarController
               
                coordinator.viewTitle = NSLocalizedString(tabPage.pageTitleValue(), comment: "") 
            } else {
                assertionFailure("Invalid tab index: \(index)")
            }
            coordinator.finishDelegate = self
            coordinator.start()
            childCoordinators.append(coordinator)
            
            
            return coordinator.navigationController
        }
        
        tabBarController.setViewControllers(viewControllers)
    }
}

extension TabBarFlowCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.finish()
    }
}
