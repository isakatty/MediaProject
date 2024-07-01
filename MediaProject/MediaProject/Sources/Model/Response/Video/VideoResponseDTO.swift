//
//  VideoResponseDTO.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import Foundation

struct VideoResponseDTO: Decodable {
    let movieName: String
    let movieKey: String
    let site: String
    let official: Bool
}
