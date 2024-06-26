//
//  SimilarMovies.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/24/24.
//

import Foundation

public struct SimilarMovies: Decodable {
    let page: Int
    var results: [SearchedMovieInfo]
    let total_pages: Int
    let total_results: Int
}

