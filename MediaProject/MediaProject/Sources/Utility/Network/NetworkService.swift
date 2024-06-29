//
//  NetworkService.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/24/24.
//

import Foundation

import Alamofire

protocol NetworkServiceProtocol {
    func callTMDB<T: Decodable>(
        endPoint: NetworkRequest,
        type: T.Type,
        completionHandler: @escaping (T?, String?) -> Void
    )
}

final class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    
    private init() { }
    
    func callTMDB<T: Decodable>(
        endPoint: NetworkRequest,
        type: T.Type,
        completionHandler: @escaping (T?, String?) -> Void
    ) {
        guard let url = URL(string: endPoint.toURLString) else { return }
        AF.request(
            url,
            method: HTTPMethod(rawValue: endPoint.method),
            encoding: URLEncoding(destination: .queryString),
            headers: HTTPHeaders(endPoint.header)
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { response in
                        // of 뒤에 들어오는건 메타타입이 들어와야해.
            switch response.result {
            case .success(let value):
                completionHandler(value, nil)
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
}
