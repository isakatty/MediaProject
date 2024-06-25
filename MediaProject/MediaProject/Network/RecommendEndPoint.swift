//
//  RecommendEndPoint.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/25/24.
//

import Foundation

public struct RecommendEndPoint: Endpoint {
    private let movieID: String
    private let authKey: String
    
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
        "/3/movie/\(movieID)/recommendations"
    }
    
    public var query: [String : String] {
        [
            "language": "ko-KR",
            "page": "1"
        ]
    }
    
    public var header: [String : String] {
        ["Authorization": authKey]
    }
    
    public var body: [String : Any] {
        [:]
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public init(
        movieID: String,
        authKey: String
    ) {
        self.movieID = movieID
        self.authKey = authKey
    }
}
