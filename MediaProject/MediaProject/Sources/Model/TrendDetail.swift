//
//  TrendDetail.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/11/24.
//

import Foundation

enum Sections: String {
    case overView = "OverView"
    case cast = "Cast"
}

struct TrendDetail {
    let section: Sections
    var descriptionText: String?
    var actorInfo: [CastResponse]?
}

struct TrendCollection {
    var actorInfo: [CastResponseDTO]?
    var poster: [PosterPath]?
    var similar: [TrendInfo]?
}
