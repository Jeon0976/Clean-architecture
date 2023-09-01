//
//  PosterImagesRepository.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/08/31.
//

import Foundation

protocol PosterImagesRepository {
    func fetchImage(
        with imagePath: String,
        width: Int,
        compltion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable?
}
