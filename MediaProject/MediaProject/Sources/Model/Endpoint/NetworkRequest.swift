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
    case recommends(movieId: String)
    case similarMovies(movieId: String)
    
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
        // TODO: trend, search, movie로 나누고, 거기서 케이스 분리를 할 수 있을 것 같은데 ?
        switch self {
        case .trendingTV:
            "/3/trending/tv/day"
        case .trendingMovie:
            "/3/trending/movie/day"
        case .search:
            "/3/search/movie"
        case .images(let movieId):
            "/3/movie/\(movieId)/images"
        case .recommends(let movieId):
            "/3/movie/\(movieId)/recommendations"
        case .similarMovies(let movieId):
            "/3/movie/\(movieId)/similar"
        }
    }
    public var query: [String : Any] {
        // TODO: language 공통 - 공통 묶어서 처리할 수 있게 변경해보기
        switch self {
        case .trendingTV, .trendingMovie, .similarMovies:
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
        case .recommends:
            return [
                "language": "ko-KR",
                "page": 1
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
