//
//  Coordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/31.
//

import UIKit


/// <#Description#>
protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var viewTitle: String? { get set }
    var tabBarDelegate: TabBarDelegate? { get set }
    var type: CoordinatorType { get }
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinators.forEach { $0.navigationController.viewControllers.removeAll() }
        childCoordinators.removeAll()

        navigationController.viewControllers.removeAll()

        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

/// <#Description#>
protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

enum CoordinatorType {
    case app, login, tab, search, topRated, myPage
}
