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
    
//    @discardableResult
//    func result<T: Decodable, E: ResponseRequestTable>
}

/// 네트워크 에러를 다른 형태의 에러로 변환할 때 사용하는 프로토콜
protocol DataTransferErrorResolver {
    
}

/// 네트워크 응답을 디코딩하는 역할을 하는 프로토콜
protocol ResponseDecoder {
    
}

/// 에러 로깅을 담당하는 프로토콜
protocol DataTransferErrorLogger {
    
}


// MARK: DataTransfer Service
/// **DataTransferService**  프로토콜을 준수하며, 네트워크 서비스, 에러 해결, 에러 로거의 인스턴스를 가지고 있다.
/// - 네트워크 요청의 성공 또는 실패에 따라 적절한 동작을 실행한다.
final class DefaultDataTransferService {
    
}

extension DefaultDataTransferService: DataTransferService {
    
}

// MARK: Logger
/// 기본적인 에러 로깅 및 에러 해결을 위한 클래스
final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    init() { }
}

final class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    init() { }
}

// MARK: Response Decoder
/// JSON 데이터를 디코드하는 역할
class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    
    init() { }
    
}

// MARK: 원시 데이터 Decoder
/// 원시 데이터 (data)를 디코드하는 역할
class RawDataResponseDecoder: ResponseDecoder {
    init() { }
}
