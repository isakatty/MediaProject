//
//  NetworkError.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case invalidError
    case noData
    case decodingError
    case statusCode
}
extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            "response 오류"
        case .invalidError:
            "error 발생"
        case .noData:
            "데이터 없음"
        case .decodingError:
            "디코딩 에러"
        case .statusCode:
            "상태코드 에러"
        }
    }
}
