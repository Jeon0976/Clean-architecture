//
//  UseCase.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/08/30.
//

import Foundation

protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
