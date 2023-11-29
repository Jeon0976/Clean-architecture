//
//  LoginSceneCoordinatorDependecies.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/06.
//

import UIKit

/// Login 화면에 대한 의존성 주입을 관리하는 Container입니다.
final class LoginSceneDIContainer: LoginFlowCoordinatorDependencies {
    
    init() {
        print("Login DI Init \(CFGetRetainCount(self))")
    }
    
    deinit {
        print("Login DI Deinit \(CFGetRetainCount(self))")

    }
    
    /// **ViewController를 생성하는 메서드입니다.**
    /// - 해당 메서드는 `LoginFlowCoordinator` class의 `start` 메서드 내부에서 실행됩니다.
    /// - `LoginFlowCoordinatorDependencies` protocol의 메서드이면서 이는 화면 flow만을 담당하는 flowCoordinator가 flow와 관련없는 메서드를 사용하지 못하도록, Delegate Pattern을 사용했습니다.
    ///
    /// - Parameter actions: FlowCoordinator에서 실행할 actions를 파라미터로 받습니다. 해당 action들은 login flow coordinator에서 화면전환 action입니다.
    /// - Returns:loginViewController를 생성하며, Return 합니다.
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        LoginViewController.create(with: makeLoginViewModel(actions: actions))
    }
    
    /// **ViewModel를 생성하는 메서드입니다.**
    /// - 해당 메서드는 `makeLoginViewController`에서 실행됩니다.
    ///
    /// - Parameter actions: FlowCoordinator에서 실행할 actions를 파라미터로 받습니다. 해당 action들은 login flow coordinator에서 화면전환 action입니다.
    /// - Returns: ViewModel를 생성하며, Return 합니다.
    private func makeLoginViewModel(actions: LoginViewModelActions) -> LoginViewModel {
        DefaultLoginViewModel(actions: actions)
    }
    
    /// **FloowCoordinator를 생성합니다.**
    /// - 해당 메서드는 `AppFlowCoordinator` class의 `showLoginFlow`메서드 내부에서 실행됩니다.
    /// - `LoginFlowCoordinator`의 `init` 함수를 내부에서 실행합니다.
    ///
    /// - Parameter navigationController: AppFlowCoordinator에서 생성한, 최초 NavigationController를 파라미터로 받습니다.
    /// - Returns: LoginFlowCoordinator를 생성하며, Return 합니다.
    func makeLoginFlowCoordinator(navigationController: UINavigationController) -> LoginFlowCoordinator {
        LoginFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

