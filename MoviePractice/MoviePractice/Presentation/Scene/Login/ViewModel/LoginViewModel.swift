//
//  LoginViewModel.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/06.
//

import Foundation

struct LoginViewModelActions {
    let showTabBar: () -> Void
}

protocol LoginViewModelInput {
    func didTappedLogin()
}

protocol LoginViewModelOutput {
    
}

typealias LoginViewModel = LoginViewModelInput & LoginViewModelOutput

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
