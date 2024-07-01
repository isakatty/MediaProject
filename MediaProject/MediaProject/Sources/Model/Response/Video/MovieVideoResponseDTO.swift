//
//  MovieVideoResponseDTO.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import Foundation

struct MovieVideoResponseDTO: Decodable {
    let movieId: Int
    let movieVideos: [VideoResponseDTO]
}
