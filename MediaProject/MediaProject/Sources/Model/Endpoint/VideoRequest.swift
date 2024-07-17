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
}
