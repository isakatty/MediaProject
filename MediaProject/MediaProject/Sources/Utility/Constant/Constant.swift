//
//  Constant.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/24/24.
//

import UIKit

enum Constant {
    enum Endpoint {
        static let imageURL = "https://image.tmdb.org/t/p/original"
        static let tmdb_URL = "https://api.themoviedb.org/3/trending/movie/week?"
        static let tmdb_search_URL = "https://api.themoviedb.org/3/movie/"
        static let tmdb_Search_Movie_URL = "https://api.themoviedb.org/3/search/movie?"
        static let kofic_URL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
        static let tmdb_similar_URL = "https://api.themoviedb.org/3/movie/"
        
        static var TMDB_key: String = Bundle.main.object(
            forInfoDictionaryKey: "TMDB_API_TOKEN"
        ) as? String ?? ""
        
        static var api_key: String = Bundle.main.object(
            forInfoDictionaryKey: "MOVIE_API_KEY"
        ) as? String ?? ""
    }
    
    enum Font {
        static let bold23 = UIFont.boldSystemFont(ofSize: 23)
        static let bold21 = UIFont.boldSystemFont(ofSize: 21)
        static let bold19 = UIFont.boldSystemFont(ofSize: 19)
        static let bold17 = UIFont.boldSystemFont(ofSize: 17)
        static let bold15 = UIFont.boldSystemFont(ofSize: 15)
        static let bold13 = UIFont.boldSystemFont(ofSize: 13)
        static let regular15 = UIFont.systemFont(ofSize: 15)
        static let regular14 = UIFont.systemFont(ofSize: 14)
        static let regular13 = UIFont.systemFont(ofSize: 13)
        static let light13 = UIFont.systemFont(
            ofSize: 13,
            weight: .light
        )
    }
}

