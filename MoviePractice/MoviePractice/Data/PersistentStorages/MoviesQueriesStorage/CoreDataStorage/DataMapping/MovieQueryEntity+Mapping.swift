//
//  MovieQueryEntity+Mapping.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation
import CoreData

// TODO: 뭘까? 왜 MovieQueryEntity만 설정을 하는걸까?
extension MovieQueryEntity {
    convenience init(movieQuery: MovieQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        query = movieQuery.query
        createdAt = Date()
    }
}

extension MovieQueryEntity {
    func toDomain() -> MovieQuery {
        return .init(query: query ?? "")
    }
}
