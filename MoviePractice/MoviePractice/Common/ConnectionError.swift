//
//  ConnectionError.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError,
              error.isInternetConnectionError else {
            return false
        }
        return true
    }
}
