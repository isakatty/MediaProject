//
//  MemoDateViewModel.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/14/24.
//

import Foundation

final class MemoDateViewModel {
    var date: Date?
    weak var delegate: PassMovieResponse?
    
    var inputViewDidLoad = Observable<Void?>(nil)
    var inputDatePickerTrigger = Observable<Date?>(nil)
    var inputBackBtnTrigger = Observable<Void?>(nil)
    
    var outputSelectedDate = Observable<Date?>(nil)
    var outputBackBtnAction = Observable<Void?>(nil)
    
    init(date: Date? = nil) {
        self.date = date
        
        transform()
    }
    
    private func transform() {
        inputViewDidLoad.onNext { [weak self] _ in
            guard let self else { return }
            
            if let date {
                print(date)
                self.outputSelectedDate.value = date
            } else {
                outputSelectedDate.value = nil
            }
        }
        inputDatePickerTrigger.bind { [weak self] selectedDate in
            guard let self, let selectedDate else { return }
        
            self.outputSelectedDate.value = selectedDate
        }
        inputBackBtnTrigger.bind { [weak self] _ in
            guard let self else { return }
            
            self.outputBackBtnAction.value = ()
        }
    }
    
}
