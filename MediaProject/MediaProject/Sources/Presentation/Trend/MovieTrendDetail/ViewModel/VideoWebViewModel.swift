//
//  VideoWebViewModel.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

final class VideoWebViewModel {
    var urlString: String
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var outputWebView: Observable<String> = Observable("")
    
    init(urlString: String) {
        self.urlString = urlString
        print(#function, urlString)
        transform()
    }
    
    private func transform() {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            guard let self else { return }
            self.outputWebView.value = urlString
            print(self.outputWebView.value, "🩶")
        }
    }
    
}
