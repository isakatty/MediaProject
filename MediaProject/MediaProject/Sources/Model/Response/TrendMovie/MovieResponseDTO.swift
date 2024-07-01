//
//  MovieResponse.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import Foundation

struct MovieResponseDTO: Decodable {
    let id: Int
    let title: String
    let poster_path: String
}
