//
//  NetworkConfigurable.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/09/01.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    /// 공통 query 처리
    var queryParameters: [String: String] { get }
}

struct ApiDataNetworkConfig: NetworkConfigurable {
    let baseURL: URL
    let headers: [String: String]
    let queryParameters: [String: String]
    
    init(baseURL: URL,
         headers: [String: String] = [:],
         queryParameters: [String: String] = [:]
    ) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
}
