//
//  PosterEndPoint.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/26/24.
//

import Foundation

public struct PosterEndPoint: Endpoint {
    private let movieId: String
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
        "/3/movie/\(movieId)/images"
    }
    public var query: [String : Any] {
        [
            "include_image_language": "en,null",
            "language": "ko-KR"
        ]
    }
    public var header: [String : String] {
        ["Authorization": authKey]
    }
    public var body: [String : Any] {
        return [:]
    }
    public var method: String {
        _HTTPMethod.get.toString
    }
    
    public init(
        movieId: String,
        authKey:  String
    ) {
        self.movieId = movieId
        self.authKey = authKey
    }
}
