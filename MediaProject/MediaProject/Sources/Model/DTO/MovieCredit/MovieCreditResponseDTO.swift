//
//  MovieCreditResponseDTO.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

struct MovieCreditResponseDTO: Decodable {
    let id: Int
    let cast: [CastResponseDTO]
}
