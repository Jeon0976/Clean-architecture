//
//  TabBarFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/27.
//

import UIKit


final class TabBarFlowCoordinator: NSObject, Coordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    var viewController: UINavigationController
    private var tabBarController: UITabBarController
    
    init(
        viewController: UINavigationController,
        tabBarController: UITabBarController
    ) {
        self.viewController = viewController
        self.tabBarController = tabBarController
    }
    
    func start() {
        tabBarController.selectedIndex = 0
        
        tabBarController.delegate = self
    }
    
    func setupTabs(with coordinators: [Coordinator]) {
        viewController.pushViewController(tabBarController, animated: false)
        viewController.setNavigationBarHidden(true, animated: false)
        
        let viewControllers = coordinators.enumerated().map { (index, coordinator) -> UINavigationController in
            coordinator.start()
            
            if let tabPage = TabBarPage(index: index) {
                coordinator.viewController.tabBarItem = UITabBarItem(
                    title: tabPage.pageTitleValue(),
                    image: nil, // 여기에 해당 탭의 이미지를 설정하세요.
                    tag: tabPage.pageOrderNumber()
                )
            } else {
                assertionFailure("Invalid tab index: \(index)")
            }
            
            return coordinator.viewController
        }
        
        tabBarController.setViewControllers(viewControllers, animated: true)
        childCoordinators = coordinators
    }
}

extension TabBarFlowCoordinator: UITabBarControllerDelegate {
    
}
