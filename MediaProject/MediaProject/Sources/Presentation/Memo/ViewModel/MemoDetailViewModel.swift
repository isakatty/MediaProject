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
    var inputViewDidLoad = Observable<Void?>(nil)
    
    // btn Trigger
    var inputDateTrigger = Observable<Void?>(nil)
    var inputTagTrigger = Observable<Void?>(nil)
    var inputSearchMovieTrigger = Observable<Void?>(nil)
    var inputSaveTrigger = Observable<(MovieMemo?, Movie?)>((nil, nil))
    
    var outputMovieMemo = Observable<MovieMemo?>(nil)
    var outputSearchMovie = Observable<Void?>(nil)
    var selectedMovie = Observable<Movie?>(nil)
    var outputSelectedDateBtn = Observable<Void?>(nil)
    var outputSelectedTagBtn = Observable<Void?>(nil)
    
    // 이렇게 output이 많아져도 괜찮은가 ?
    var outputTagString = Observable<String?>(nil)
    var outputDate = Observable<Date?>(nil)
    var outputDismissTrigger = Observable<Void?>(nil)
    
    init(memoInfo: MovieMemo? = nil, calendarSelected: Date? = nil) {
        self.memoInfo = memoInfo
        self.calendarSelectedDate = calendarSelected
        
        print("DetailVM", calendarSelectedDate)
        
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
        inputSaveTrigger.onNext { [weak self] (memo, movie) in
            guard let self = self else { return }
            if var memo = memo, let movie = movie {
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
