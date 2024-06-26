//
//  NetworkRequest.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/27/24.
//

import Foundation

public enum NetworkRequest: Endpoint {
    case trendingTV
    case trendingMovie
    case search(movieName: String)
    case images(movieId: String)
    
    public var scheme: Scheme {
        .https
    }
    public var host: String {
        "api.themoviedb.org"
    }
    public var port: String {
        ""
    }
    public var path: String {
        switch self {
        case .trendingTV:
            "/3/trending/tv/day"
        case .trendingMovie:
            "/3/trending/movie/day"
        case .search:
            "/3/search/movie"
        case .images(let movieId):
            "/3/movie/\(movieId)/images"
        }
    }
    public var query: [String : Any] {
        switch self {
        case .trendingTV, .trendingMovie:
            return ["language": "ko-KR"]
        case .search(let movieName):
            return [
                "language": "ko-KR",
                "query": movieName
            ]
        case .images:
            return [
                "include_image_language": "en,null",
                "language": "ko-KR"
            ]
        }
    }
    public var header: [String : String] {
        return [
            "accept": "application/json",
            "Authorization": Constant.Endpoint.TMDB_key
        ]
    }
    public var body: [String : Any] {
        [:]
    }
    public var method: String {
        _HTTPMethod.get.toString
    }
    
    public var toURLString: String {
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
