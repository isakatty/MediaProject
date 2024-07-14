//
//  MovieMemo.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

import RealmSwift

final class MovieMemo: Object {
    @Persisted(primaryKey: true) var id: ObjectId // PK
    @Persisted var title: String // meme title
    @Persisted var content: String? // memo body
    @Persisted var tag: String?
    @Persisted var regDate: Date // registration date
    @Persisted var watchedDate: Date? // watched movie date
    
    @Persisted(originProperty: "memo") var movie: LinkingObjects<Movie>
    
    convenience init(
        title: String,
        content: String? = nil,
        tag: String? = nil,
        watchedDate: Date? = nil
    ) {
        self.init()
        self.title = title
        self.content = content
        self.tag = tag
        self.regDate = Date()
        self.watchedDate = watchedDate
    }
}
