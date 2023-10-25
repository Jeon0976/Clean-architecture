//
//  DataTransferError+ConnectionError.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/25.
//

import Foundation

extension DataTransferError: ConnectionError {
    var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
              case .notConnected = networkError else { return false }
        return true
    }
}
