//
//  MemoDetailViewModel.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/14/24.
//

import Foundation

final class MemoDetailViewModel {
    var memoInfo: MovieMemo?
    
    // load되면서 메모 내용 넣어주기
    var inputViewDidLoad = Observable<Void?>(nil)
    
    // btn Trigger
    var inputDateTrigger = Observable<Void?>(nil)
    var inputTagTrigger = Observable<Void?>(nil)
    
    var outputMovieMemo = Observable<MovieMemo?>(nil)
    
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
                print("메모 없이 들어오면 어떻게 해야할까 ?")
                self.outputMovieMemo.value = nil
            }
        }
        inputDateTrigger.bind { [weak self] _ in
            guard let self else { return }
            
            
        }
        inputTagTrigger.bind { [weak self] _ in
            guard let self else { return }
            
            
        }
    }
}
