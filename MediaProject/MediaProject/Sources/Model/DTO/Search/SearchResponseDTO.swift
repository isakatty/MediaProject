//
//  SearchResponseDTO.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

struct SearchResponseDTO {
    var page: Int
    var results: [SearchMovieResponseDTO]
    let total_pages, total_results: Int
}
