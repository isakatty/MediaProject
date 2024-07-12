//
//  VideoRequest.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

enum VideoRequest: Endpoint {
    case video(key: String)
    
    var scheme: Scheme {
        .https
    }
    var host: String {
        "www.youtube.com"
    }
    var port: String {
        ""
    }
    var path: String {
        "/watch"
    }
    var query: [String : Any] {
        switch self {
        case .video(let key):
            ["v": key]
        }
    }
    var header: [String : String] {
        [:]
    }
    var body: [String : Any] {
        [:]
    }
    var method: String {
        _HTTPMethod.get.toString
    }
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
}
