//
//  MemoTextView.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/13/24.
//

import UIKit

final class MemoTextView: UITextView {
    
    private let padding: UIEdgeInsets
    
    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero, textContainer: nil)
        configureTextView()
    }
    
    required init?(coder: NSCoder) {
        self.padding = .zero
        super.init(coder: coder)
        configureTextView()
    }
    
    private func configureTextView() {
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.textContainerInset = padding
    }
}

