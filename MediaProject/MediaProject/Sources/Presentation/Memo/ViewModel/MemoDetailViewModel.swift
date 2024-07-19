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
    var calendarSelectedDate: Date?
    
    // load되면서 메모 내용 넣어주기
    var inputViewDidLoad = Observable<Void>(())
    
    // btn Trigger
    var inputDateTrigger = Observable<Void>(())
    var inputTagTrigger = Observable<Void>(())
    var inputSearchMovieTrigger = Observable<Void>(())
    var inputSaveTrigger = Observable<(MovieMemo?, Movie?)>((nil, nil))
    var inputAlertTrigger = Observable<Void>(())
    
    private(set) var outputMovieMemo = Observable<MovieMemo?>(nil)
    private(set) var outputSearchMovie = Observable<Void>(())
    private(set) var selectedMovie = Observable<Movie?>(nil)
    private(set) var outputSelectedDateBtn = Observable<Void>(())
    private(set) var outputSelectedTagBtn = Observable<Void>(())
    
    // 이렇게 output이 많아져도 괜찮은가 ?
    private(set) var outputTagString = Observable<String?>(nil)
    private(set) var outputDate = Observable<Date?>(nil)
    private(set) var outputDismissTrigger = Observable<Void?>(nil)
    private(set) var outputAlert = Observable<Void>(())
    
    init(
        memoInfo: MovieMemo? = nil,
        calendarSelected: Date? = nil
    ) {
        self.memoInfo = memoInfo
        self.calendarSelectedDate = calendarSelected
        
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
        if memoInfo == nil {
            inputSearchMovieTrigger.bind { [weak self] _ in
                guard let self else { return }
                
                self.outputSearchMovie.value = () // 화면 트리거
            }
        }
        inputSaveTrigger.onNext { [weak self] (memo, movie) in
            guard let self = self else { return }
            if let memo = memo, let movie = movie {
                if self.calendarSelectedDate == nil {
                    self.calendarSelectedDate = Date()
                }
                guard let calendarSelectedDate = self.calendarSelectedDate else { return }
                memo.regDate = calendarSelectedDate
                
                let (isMovieExist, existingMovie) = MovieRepository.shared.findMovie(movieId: movie.id)
                
                if isMovieExist, let regMovie = existingMovie {
                    if regMovie.memo.contains(where: { $0.id == memo.id}) {
                        MovieRepository.shared.updateMemo(movie: regMovie, memo: memo)
                    } else {
                        MovieRepository.shared.addMemoToMovie(movie: regMovie, memo: memo)
                    }
                } else {
                    movie.memo.append(memo)
                    MovieRepository.shared.createMovieWithMemo(movie: movie)
                }
            }
            self.outputDismissTrigger.value = ()
        }
        inputAlertTrigger.bind { [weak self] _ in
            guard let self else { return }
            
            self.outputAlert.value = ()
        }
    }
}

extension MemoDetailViewModel: PassMovieResponse {
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
        outputDate.value = date
    }
    func passTag(tag: String?) {
        outputTagString.value = tag
    }
}
