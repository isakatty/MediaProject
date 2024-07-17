//
//  Endpoint.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/25/24.
//

import Foundation

enum Scheme: String {
    case http, https
}

protocol Endpoint {
    var scheme: Scheme { get }
    var host: String { get }
    var port: String { get }
    var path: String { get }
    var query: [String: Any] { get }
    var header: [String: String] { get }
    var body: [String: Any] { get }
    var method: String { get }
}

extension Endpoint {
    var toURLString: String {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme.rawValue
        urlComponent.host = host
        urlComponent.port = Int(port)
        urlComponent.path = path
        if !query.isEmpty {
            urlComponent.queryItems = query.map {
                URLQueryItem(name: $0.key, value: $0.value as? String)
            }
        }
        
        return urlComponent.url?.absoluteString ?? ""
    }
    var toURLRequest: URLRequest? {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme.rawValue
        urlComponent.host = host
        urlComponent.port = Int(port)
        urlComponent.path = path
        if !query.isEmpty {
            urlComponent.queryItems = query.map {
                URLQueryItem(name: $0.key, value: $0.value as? String)
            }
        }
        guard let url = urlComponent.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.allHTTPHeaderFields = header
        
        return urlRequest
    }
}
