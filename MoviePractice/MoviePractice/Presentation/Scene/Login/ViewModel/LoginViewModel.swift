//
//  LoginViewModel.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/06.
//

import Foundation

/// Coordinator 내부에 있는 화면 전환 메서드들 즉, private 메서드들을 나타내고 있습니다.
struct LoginViewModelActions {
    let showTabBar: () -> Void
}

/// 로그인 뷰 모델의 입력 관련 인터페이스를 정의합니다.
/// - 사용자의 액션에 대한 처리 방법을 명시합니다.
protocol LoginViewModelInput {
    func didTappedLogin()
}

/// 구체적인 기능을 갖고 있지 않지만, 일반적으로 이 프로토콜은 뷰 모델의 출력 관련 인터페이스를 정의합니다.
/// - 예를 들어, 뷰에 표시할 데이터의 변화를 알릴 수 있습니다.
protocol LoginViewModelOutput {
    
}

typealias LoginViewModel = LoginViewModelInput & LoginViewModelOutput

/// `LoginViewModel` 프로토콜을 구체화하는 클래스입니다.
/// - 해당 클래스는 로그인 관련 비즈니스 로직을 처리합니다.
final class DefaultLoginViewModel: LoginViewModel {
    
    private let actions: LoginViewModelActions?
    
    init(actions: LoginViewModelActions) {
        self.actions = actions
    }
}

// MARK: Input. View Event Methods
extension DefaultLoginViewModel {
    func didTappedLogin() {
        actions?.showTabBar()
    }
}
