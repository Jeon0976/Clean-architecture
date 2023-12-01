//
//  Coordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/31.
//

import UIKit


/// Coordinator Protocol입니다. 모든 Coordinator는 해당 protocol을 채택합니다.
protocol Coordinator: AnyObject {
    /// Coordinator type입니다.
    var type: CoordinatorType { get }

    /// 상위 Coordinator에게 자신의 종료를 알리기 위한 Delegate 입니다.
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    /// `TabBarDelegate` 프로토콜을 구현하는 객체에게 탭 바의 표시 여부를 제어하라는 지시를 전달하는 역할을 합니다.
    var tabBarDelegate: TabBarDelegate? { get set }

    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    var viewTitle: String? { get set }
    
    func start()
    func finish()
}

extension Coordinator {
    /// 종료 메서드 입니다.
    /// 1. 해당 코디네이터에 있는 자식들의 `UINavigationController`의 `ViewController`들을 전부 삭제하고
    /// 2. 자식 코디네이터를 전부 삭제합니다.
    /// 3. 해당 코디네이터 `UINavigationController`에 push되어있는 `ViewController`들을 전부 삭제합니다.
    /// 4. 그 후 상위 Coordinator에게 자신이 종료되었음을 알립니다.
    func finish() {
        childCoordinators.forEach { $0.navigationController.viewControllers.removeAll() }
        childCoordinators.removeAll()

        navigationController.viewControllers.removeAll()

        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

/// `childCoordinator`가 삭제되었음을 해당 프로토콜을 채택함으로써 확인합니다.
protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

/// Coordinator type입니다.
enum CoordinatorType {
    case app, login, tab, search, topRated, myPage
}
