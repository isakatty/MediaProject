//
//  NetworkManager.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/24/24.
//

import Foundation

import Alamofire

protocol NetworkServiceProtocol {
    func callTrendList(completionHandler: @escaping ([MovieInfo]) -> Void)
    func callMovieDetail(
        with movieInfo: MovieInfo,
        completionHandler: @escaping (MovieCredit, MovieInfo) -> Void
    )
    func callSearchKofic(
        date: String,
        completionHandler: @escaping (Result<Movie, Error>) -> Void
    )
    func callSearchTMDB(
        with keyword: String,
        page: Int,
        completionHandler: @escaping (SearchedMovie) -> Void
    )
    func callSimilarTMDB(
        movieID: Int,
        completionHanlder: @escaping (SimilarMovies) -> Void
    )
}

public final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    
    private var api_key: String {
        return Bundle.main.object(
            forInfoDictionaryKey: "MOVIE_API_KEY"
        ) as? String ?? ""
    }
    private var TMDB_key: String {
        return Bundle.main.object(
            forInfoDictionaryKey: "TMDB_API_TOKEN"
        ) as? String ?? ""
    }
    private let params: Parameters = ["language": "ko-KR"]
    private lazy var headers: HTTPHeaders = [
        "accept": "application/json",
        "Authorization": TMDB_key
    ]
    
    private init() { }
    
    public func callTrendList(
        completionHandler: @escaping ([MovieInfo]) -> Void) {
        let url = Constant.Endpoint.tmdb_URL
        
        AF.request(
            url,
            parameters: params,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Trend.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value.results)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func callMovieDetail(
        with movieInfo: MovieInfo,
        completionHandler: @escaping (MovieCredit, MovieInfo) -> Void
    ) {
        let pathParams: String = String(movieInfo.id) + "/credits"
        let url = Constant.Endpoint.tmdb_search_URL + pathParams

        AF.request(
            url,
            parameters: params,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: MovieCredit.self) { response in
            switch response.result {
            case .success(let value):
                print("Success")
                completionHandler(value, movieInfo)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func callSearchKofic(
        date: String,
        completionHandler: @escaping (Result<Movie, Error>) -> Void
    ) {
        let pathParams = "key=\(api_key)&targetDt="
        let movieURL = Constant.Endpoint.kofic_URL + pathParams + date
        
        AF.request(movieURL).responseDecodable(
            of: Movie.self
        ) { response in
            switch response.result {
            case .success(let movie):
                completionHandler(.success(movie))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    public func callSearchTMDB(
        with keyword: String,
        page: Int,
        completionHandler: @escaping (SearchedMovie) -> Void
    ) {
        let baseURL = Constant.Endpoint.tmdb_Search_Movie_URL
        let query = "query=\(keyword)&include_adult=true&language=ko-KR&page=\(page)"
        guard let url = URL(string: baseURL + query) else { return }
        
        AF.request(
            url,
            headers: headers
        ).responseDecodable(of: SearchedMovie.self) {response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func callSimilarTMDB(
        movieID: Int,
        completionHanlder: @escaping (SimilarMovies) -> Void
    ) {
        let pathParams: String = "\(movieID)/similar"
        let baseURL = Constant.Endpoint.tmdb_similar_URL
        
        guard let url = URL(string: baseURL + pathParams) else { return }
        
        AF.request(
            url,
            parameters: params,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: SimilarMovies.self) { response in
            switch response.result {
            case .success(let value):
                completionHanlder(value)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
