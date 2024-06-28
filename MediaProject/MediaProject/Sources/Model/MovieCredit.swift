//
//  MovieCredit.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/11/24.
//

import Foundation

struct MovieCredit: Decodable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Decodable {
    let adult: Bool
    let id: Int
    let name: String
    let original_name: String
    let profile_path: String?
    let character: String
}

enum Gender: Int, Decodable {
    case xx = 1
    case xy = 2
    case unowned
}
