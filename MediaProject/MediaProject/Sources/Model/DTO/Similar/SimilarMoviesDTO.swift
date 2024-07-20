//
//  SimilarMoviesDTO.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/20/24.
//

import Foundation

struct SimilarMoviesDTO: Decodable {
    let page: Int
    let results: [SimilarDTO]
    let total_pages, total_results: Int
}

struct SimilarDTO: Decodable {
    let id: Int
    let poster_path: String
}
