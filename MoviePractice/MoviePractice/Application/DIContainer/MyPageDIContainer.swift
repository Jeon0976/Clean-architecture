//
//  MyPageDIContainer.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/19.
//

import UIKit

final class MyPageDIContainer: MyPageFlowCoordinatorDependencies {
    
    func makeMyPageViewController(actions: MyPageModelActions) -> MyPageViewController {
        MyPageViewController.create(with: makeMyPageViewController(actions: actions))
    }
    
    private func makeMyPageViewController(actions: MyPageModelActions) -> MyPageViewModel {
        DefaultMyPageViewModel(actions: actions)
    }
    
    
    func makeMyPageFlowCoordinator(navigationController: UINavigationController) -> MyPageFlowCoordinator {
        MyPageFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
