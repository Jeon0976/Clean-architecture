//
//  CGSize_ScaledSize.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/25.
//

import UIKit

extension CGSize {
    var scaledSize: CGSize {
        .init(width: width * UIScreen.main.scale, height: height * UIScreen.main.scale)
    }
}
