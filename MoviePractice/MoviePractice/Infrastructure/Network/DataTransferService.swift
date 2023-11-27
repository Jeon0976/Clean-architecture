//
//  DataTransferService.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/09/01.
//

import Foundation

/// Data 전송 중 발생할 수 있는 오류 유형
enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

/// 작업을 비동기적으로 실행하기 위한 프로토콜 -> 기본적으로 DispatchQueue를 화장하여 이 프로토콜을 준수하도록 설계
protocol DataTransferDispatchQueue {
    func asyncExecute(work: @escaping () -> Void)
}

extension DispatchQueue: DataTransferDispatchQueue {
    func asyncExecute(work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }
}

/// 데이터 전송 서비스와 관련된 메소드들을 정의하는 프로토콜
/// - 주로 네트워크 요청을 관리하는 역할
protocol DataTransferService {
    typealias CompltionHandler<T> = (Result<T, DataTransferError>) -> Void
    
    /// Decodable Response with Custom Queue
    /// Decodable 타입의 응답을 기대하며,
    /// 결과를 처리할 때 사용할 커스텀 dispatch queue를 지정할 수 있다.
    /// 이는 메인 스레드가 아닌 다른 스레드에서 결과를 처리하고자 할 때 유용
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompltionHandler<T>
    ) -> NetworkCancellable? where E.Response == T
    
    /// Decodable Response with Main Queue
    /// Decodable 타입의 응답을 기대하며,
    /// 결과를 처리할 때 메인 dispatch queue를 사용한다.
    /// UI 업데이트와 같이 메인 스레드에서 처리해아 하는 작업을 위해 사용한다.
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        completion: @escaping CompltionHandler<T>
    ) -> NetworkCancellable? where E.Response == T
    
    /// Void Response with Custom Queue
    /// 응답의 본문을 기대하지 않으며 (예: HTTP 상태 코드만 확인), 결과를 처리할 때 사용할 커스텀 dispatch queue를 지정할 수 있다.
    @discardableResult
    func request<E: ResponseRequestable>(
        with endpoint: E,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompltionHandler<Void>
    ) -> NetworkCancellable? where E.Response == Void
    
    /// Void Response with Main Queue
    /// 응답의 본문을 기대하지 않으며, 결과를 처리할 때 메인 dispatch queue를 사용한다.
    @discardableResult
    func request<E: ResponseRequestable>(
        with endpoint: E,
        completion: @escaping CompltionHandler<Void>
    ) -> NetworkCancellable? where E.Response == Void
}

/// 네트워크 에러를 다른 형태의 에러로 변환할 때 사용하는 프로토콜
protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

/// 네트워크 응답을 디코딩하는 역할을 하는 프로토콜
protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

/// 에러 로깅을 담당하는 프로토콜
protocol DataTransferErrorLogger {
    func log(error: Error)
}


// MARK: DataTransfer Service
/// **DataTransferService**  프로토콜을 준수하며, 네트워크 서비스, 에러 해결, 에러 로거의 인스턴스를 가지고 있습니다.
/// - 네트워크 요청의 성공 또는 실패에 따라 적절한 동작을 실행한다.
final class DefaultDataTransferService {
    
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger
    
    init(
        with networkService: NetworkService,
        errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
        errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()
    ) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
}

extension DefaultDataTransferService: DataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompltionHandler<T>
    ) -> NetworkCancellable? where
    T : Decodable,
    T == E.Response,
    E : ResponseRequestable {
        networkService.request(endPoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, DataTransferError> = self.decode(data: data, decoder: endpoint.responseDecoder)
                queue.asyncExecute {
                    completion(result)
                }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                queue.asyncExecute {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func request<T, E>(
        with endpoint: E,
        completion: @escaping CompltionHandler<T>
    ) -> NetworkCancellable?
    where
    T : Decodable,
    T == E.Response,
    E : ResponseRequestable {
        request(
            with: endpoint,
            on: DispatchQueue.main,
            completion: completion
        )
    }
    
    func request<E>(
        with endpoint: E,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompltionHandler<Void>
    ) -> NetworkCancellable?
    where
    E : ResponseRequestable,
    E.Response == () {
        networkService.request(endPoint: endpoint) { result in
            switch result {
            case .success:
                queue.asyncExecute {
                    completion(.success(()))
                }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                queue.asyncExecute {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func request<E>(
        with endpoint: E,
        completion: @escaping CompltionHandler<Void>
    ) -> NetworkCancellable?
    where
    E : ResponseRequestable,
    E.Response == () {
        request(
            with: endpoint,
            on: DispatchQueue.main,
            completion: completion
        )
    }
    
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            self.errorLogger.log(error: error)
            return .failure(.parsing(error ))
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError
        ? .networkFailure(error)
        : .resolvedNetworkFailure(resolvedError)
    }
}

// MARK: Logger
/// 기본적인 에러 로깅 및 에러 해결을 위한 클래스
final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    init() { }
    
    func log(error: Error) {
        printIfDebug("-------------")
        printIfDebug("\(error)")
    }
}

final class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    init() { }
    
    func resolve(error: NetworkError) -> Error {
        return error
    }
}

// MARK: Response Decoder
/// JSON 데이터를 디코드하는 역할
class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    
    init() { }
    
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        return try jsonDecoder.decode(T.self, from: data)
    }
    
}

// MARK: 원시 데이터 Decoder
/// 원시 데이터 (data)를 디코드하는 역할
// TODO: - 설명 필요
class RawDataResponseDecoder: ResponseDecoder {
    init() { }
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(
                codingPath: [CodingKeys.default],
                debugDescription: "Expected Data type"
            )
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}
