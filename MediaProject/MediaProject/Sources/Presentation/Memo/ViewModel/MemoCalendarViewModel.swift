//
//  MemoCalendarViewModel.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/14/24.
//

import Foundation

final class MemoCalendarViewModel {
    // 오늘자 날짜
    private let today = Date()
    // viewDidLoad되면서 메모 fetch해서 메모를 VC에 전달해줘야함
    var inputViewDidLoad = Observable<Void?>(nil)
    var movieBtnTrigger = Observable<Void?>(nil) // 메모 label trigger
    var inputDateTrigger = Observable<Date?>(nil) // 캘린더 날짜 선택
    var inputViewWillAppear = Observable<Void?>(nil)
    
    var outputDates = Observable<[Date]?>(nil)
    var outputMovieMemo = Observable<MovieMemo?>(nil)
    var outputMemoDetail = Observable<Void?>(nil) // 화면 전환용
    var outputSelectedDate = Observable<Date>(Date())
    
    init() {
        transform()
    }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            let movies = self.fetchMovies()
            self.outputDates.value = setDates(movies: movies)
            self.outputMovieMemo.value = MovieRepository.shared.findMemoFromDate(selectedDate: self.today).first
        }
        inputDateTrigger.bind { [weak self] date in
            guard let date,
                  let self else { return }
            
            outputSelectedDate.value = date
            self.outputMovieMemo.value = MovieRepository.shared.findMemoFromDate(selectedDate: date).first
        }
        movieBtnTrigger.bind { [weak self] _ in
            guard let self else { return }
            outputMemoDetail.value = ()
        }
        inputViewWillAppear.bind { [weak self] _ in
            guard let self else { return }
            let movies = self.fetchMovies()
            self.outputDates.value = setDates(movies: movies)
            self.outputMovieMemo.value = MovieRepository.shared.findMemoFromDate(selectedDate: self.outputSelectedDate.value).first
        }
    }
    
    private func fetchMovies() -> [Movie] {
        let fetchedMovies = MovieRepository.shared.readMovies()
        return fetchedMovies
    }
    private func setDates(movies: [Movie]) -> [Date] {
        var dates = [Date]()
        
        dates = movies.flatMap { $0.memo }.map { $0.regDate }
        return dates
    }
}
