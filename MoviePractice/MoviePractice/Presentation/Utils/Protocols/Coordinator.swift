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
    var viewController: UINavigationController { get set }
    var viewTitle: String? { get set }
    var tabBarViewController: TabBarDelegate? { get set }
    var type: CoordinatorType { get }
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

/// <#Description#>
protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

enum CoordinatorType {
    case app, login, tab, search, topRated, nowPlaying
}
