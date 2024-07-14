//
//  String+.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/14/24.
//

import Foundation

extension String {
    // tag 변환
    func addHashTag() -> String {
        var hashTags = [String]()
        hashTags = self.split(separator: " ").map { "#\($0)" }
        hashTags = Array(Set(hashTags))
        return hashTags.joined(separator: " ")
    }
}
