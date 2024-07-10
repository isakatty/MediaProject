//
//  MovieCredit.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/11/24.
//

import Foundation

struct MovieCreditResponse: Decodable {
    let id: Int
    let cast: [CastResponse]
}

struct CastResponse: Decodable {
    let adult: Bool
    let id: Int
    let name: String
    let original_name: String
    let profile_path: String?
    let character: String
}

extension MovieCreditResponse {
    var toDTO: MovieCreditResponseDTO {
        .init(
            id: id,
            cast: cast.compactMap({ cast in
                guard let profile_path = cast.profile_path else { return nil }
                return CastResponseDTO(
                    adult: cast.adult,
                    id: cast.id,
                    name: cast.name,
                    original_name: cast.original_name,
                    profile_path: profile_path,
                    character: cast.character
                )
            })
        )
    }
}

struct MovieCreditResponseDTO: Decodable {
    let id: Int
    let cast: [CastResponseDTO]
}

struct CastResponseDTO: Decodable {
    let adult: Bool
    let id: Int
    let name: String
    let original_name: String
    let profile_path: String
    let character: String
}
