//
//  Poster.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/26/24.
//

import Foundation

struct Poster: Decodable {
    let backdrops: [PosterPath]
}

struct PosterPath: Decodable {
    var file_path: String
}
