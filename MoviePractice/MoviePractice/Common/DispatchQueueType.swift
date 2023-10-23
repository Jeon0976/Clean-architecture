//
//  DispatchQueueType.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

// dataTrnasfer Service랑 뭐가 다른걸까?
protocol DispatchQueueType {
    func async(execute work: @escaping () -> Void)
}

extension DispatchQueue: DispatchQueueType {
    func async(execute work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }
}
