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
    let gender: Int
    let id: Int
    let known_for_department: String
    let name: String
    let original_name: String
    let popularity: Double
    let profile_path: String?
    let cast_id: Int
    let character: String?
    let credit_id: String
    let order: Int?
    let department: String?
    let job: String?
}

extension MovieCreditResponse {
    var toDTO: MovieCreditResponseDTO {
        .init(
            id: id,
            cast: cast
                .filter { $0.known_for_department == "Acting" }
                .filter {
                    guard let order = $0.order else { return false }
                    return order < 10
                }
                .compactMap({ cast in
                guard let profile_path = cast.profile_path,
                      let character = cast.character else { return nil }
                return CastResponseDTO(
                    adult: cast.adult,
                    id: cast.id,
                    name: cast.name,
                    original_name: cast.original_name,
                    profile_path: profile_path,
                    character: character
                )
            })
        )
    }
}
