//
//  Disposable.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/09/01.
//

import Foundation

final class Disposables {
    private var disposables: [() -> Void] = []
    
    func add(_ disposable: @escaping () -> Void) {
        disposables.append(disposable)
    }
    
    func dispose() {
        disposables.forEach { $0() }
        disposables.removeAll()
    }
}

final class DisposeBag {
    private let disposables = Disposables()
    
    func add(_ disposable: @escaping () -> Void) {
        disposables.add(disposable)
    }
    
    deinit {
        disposables.dispose()
    }
}
