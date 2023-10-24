//
//  RepositoryTask.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
