//
//  TrendTVResponseDTO.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import Foundation

struct TrendTVResponseDTO: Decodable {
    let page: Int
    let media: [TVResponseDTO]
}
