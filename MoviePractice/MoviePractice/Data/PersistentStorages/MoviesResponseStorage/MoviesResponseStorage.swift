//
//  MoviesResponseStorage.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

protocol MoviesResponseStorage {
    func getResponse(
    for request: MoviesSearchRequestDTO,
    completion: @escaping (Result<MoviesSearchResponseDTO?, Error>) -> Void)
    
    func save(
        response: MoviesSearchResponseDTO,
        for requestDTO: MoviesSearchRequestDTO
    )
}
