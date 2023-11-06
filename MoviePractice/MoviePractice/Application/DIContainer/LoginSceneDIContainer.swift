//
//  LoginSceneCoordinatorDependecies.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/06.
//

import UIKit

final class LoginSceneDIContainer: LoginFlowCoordinatorDependencies {
    
    init() {
        print("Init")
    }
    
    deinit {
        print("Deinit")
    }
    
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        LoginViewController.create(with: makeLoginViewModel(actions: actions))
    }
    
    private func makeLoginViewModel(actions: LoginViewModelActions) -> LoginViewModel {
        DefaultLoginViewModel(actions: actions)
    }
    
    func makeLoginFlowCoordinator(navigationController: UINavigationController) -> LoginFlowCoordinator {
        LoginFlowCoordinator(
            viewController: navigationController,
            dependencies: self
        )
    }
}

