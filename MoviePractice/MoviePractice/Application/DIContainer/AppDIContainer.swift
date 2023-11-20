//
//  AppDIContainer.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

/// **DI Container (Dependency Injection Container)**
/// - Dependecy Injection (의존성 주입)을 구현하기 위해 사용되는 객체이다.
/// 의존성 주입은 객체가 필요로 하는 의존성을 외부에서 주입받도록 만드는 패턴으로, 코드의 결합도를 낮추고, 테스트 용이성 및 확장성을 향상시키는데 도움을 준다.
/// 1. 객체의 생명주기 관리
///     - DIContainer는 객체의 생성, 설정, 파괴를 관리한다.
///     - 객체 생성과 관리에 대한 걱정 없이 비즈시느 로직에 집중할 수 있다.
/// 2. 의존성 해결
///     - 객체가 필요로 하는 의존성을 자동으로 해결하고 주입한다.
/// 3. 구성 관리
///     - 다양한 환경에서 다른 설정 값을 가질 수 있도록 도와준다.
/// 4. 객체 재사용
///     - 한 번 생성된 객체를 재사용할 수 있도록 관리함으로써 메모리 사용 효율과 성능을 향상시킬 수 있다. 
final class AppDIContainer {
    lazy var appConfiguration = AppConfiguration()
    
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!, queryParameters: [
            "api_key": appConfiguration.apiKey,
            "language": NSLocale.preferredLanguages.first ?? "ko-KR"
        ])
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    lazy var imageDataTranserService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.imageBaseURL)!)
        
        let imagesDataNetwork = DefaultNetworkService(config: config)
        
        return DefaultDataTransferService(with: imagesDataNetwork)
    }()
    
    // MARK: DIContainers of scenes
    func makeLoginSceneDIContainer() -> LoginSceneDIContainer {
        return LoginSceneDIContainer()
    }
    
    func makeMoviesSceneDIContainer() -> MoviesSearchDIContainer {
        let dependecies = MoviesSearchDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            imageDataTransferService: imageDataTranserService
        )
        
        return MoviesSearchDIContainer(dependencies: dependecies)
    }
    
    func makeMoviesTopRatedDIContainer() -> MoviesTopRatedDIContainer {
        let dependecies = MoviesTopRatedDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            imageDataTransferService: imageDataTranserService
        )
        
        return MoviesTopRatedDIContainer(dependencies: dependecies)
    }
    
    func makeMyPageDIContainer() -> MyPageDIContainer {
        return MyPageDIContainer()
    }
}
