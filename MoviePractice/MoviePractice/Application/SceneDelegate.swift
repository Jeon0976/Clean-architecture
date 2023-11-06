//
//  SceneDelegate.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/08/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        
        window?.rootViewController = navigationController
        
        appFlowCoordinator = AppFlowCoordinator(
            viewController: navigationController,
            appDIContainer: appDIContainer
        )

        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
    }    
}

