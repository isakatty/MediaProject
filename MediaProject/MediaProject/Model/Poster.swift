//
//  Poster.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/26/24.
//

import Foundation

public struct Poster: Decodable {
    let backdrops: [PosterPath]
}

public struct PosterPath: Decodable {
    var file_path: String
}
