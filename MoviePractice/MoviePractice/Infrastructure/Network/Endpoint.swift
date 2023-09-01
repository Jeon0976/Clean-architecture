//
//  Endpoint.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/09/01.
//

import Foundation

/// HTTP 요청 방법을 나타냄
enum HTTPMethodType: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// 요청 본문의 인코딩 형식을 나타내는 열거형이다.
/// - jsonSerializationData
///     - 본문의 데이터를 JSON 형식으로 직렬화한다.
///     - 웹 API와 통신할 때 흔히 사용되는 메시지 형식
/// - stringEncodingAscii
///     - 본문의 데이터를 ASCII 문자열로 인코딩
///     - 'application/x-www-form-urlencoded' (URL 인코딩도니 폼 데이터)를 서버에 전송할 때 사용
//protoco BodyEncoder {
//    case jsonSerializationData
//    case stringEncodingAscii
//    // 추후 업데이트
//    // case xmlSerializationData
//}

// MARK: End Point
/// 응답을 반환하는 요청에 대한 엔드포인트를 나타낸다. 'R'은 응답의 타입
/// - 이 클래스는 요청 경로, 헤더, 쿼리 매개변수, 본문 매개변수, 본문 인코딩, 응답 디코더 등의 속성을 가진다.
class EndPoint<R>: ResponseRequestable {
    
    typealias Response = R
    
    let path: String
    let isFullPath: Bool
    let method: HTTPMethodType
    let headerParameters: [String: String]
    let queryParametersEncodable: Encodable?
    let queryParameters: [String: Any]
    let bodyParametersEncodable: Encodable?
    let bodyParameters: [String: Any]
    let bodyEncoder: BodyEncoder
    let responseDecoder: ResponseDecoder
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethodType,
         headerParameters: [String : String] = [:],
         queryParametersEncodable: Encodable? = nil,
         queryParameters: [String : Any] = [:],
         bodyParametersEncodable: Encodable? = nil,
         bodyParameters: [String : Any] = [:],
         bodyEncoder: BodyEncoder = JSONBodyEncoder(),
         responseDecoder: ResponseDecoder = JSONResponseDecoder()
    ) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
}

protocol BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data?
}

struct JSONBodyEncoder: BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}

struct AsciiBodyEncoder: BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data? {
        return parameters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
    }
}


// MARK: Request Table
/// HTTP 요청을 나타내는 프로토콜
/// - 경로, 메서드, 헤더, 쿼리 및 본문 매개변수와 같은 필요한 속성을 정의하며, URLRequest 객체를 생성하는 메서드를 포함한다.
protocol RequestTable {
    
}

extension RequestTable {
    
}

// MARK: Response Request Table
/// 응답과 함께 오는 HTTP 요청을 나타내는 프로토콜이다.
/// - Requestable 프롵콜을 확장하며, 응답 타입과 응답 디코더 속성을 추가한다.
protocol ResponseRequestable: RequestTable {
    
}

/// 요청 생성 중 발생할 수 있는 오류를 나타내는 열거형이다.
enum RequestGenerationError: Error {
    
}

private extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
}
