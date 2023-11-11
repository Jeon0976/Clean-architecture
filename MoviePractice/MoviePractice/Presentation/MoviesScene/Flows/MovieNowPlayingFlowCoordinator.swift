//
//  MyPageFlowCoordinator.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/01.
//

import UIKit

protocol MovieNowPlayingFlowCoordinatorDependencies {
    
}

final class MovieNowPlayingFlowCoordinator: NSObject, Coordinator {
    var type: CoordinatorType { .nowPlaying }
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var tabBarViewController: TabBarDelegate?
    
    var childCoordinators: [Coordinator] = []
    var viewController: UINavigationController
    
    var viewTitle: String? = nil
    
    private let dependices: MovieNowPlayingFlowCoordinatorDependencies
    
    init(
        viewController: UINavigationController,
        dependices: MovieNowPlayingFlowCoordinatorDependencies
    ) {
        self.viewController = viewController
        self.dependices = dependices
    }
    
    func start() {
        
    }
    
}
