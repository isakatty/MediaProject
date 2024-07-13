//
//  PosterResponse.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/26/24.
//

import Foundation

struct PosterResponse: Decodable {
    let backdrops: [PosterPathResponse]
}

struct PosterPathResponse: Decodable {
    var aspect_ratio: Double
    var height: Int
    var iso_639_1: String?
    var file_path: String
    var vote_average: Double
    var vote_count: Int
    var width: Int
}

extension PosterResponse {
    var toDTO: PosterResponseDTO {
        return .init(backdrops: backdrops.map {
            .init(file_path: $0.file_path)
        })
    }
}
