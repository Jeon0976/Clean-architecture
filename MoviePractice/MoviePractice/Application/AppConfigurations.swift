//
//  AppConfigurations.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

final class AppConfiguration {
    lazy var apiKey: String = {
        guard let path = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: path) as? [String: Any],
              let apiKey = dict["API_Key"] as? String
        else { fatalError("ApiKey must not be empty in plist") }
        return apiKey
    }()
    
    let apiBaseURL = "https://api.themoviedb.org"
    let imageBaseURL = "https://image.tmdb.org"
}
