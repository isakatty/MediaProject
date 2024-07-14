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
    
    var outputTag = Observable<String?>(nil)
    
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
    }
    
}
