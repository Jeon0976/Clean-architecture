//
//  TabBarPage.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/31.
//

import Foundation

enum TabBarPage {
    case search
    case topRated
    case nowPlaying
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .search
        case 1:
            self = .topRated
        case 2:
            self = .nowPlaying
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .search:
            return "Search"
        case .topRated:
            return "Popular"
        case .nowPlaying:
            return "MyPage"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .search:
            return 0
        case .topRated:
            return 1
        case .nowPlaying:
            return 2
        }
    }
}
