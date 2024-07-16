//
//  NetworkRequest.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/27/24.
//

import Foundation

enum NetworkRequest: Endpoint {
    static let videoBaseURL = "https://www.youtube.com/watch?v="
    static let imageBaseURL = "https://image.tmdb.org/t/p/original"
    static var TMDB_key: String = Bundle.main.object(
        forInfoDictionaryKey: "TMDB_API_TOKEN"
    ) as? String ?? ""
    
    case trendingTV
    case trendingMovie
    case trendDetail(movieId: String)
    case search(movieName: String, page: Int)
    case images(movieId: String)
    case recommends(movieId: String)
    case similarMovies(movieId: String)
    case movieVideo(movieId: Int)
    
    var scheme: Scheme {
        .https
    }
    var host: String {
        "api.themoviedb.org"
    }
    var port: String {
        ""
    }
    var path: String {
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
        case .trendDetail(let movieId):
            "/3/movie/\(movieId)/credits"
        case .movieVideo(let movieId):
            "/3/movie/\(movieId)/videos"
        }
    }
    var query: [String : Any] {
        // TODO: language 공통 - 공통 묶어서 처리할 수 있게 변경해보기
        switch self {
        case .trendingTV, .trendingMovie, .trendDetail,
                .similarMovies, .recommends, .movieVideo:
            return ["language": "ko-KR"]
        case .search(let movieName, let page):
            return [
                "language": "ko-KR",
                "query": movieName,
                "include_adult": true,
                "page": "\(page)"
            ]
        case .images:
            return [
                "include_image_language": "en,null",
                "language": "ko-KR"
            ]
        }
    }
    var header: [String : String] {
        return [
            "accept": "application/json",
            "Authorization": NetworkRequest.TMDB_key
        ]
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
