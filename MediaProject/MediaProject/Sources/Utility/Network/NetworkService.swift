//
//  NetworkService.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/24/24.
//

import UIKit

protocol NetworkServiceProtocol {
    func callRequest<T: Decodable>(
        endpoint: NetworkRequest,
        type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

final class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    
    private init() { }
    
    func callRequest<T: Decodable>(
        endpoint: NetworkRequest,
        type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let urlRequest = endpoint.toURLRequest else {
            print("URLRequest 오류")
            return
        }
        let session = URLSession(configuration: endpoint.urlSessionConfig)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            // error 있음
            if let error {
                completion(.failure(.invalidError))
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            // response의 상태 코드가 200번대
            guard 200..<300 ~= response.statusCode else {
                completion(.failure(.statusCode))
                return
            }
            // 데이터 없음
            guard let data else {
                completion(.failure(.noData))
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        // 통신 트리거
        task.resume()
    }
    func callImageData(url: URL, completion: @escaping (UIImage?) -> Void) {
        let session = URLSession(configuration: .ephemeral)
        let urlRequest = URLRequest(url: url)
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data,
                  response != nil,
                  error == nil else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                completion(image)
            }
        }
        task.resume()
    }
}
