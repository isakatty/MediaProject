//
//  MemoTagViewModel.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/14/24.
//

import Foundation

final class MemoTagViewModel {
    var tagString: String?
    weak var delegate: PassMovieResponse?
    
    var inputViewDidLoad = Observable<Void?>(nil)
    var inputTextFieldEndEditing = Observable<Void?>(nil)
    var inputBackBtnTrigger = Observable<Void?>(nil)
    var inputSaveBtnTrigger = Observable<String?>(nil)
    
    var outputTag = Observable<String?>(nil)
    var outputDismiss = Observable<Bool>(false)
    var outputSave = Observable<String?>(nil)
    
    init(tagString: String? = nil) {
        self.tagString = tagString
        
        transform()
    }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            
            if tagString != nil {
                self.outputTag.value = tagString
            }
        }
        inputBackBtnTrigger.bind { [weak self] _ in
            guard let self else { return }
            if tagString == self.outputTag.value {
                outputDismiss.value = true
            } else {
                outputDismiss.value = false
            }
        }
        inputSaveBtnTrigger.bind { [weak self] text in
            guard let self else { return }
            
            self.outputTag.value = text
            self.outputSave.value = text
        }
        inputTextFieldEndEditing.bind { [weak self] _ in
            guard let self else { return }
            
            self.outputSave.value = nil
        }
    }
    
}
