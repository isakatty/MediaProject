//
//  Observable.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/10/24.
//

import Foundation

final class Observable<T> {
    var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        // bind 함수의 매개변수로 closure를 받고
//        closure(value)
        self.closure = closure
    }
    
    /// 생성되자마자 didSet이 필요한 경우 사용
    func onNext(_ closure: @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
}
