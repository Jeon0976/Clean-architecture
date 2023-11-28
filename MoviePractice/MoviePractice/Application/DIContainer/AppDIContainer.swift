//
//  AppDIContainer.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation


/// 앱의 전체적인 의존성 주입을 관리하는 Container입니다.
///
/// - `DI Container`의 주요 특징은 각 상황에서 필요한 class를 해당 class의 init, static create 메서드를 통해 생성 후 해당 class를 return합니다.
/// - Data 단계에 의존성을 주입하기 위한, **NetworkService**(UrlSession, Moya, Alamofire)..를 생성합니다.
/// - 각 화면에 대한 **DIContainer**들을 생성합니다.
final class AppDIContainer {
    
    /// API Key, API URL 정보 변수입니다.
    lazy var appConfiguration = AppConfiguration()
    
    /// API NetworkService 변수 입니다.
    ///
    /// - 해당 변수는 전반적인 api 네트워크를 담당합니다.
    /// - Infrastructure / Network -> *DataTransferService protocol*를 채택한 Network Service class(DefaultNetworkService)를 생성합니다.
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!, queryParameters: [
            "api_key": appConfiguration.apiKey,
            "language": NSLocale.preferredLanguages.first ?? "ko-KR"
        ])
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    /// API NetworkService 변수 입니다.
    ///
    /// - 해당 변수는 image 네트워크를 담당합니다.
    /// - Infrastructure / Network -> *DataTransferService protocol*를 채택한 Network Service class(DefaultNetworkService)를 생성합니다.
    lazy var imageDataTranserService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.imageBaseURL)!)
        
        let imagesDataNetwork = DefaultNetworkService(config: config)
        
        return DefaultDataTransferService(with: imagesDataNetwork)
    }()
    
    // MARK: DIContainers of scenes
    
    
    /// Login Scene DI Container를 생성합니다.
    /// - Returns: LoginSceneDIContainer
    func makeLoginSceneDIContainer() -> LoginSceneDIContainer {
        return LoginSceneDIContainer()
    }
    
    /// Movies Search DI Container를 생성합니다.
    /// - Movies Search Data 단계에서 필요한 api, image network service를 주입해줍니다.
    /// - Returns: MoviesSearchDIContainer
    func makeMoviesSearchDIContainer() -> MoviesSearchDIContainer {
        let dependecies = MoviesSearchDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            imageDataTransferService: imageDataTranserService
        )
        
        return MoviesSearchDIContainer(dependencies: dependecies)
    }
    
    /// Movies Top Rated DI Container를 생성합니다.
    /// - Movies Top Rated Data 단계에서 필요한 api, image network service를 주입해줍니다.
    /// - Returns: MoviesTopRatedDIContainer
    func makeMoviesTopRatedDIContainer() -> MoviesTopRatedDIContainer {
        let dependecies = MoviesTopRatedDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            imageDataTransferService: imageDataTranserService
        )
        
        return MoviesTopRatedDIContainer(dependencies: dependecies)
    }
    
    /// My Page DI Container를 생성합니다.
    /// - Returns: MyPageDIContainer
    func makeMyPageDIContainer() -> MyPageDIContainer {
        return MyPageDIContainer()
    }
}
