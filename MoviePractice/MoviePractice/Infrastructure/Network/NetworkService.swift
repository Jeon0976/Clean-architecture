//
//  NetworkService.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/09/01.
//

import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}
