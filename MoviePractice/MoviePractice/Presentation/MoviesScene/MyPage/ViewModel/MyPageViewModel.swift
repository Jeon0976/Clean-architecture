//
//  MyPageViewModel.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/13.
//

import Foundation

struct MyPageModelActions {
    let showLogin: () -> Void
}

protocol MyPageViewModelInput {
    func didTappedLogout()
}

protocol MyPageViewModelOutput {
    
}

typealias MyPageViewModel = MyPageViewModelInput & MyPageViewModelOutput

final class DefaultMyPageViewModel: MyPageViewModel {
    
    private let actions: MyPageModelActions!
    
    init(actions: MyPageModelActions) {
        self.actions = actions
    }
}

extension DefaultMyPageViewModel {
    func didTappedLogout() {
        actions?.showLogin()
    }
}
