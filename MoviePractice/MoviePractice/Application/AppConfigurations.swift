//
//  AppConfigurations.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

/// Api 관련 정보를 갖고있는 클래스 입니다.
final class AppConfiguration {
    /// *API.plist*로 구분한 APIKey값을 불러오는 변수입니다.
    lazy var apiKey: String = {
        guard let path = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: path) as? [String: Any],
              let apiKey = dict["API_Key"] as? String
        else { fatalError("ApiKey must not be empty in plist") }
        return apiKey
    }()
    
    /// api url
    let apiBaseURL = "https://api.themoviedb.org"
    
    /// image url
    let imageBaseURL = "https://image.tmdb.org"
}
