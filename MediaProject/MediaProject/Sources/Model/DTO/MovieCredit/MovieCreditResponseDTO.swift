//
//  MovieCreditResponseDTO.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

struct MovieCreditResponseDTO: Hashable {
    let id: Int
    let cast: [CastResponseDTO]
}
