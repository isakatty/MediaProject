//
//  TrendMovieResponse.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import Foundation

struct TrendMovieResponseDTO: Decodable {
    let page: Int
    let media: [MovieResponseDTO]
}

