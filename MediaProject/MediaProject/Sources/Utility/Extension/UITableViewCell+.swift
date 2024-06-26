//
//  UITableViewCell+.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/6/24.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: self)
    }
}
