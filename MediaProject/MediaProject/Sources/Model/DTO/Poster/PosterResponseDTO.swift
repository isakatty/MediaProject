//
//  PosterResponseDTO.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/13/24.
//

import Foundation

struct PosterResponseDTO: Decodable {
    let backdrops: [PosterPathResponseDTO]
}
