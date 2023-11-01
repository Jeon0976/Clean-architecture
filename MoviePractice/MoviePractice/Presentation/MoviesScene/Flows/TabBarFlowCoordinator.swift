//
//  TabBarFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/27.
//

import UIKit


final class TabBarFlowCoordinator: NSObject, Coordinator {
    var viewTitle: String? = nil
    
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    weak var tabBarViewController: TabBarDelegate? = nil

    var childCoordinators: [Coordinator] = []
    
    var viewController: UINavigationController
    private var tabBarController: DefaultTabBarController
    
    init(
        viewController: UINavigationController,
        tabBarController: DefaultTabBarController
    ) {
        self.viewController = viewController
        self.tabBarController = tabBarController
    }
    
    func start() {
        tabBarController.selectedIndex = 0
        
    }
    
    func setupTabs(with coordinators: [Coordinator]) {
        viewController.pushViewController(tabBarController, animated: false)
        viewController.setNavigationBarHidden(true, animated: false)
        
        let viewControllers = coordinators.enumerated().map { (index, coordinator) -> UINavigationController in
            
            if let tabPage = TabBarPage(index: index) {
                coordinator.tabBarViewController = tabBarController
                coordinator.viewController.tabBarItem = UITabBarItem(
                    title: tabPage.pageTitleValue(),
                    image: nil, // 여기에 해당 탭의 이미지를 설정하세요.
                    tag: tabPage.pageOrderNumber()
                )
                coordinator.viewTitle = tabPage.pageTitleValue()
            } else {
                assertionFailure("Invalid tab index: \(index)")
            }
            coordinator.start()

            return coordinator.viewController
        }
        
        tabBarController.setViewControllers(viewControllers)
        childCoordinators = coordinators
    }
}
