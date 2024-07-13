//
//  MemoCalendarViewModel.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/14/24.
//

import Foundation

final class MemoCalendarViewModel {
    private let date = Date()
    // viewDidLoad되면서 메모 fetch해서 메모를 VC에 전달해줘야함
    var inputViewDidLoad = Observable<Void?>(nil)
    var movieBtnTrigger = Observable<Void?>(nil) // 메모 label trigger
    var inputDateTrigger = Observable<Date?>(nil) // 캘린더 날짜 선택
    
    var outputDates = Observable<[Date]?>(nil)
    var outputTodaysMemo = Observable<Movie?>(nil)
    var outputMemoDetail = Observable<Void?>(nil) // 화면 전환용
    
    init() {
        transform()
    }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] _ in
            // 데이터 fetch ~
            guard let self else { return }
        }
        movieBtnTrigger.bind { [weak self] _ in
            guard let self else { return }
            outputMemoDetail.value = ()
        }
    }
    
    private func fetchMemo() {
//        let repository = MovieRepository
    }
}
