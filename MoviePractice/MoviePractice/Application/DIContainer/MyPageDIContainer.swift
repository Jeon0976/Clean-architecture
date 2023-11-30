//
//  MyPageDIContainer.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/19.
//

import UIKit

/// Mypage 화면에 대한 의존성 주입을 관리하는 Container입니다.
final class MyPageDIContainer: MyPageFlowCoordinatorDependencies {
    
    // MARK: Presentation
    
    ///  MyPage ViewController를 불러오는 메서드입니다.
    ///
    /// - Parameter actions: flow coordinator에서 활용되는 actions 구조체입니다. 이는 ViewModel을 만드는 메서드에 직접 주입합니다.
    /// - Returns:  `MyPageViewController`를 Return합니다.
    func makeMyPageViewController(actions: MyPageModelActions) -> MyPageViewController {
        MyPageViewController.create(with: makeMyPageViewController(actions: actions))
    }
    
    /// MyPage ViewModel를 불러오는 메서드입니다.
    /// - Parameter actions: flow coordinator에서 활용되는 actions 구조체입니다.
    /// - Returns: `MyPageViewModel`를 Return합니다.
    private func makeMyPageViewController(actions: MyPageModelActions) -> MyPageViewModel {
        DefaultMyPageViewModel(actions: actions)
    }
    
    /// MypageFlowCoordinator를 불러오는 메서드입니다.
    /// - 해당 함수는 `AppFlowCoordinator`에서 실행합니다.
    /// - Parameter navigationController: 해당 화면의 `UINavigationController`를 파라미터로 받습니다.
    /// - Returns: `MyPageFlowCoordinator`를 Return합니다.
    func makeMyPageFlowCoordinator(navigationController: UINavigationController) -> MyPageFlowCoordinator {
        MyPageFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
