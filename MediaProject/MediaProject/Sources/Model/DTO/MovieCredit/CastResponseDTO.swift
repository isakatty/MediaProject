//
//  CastResponseDTO.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

struct CastResponseDTO: Hashable {
    let adult: Bool
    let id: Int
    let name: String
    let original_name: String
    let profile_path: String
    let character: String
}
