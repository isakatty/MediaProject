//
//  TrendDetailViewModel.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/11/24.
//

import Foundation

final class TrendDetailViewModel {
    let movieInfo: MovieResponseDTO
    
    /// viewDidLoad될 때 감지 센서
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    /// TMDB API 통신 완료 감지 센서
    var catchedDataFetch: Observable<Bool> = Observable(false)
    
    var outputSectionItems: Observable<[Int]> = Observable(.init(repeating: 1, count: SectionKind.allCases.count))
    var outputSectionDatas: Observable<[TrendCollection]> = Observable([
        TrendCollection(
            actorInfo: [CastResponseDTO.init(
                adult: true,
                id: 1,
                name: "",
                original_name: "",
                profile_path: "",
                character: ""
            )],
            poster: nil,
            similar: nil
        ),
        TrendCollection.init(
            actorInfo: nil,
            poster: [PosterPath(file_path: "")],
            similar: nil
        ),
        TrendCollection.init(similar: [TrendInfo.init(poster_path: "")])
    ])
    
    init(movieInfo: MovieResponseDTO) {
        self.movieInfo = movieInfo
        
        transform(movieInfo: movieInfo)
    }
    
    private func transform(movieInfo: MovieResponseDTO) {
        // input의 bind를 통해 초기값
        inputViewDidLoadTrigger.bind { _ in
            self.requestDetails(movieId: movieInfo.id)
        }
    }
    
    private func requestDetails(movieId: Int) {
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async {
            NetworkService.shared.callTMDB(
                endPoint: .trendDetail(movieId: String(movieId)),
                type: MovieCreditResponse.self
            ) { [weak self] cast, error in
                if let error {
                    print("cast - error가 있다 !", error)
                } else {
                    guard let self else { return }
                    guard let cast else {
                        print("NetworkService - similar movies X")
                        return
                    }
                    self.outputSectionDatas.value[0] = TrendCollection(
                        actorInfo: cast.toDTO.cast,
                        poster: nil,
                        similar: nil
                    )
                    outputSectionItems.value[1] = cast.toDTO.cast.count
                }
                group.leave()
            }
        }
        group.enter()
        DispatchQueue.global().async {
            NetworkService.shared.callTMDB(
                endPoint: .images(movieId: String(movieId)),
                type: Poster.self
            ) { [weak self] files, error in
                if let error {
                    print("similar - error가 있다 !", error)
                } else {
                    guard let self else { return }
                    guard let files else {
                        print("NetworkService - similar movies X")
                        return
                    }
                    self.outputSectionDatas.value[1] = TrendCollection(
                        actorInfo: nil,
                        poster: files.backdrops,
                        similar: nil
                    )
                    outputSectionItems.value[2] = files.backdrops.count
                }
                group.leave()
            }
        }
        group.enter()
        DispatchQueue.global().async {
            NetworkService.shared.callTMDB(
                endPoint: .recommends(movieId: String(movieId)),
                type: TrendMovies.self
            ) { [weak self] movies, error in
                if let error {
                    print("Recommend - error가 있다 !", error)
                } else {
                    guard let self else { return }
                    guard let movies else {
                        print("NetworkService - similar movies X")
                        return
                    }
                    self.outputSectionDatas.value[2] = TrendCollection(
                        actorInfo: nil,
                        poster: nil,
                        similar: movies.results
                    )
                    outputSectionItems.value[3] = movies.results.count
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("여기까지 옴")
            self.catchedDataFetch.value = true
        }
    }
}
