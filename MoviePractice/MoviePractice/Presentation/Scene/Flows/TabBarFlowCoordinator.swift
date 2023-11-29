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
    
    deinit {
        print("TabBar Flow Deinit")
    }
    
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
