//
//  Observable.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/08/31.
//

import Foundation

final class Observable<Value> {
    
    /// - observer : 실제 관찰자 객체
    /// - block: 값이 변경될 때 실행될 클로저를 저장
    struct Observer<Value> {
        weak var observer: AnyObject?
        let block: (Value) -> Void
    }
    
    /// - 모든 observers를 저장하는 배열
    private var observers = [Observer<Value>]()
    
    /// - 실제 관찰되는 값
    /// - 값이 설정될 때마다 'didSet'에서 'notifyObservers' 메서드를 호출하여 모든 observer에게 알린다.
    var value: Value {
        didSet { notifyObservers() }
    }
    
    init(_ value: Value) {
        self.value = value
    }
    
    /// 모든 observers에게 값을 알린다
    private func notifyObservers() {
        for observer in observers {
            observer.block(self.value)
        }
    }
    
    /// observer를 추가한다. 추가될 때 현재 값에 대한 알림도 바로 전달한다.
    @discardableResult
    private func observe(on observer: AnyObject,
                 observerBlock: @escaping (Value) -> Void
    ) -> Observable<Value> {
        observers.append(Observer(observer: observer, block: observerBlock))
        observerBlock(self.value)
        
        return self
    }
    
    /// 특정 observer를 제거한다
    func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    /// 다른 'Observable' 객체에 값의 변경을 바인딩
    func bind(to observable: Observable<Value>) {
        observe(on: self) { newValue in
            observable.value = newValue
        }
    }
}

extension Observable {
    // subscribe
    func subscribe(on observer: AnyObject,
                   onNext: @escaping (Value) -> Void,
                   disposedBy disposeBag: DisposeBag
    ) {
        let disposable = observe(on: self) { value in
            onNext(value)
        }.removeDisposable(for: observer)
        
        disposeBag.add(disposable)
    }
    
    /// filtering
    func subscribeAndFiltered(on observer: AnyObject,
                           filter: @escaping (Value) -> Bool,
                           onNext: @escaping (Value) -> Void,
                           disposedBy disposeBag: DisposeBag
    ) {
        let disposable = observe(on: observer) { newValue in
            if filter(newValue) {
                onNext(newValue)
            }
        }.removeDisposable(for: observer)
        
        disposeBag.add(disposable)
    }
    
    /// transformation
    func subscribeAndTransformed<T>(on observer: AnyObject,
                                 transform: @escaping (Value) -> T,
                                 onNext: @escaping (T) -> Void,
                                 disposedBy disposeBag: DisposeBag
    ) {
        let disposable = observe(on: observer) { newValue in
            onNext(transform(newValue))
        }.removeDisposable(for: observer)
        
        disposeBag.add(disposable)
    }
    
    private func removeDisposable(for observer: AnyObject) -> () -> Void {
        return { [weak self] in
            self?.remove(observer: observer)
        }
    }
}


/// 예시 코드
//class User {
//    var name: Observable<String>
//
//    init(name: String) {
//        self.name = Observable(name)
//    }
//}
//
//class NameDisplay {
//    init(user: User, disposeBag: DisposeBag) {
//        user.name.subscribe(on: self, onNext: { newValue in
//            print("user Name: \(newValue)")
//        }, disposedBy: disposeBag)
//    }
//}
//
//class Filtering {
//    init(user: User, disposeBag: DisposeBag) {
//        user.name.subscribeFiltered(on: self, filter: { text in
//            if text == "ab" {
//                return true
//            } else {
//                return false
//            }
//        }, onNext: { text in
//            print("success filtering")
//        }, disposedBy: disposeBag)
//    }
//}
//
//class Transform {
//    init(user: User, disposeBag: DisposeBag) {
//        user.name.subscribeTransformed(on: self, transform: { text in
//            if text == "transform" {
//                return true
//            } else {
//                return false
//            }
//        }, onNext: { value in
//            print("transform: \(value)")
//        }, disposedBy: disposeBag)
//    }
//}
//
//var disposeBag: DisposeBag?
//
//disposeBag = DisposeBag()
//
//let user = User(name: "John")
//
//let displayService = NameDisplayService(user: user, disposeBag: disposeBag!)
//
//let test = Filtering(user: user, disposeBag: disposeBag!)
//let transform = Transform(user: user, disposeBag: disposeBag!)
//
//let binding = Observable("Binding")
//
//binding.bind(to: user.name)
//
//// 이름 변경 -> 자동으로 NameDisplayService에 알림
//user.name.value = "Jane"  // 출력: User's name is now: Jane
//
//user.name.value = "ab"
//
//user.name.value = "DD"
//
//user.name.value = "transform"
//
//disposeBag = nil
//

// 결과 값
//user Name: John
//transform: false
//user Name: Binding
//transform: false
//user Name: Jane
//transform: false
//user Name: ab
//success filtering
//transform: false
//user Name: DD
//transform: false
//user Name: transform
//transform: true
//init DisposeBag
