//
//  MovieVideo.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import Foundation

struct MovieVideo: Decodable {
    let id: Int
    let results: [VideoInfo]
}

struct VideoInfo: Decodable {
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let published_at: String
    let id: String
}

extension MovieVideo {
    var toDomain: MovieVideoResponse {
        return .init(
            movieId: id,
            movieVideos: results.map({
                .init(
                    movieName: $0.name,
                    movieKey: $0.key,
                    site: $0.site,
                    official: $0.official
                )
            })
        )
    }
}
