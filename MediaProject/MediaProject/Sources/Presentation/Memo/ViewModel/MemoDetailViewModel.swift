//
//  MemoDetailViewModel.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/14/24.
//

import Foundation

protocol PassMovieResponse: AnyObject {
    func passSelectedMovieInfo(movie: MovieResponseDTO)
    func passDate(date: Date?)
    func passTag(tag: String?)
}


final class MemoDetailViewModel {
    var memoInfo: MovieMemo?
    
    // load되면서 메모 내용 넣어주기
    var inputViewDidLoad = Observable<Void?>(nil)
    
    // btn Trigger
    var inputDateTrigger = Observable<Void?>(nil)
    var inputTagTrigger = Observable<Void?>(nil)
    var inputSearchMovieTrigger = Observable<Void?>(nil)
    
    var outputMovieMemo = Observable<MovieMemo?>(nil)
    var outputSearchMovie = Observable<Void?>(nil)
    var selectedMovie = Observable<Movie?>(nil)
    var outputSelectedDateBtn = Observable<Void?>(nil)
    var outputSelectedTagBtn = Observable<Void?>(nil)
    
    // 이렇게 output이 많아져도 괜찮은가 ?
    var outputTagString = Observable<String?>(nil)
    
    init(memoInfo: MovieMemo? = nil) {
        self.memoInfo = memoInfo
        
        tranform()
    }
    
    private func tranform() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            
            if memoInfo != nil {
                self.outputMovieMemo.value = memoInfo
            } else {
                self.outputMovieMemo.value = nil
            }
        }
        inputDateTrigger.bind { [weak self] _ in
            guard let self else { return }
            
            outputSelectedDateBtn.value = () // 화면 이동을 위한
        }
        inputTagTrigger.bind { [weak self] _ in
            guard let self else { return }
            
            outputSelectedTagBtn.value = () // 화면 이동을 위한
        }
        inputSearchMovieTrigger.bind { [weak self] _ in
            guard let self else { return }
            
            self.outputSearchMovie.value = () // 화면 트리거
        }
    }
}

extension MemoDetailViewModel: PassMovieResponse {
    // 전달 받은 웅앵..
    func passSelectedMovieInfo(movie: MovieResponseDTO) {
        selectedMovie.value = Movie(
            id: movie.id,
            title: movie.title,
            poster: movie.poster_path,
            overview: movie.overView,
            releaseDate: movie.releaseDate,
            voteAvg: movie.voteAvg,
            voteCount: movie.voteCnt
        )
    }
    // 선택 안할수도 있으니까 optional 값
    func passDate(date: Date?) {
        print(date)
    }
    func passTag(tag: String?) {
        outputTagString.value = tag
    }
}
