//
//  UILabel+.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/24/24.
//

import UIKit

extension UILabel {
    func makeLabel(text: String?) -> UILabel {
        let label = UILabel()
        label.font = Constant.Font.bold23
        label.textColor = UIColor.black
        label.text = text
        return label
    }
    func makeLabel(font: UIFont, text: String?) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = UIColor.black
        label.text = text
        return label
    }
}
