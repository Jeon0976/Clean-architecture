//
//  LoginFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/01.
//

import UIKit

/// FlowCoordinator에서 DI Container를 활용하기 위해 직접 DI Container를 주입받기보단, 상위 protocol을 활용해서 DIContainer를 직접 주입받지 않도록 합니다.
/// - 이는 DIP 원칙을 지키면서, DIContainer와 FlowCoordinator의 역할을 명확히 나눌 수 있습니다.
/// - FlowCoordinator에서는 화면 전환에 대한 부분을 담당하기 때문에 Presentation에서 ViewController를 생성하는 부분을 프로토콜의 메서드로 만듭니다.
protocol LoginFlowCoordinatorDependencies {
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController
}

/// Login Scene의 화면 Flow를 담당하는 클레스입니다.
final class LoginFlowCoordinator: Coordinator {
    var type: CoordinatorType { .login }

    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var tabBarDelegate: TabBarDelegate? = nil

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var viewTitle: String? = nil
    
    private let dependencies: LoginFlowCoordinatorDependencies!
    
    private weak var loginVC: LoginViewController?
    
    init(
        navigationController: UINavigationController,
        dependencies: LoginFlowCoordinatorDependencies
    ) {

        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = LoginViewModelActions(showTabBar: showTabBar)
        let vc = dependencies.makeLoginViewController(actions: actions)
        
        if let title = viewTitle {
            vc.title = title
        }
        
        navigationController.pushViewController(vc, animated: false)
        
        loginVC = vc 
    }
    
    /// Login이 완료되었을 시 해당 Coordinator를 종료하기 위한 메서드입니다.
    private func showTabBar() {
        self.finish()
    }
}
