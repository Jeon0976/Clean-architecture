//
//  TabBarFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/27.
//

import UIKit


final class TabBarFlowCoordinator: NSObject, Coordinator {
    var type: CoordinatorType { .tab }
    
    var viewTitle: String? = nil
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var tabBarViewController: TabBarDelegate? = nil

    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    private var tabBarController: DefaultTabBarController
    
    init(
        navigationController: UINavigationController,
        tabBarController: DefaultTabBarController
    ) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }
    
    func start() {
        tabBarController.selectedIndex = 1
    }
    
    func setupTabs(with coordinators: [Coordinator]) {
        navigationController.pushViewController(tabBarController, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        let viewControllers = coordinators.enumerated().map { (index, coordinator) -> UINavigationController in
            
            if let tabPage = TabBarPage(index: index) {
                coordinator.tabBarViewController = tabBarController
               
                coordinator.viewTitle = NSLocalizedString(tabPage.pageTitleValue(), comment: "") 
            } else {
                assertionFailure("Invalid tab index: \(index)")
            }
            coordinator.finishDelegate = self
            coordinator.start()

            return coordinator.navigationController
        }
        
        tabBarController.setViewControllers(viewControllers)
        childCoordinators = coordinators
    }
}

extension TabBarFlowCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators.forEach { $0.navigationController.viewControllers.removeAll() }
        
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        self.finish()
    }
}
