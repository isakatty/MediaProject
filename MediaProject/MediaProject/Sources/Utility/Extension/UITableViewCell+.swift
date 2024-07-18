//
//  UITableViewCell+.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/6/24.
//

import UIKit

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable { }
extension UITableViewHeaderFooterView: Reusable { }
