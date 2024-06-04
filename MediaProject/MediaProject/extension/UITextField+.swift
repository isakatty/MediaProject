//
//  UITextField+.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/4/24.
//

import UIKit

extension UITextField {
    func setPlaceholder(color: UIColor) {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(
            string: string,
            attributes: [.foregroundColor: color]
        )
    }
}
