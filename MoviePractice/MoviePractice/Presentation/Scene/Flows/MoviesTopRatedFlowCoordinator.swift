//
//  MoviesPopularFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/01.
//

import UIKit

/// FlowCoordinator에서 DI Container를 활용하기 위해 직접 DI Container를 주입받기보단, 상위 protocol을 활용해서 DIContainer를 직접 주입받지 않도록 합니다.
/// - 이는 DIP 원칙을 지키면서, DIContainer와 FlowCoordinator의 역할을 명확히 나눌 수 있습니다.
/// - FlowCoordinator에서는 화면 전환에 대한 부분을 담당하기 때문에 Presentation에서 ViewController를 생성하는 부분을 프로토콜의 메서드로 만듭니다.
/// - `makeMoviesTopRatedViewController`:  `MoviesTopRatedViewController`를 생성하는 메서드입니다.
protocol MoviesTopRatedFlowCoordinatorDependencies {
    func makeMoviesTopRatedViewController(
        actions: MoviesTopRatedViewModelActions
    ) -> MoviesTopRatedViewController
}

/// Movies TopRated 화면의 flow를 담당하는 클래스입니다.
final class MoviesTopRatedFlowCoordinator: Coordinator {
    var type: CoordinatorType { .topRated }
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var tabBarDelegate: TabBarDelegate?

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var viewTitle: String? = nil
    
    private let dependencies: MoviesTopRatedFlowCoordinatorDependencies!
    
    private weak var moviesTopRatedVC: MoviesTopRatedViewController?
    
    init(
        navigationController: UINavigationController,
        dependencies: MoviesTopRatedFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = MoviesTopRatedViewModelActions()
        let vc = dependencies.makeMoviesTopRatedViewController(actions: actions)
        
        if let title = viewTitle {
            vc.title = title
        }
        
        navigationController.pushViewController(vc, animated: false)
        
        moviesTopRatedVC = vc
    }
}
