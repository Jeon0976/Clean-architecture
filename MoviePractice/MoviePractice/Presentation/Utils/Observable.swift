//
//  Observable.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/08/31.
//

enum ObservableEvent<Value> {
    case next(Value)
    case error(Error)
    case completed
}

/// <#Description#>
class Observable<Value> {
    /// - observer : 실제 관찰자 객체
    /// - block: 값이 변경될 때 실행될 클로저를 저장
    struct Observer<Value> {
        weak var observer: AnyObject?
        let block: (ObservableEvent<Value>) -> Void
    }
    
    /// - 모든 observers를 저장하는 배열
    private var observers = [Observer<Value>]()
    
    /// - 실제 관찰되는 값
    /// - 값이 설정될 때마다 'didSet'에서 'notifyObservers' 메서드를 호출하여 모든 observer에게 알린다.
    var value: Value {
        didSet { notifyObservers(event: .next(value)) }
    }
    
    init(_ value: Value) {
        self.value = value
    }
    
    deinit {
        observers.removeAll()
    }
    
    /// observer를 추가한다. 추가될 때 현재 값에 대한 알림도 바로 전달한다.
    @discardableResult
    fileprivate func observe(
        on observer: AnyObject,
        observerBlock: @escaping (ObservableEvent<Value>) -> Void
    ) -> Observable<Value> {
        observers.append(Observer(observer: observer, block: observerBlock))
        observerBlock(.next(self.value))
        
        return self
    }
    
    /// 모든 observers에게 값을 알린다
    private func notifyObservers(event: ObservableEvent<Value>) {
        for observer in observers {
            observer.block(event)
        }
    }
    
    fileprivate func removeDisposable(for observer: AnyObject) -> () -> Void {
        return { [weak self] in
            self?.remove(observer: observer)
        }
    }
    
    
    /// 리스트 안에 있는 특정 관찰자를 제거합니다.
    /// - Parameter observer: 제거하고자 하는 관찰자 객체
    /// - 해당 함수는 removeDisposable를 통해서만 호출됩니다.
    private func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    
    /// 구독을 시작하고 관찰자에게 이벤트를 전달합니다.
    /// - Parameters:
    ///   - observer: 이벤트를 받을 관찰자 객체
    ///   - disposeBag: 관찰자가 더 이상 필요하지 않을 때 관찰자를 제거하기 위한 객체
    ///   - onNext: 값이 변경될 때마다 실행될 클로저
    ///   - onError: 오류가 발생했을 때 실행될 클로저
    ///   - onCompleted: 관찰이 완료되었을 때 실행될 클로저
    /// - Returns: Subscription 객체를 반환한다. 이를 통해 관찰자는 구독을 관리할 수 있습니다.
    func subscribe(
        on observer: AnyObject,
        disposeBag: DisposeBag,
        onNext: ((Value) -> Void)? = nil,
        onError: ((Error) -> Void)? = nil,
        onCompleted: (() -> Void)? = nil
    ) -> Subscription<Value> {
        return Subscription(
            observable: self,
            observer: observer,
            disposeBag: disposeBag,
            onNext: onNext,
            onError: onError,
            onCompleted: onCompleted
        )
    }
}

final class Subscription<Value> {
    
    private let observable: Observable<Value>
    private weak var observer: AnyObject?
    private let disposeBag: DisposeBag

    init(
           observable: Observable<Value>,
           observer: AnyObject,
           disposeBag: DisposeBag,
           onNext: ((Value) -> Void)? = nil,
           onError: ((Error) -> Void)? = nil,
           onCompleted: (() -> Void)? = nil
       ) {
           self.observable = observable
           self.observer = observer
           self.disposeBag = disposeBag
           
           if let onNext = onNext {
               self.onNext(onNext)
           }
           
           if let onError = onError {
               self.onError(onError)
           }
           
           if let onCompleted = onCompleted {
               self.onCompleted(onCompleted)
           }
       }
    
    @discardableResult
    func onNext(_ onNext: @escaping (Value) -> Void) -> Self {
        guard let observer = observer else { return self }
        
        let disposable = observable.observe(on: observer) { event in
            if case .next(let value) = event {
                onNext(value)
            }
        }.removeDisposable(for: observer)
        
        disposeBag.add(disposable)
        return self
    }
    
    @discardableResult
     func onError(_ onError: @escaping (Error) -> Void) -> Self {
         guard let observer = observer else { return self }

         let disposable = observable.observe(on: observer) { event in
             if case .error(let error) = event {
                 onError(error)
             }
         }.removeDisposable(for: observer)
         
         disposeBag.add(disposable)
         return self
     }
     
     @discardableResult
     func onCompleted(_ onCompleted: @escaping () -> Void) -> Self {
         guard let observer = observer else { return self }

         let disposable = observable.observe(on: observer) { event in
             if case .completed = event {
                 onCompleted()
             }
         }.removeDisposable(for: observer)

         disposeBag.add(disposable)
         return self
     }
}
