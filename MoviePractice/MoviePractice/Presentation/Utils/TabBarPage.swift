//
//  TabBarPage.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/31.
//

import Foundation

enum TabBarPage {
    case search
    case popular
    case myPage
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .search
        case 1:
            self = .popular
        case 2:
            self = .myPage
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .search:
            return "Search"
        case .popular:
            return "Popular"
        case .myPage:
            return "MyPage"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .search:
            return 0
        case .popular:
            return 1
        case .myPage:
            return 2
        }
    }
}
