//
//  UseCase.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/08/30.
//

import Foundation

/// Use Case를 생성하는 또 다른 방법은 start() 함수와 함께 Use Case 프로토콜을 사용하는 것이다.
/// 향후 업데이트될 FetchRecentMovieQueriesUseCase가 이 접근법을 따른다.
/// - 참고: UseCase는 다른 Use Case에 의존할 수 있다.
protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
