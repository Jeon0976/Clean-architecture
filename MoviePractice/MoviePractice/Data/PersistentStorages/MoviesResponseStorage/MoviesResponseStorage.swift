//
//  MoviesResponseStorage.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

protocol MoviesResponseStorage {
    func getResponse(
    for request: MoviesRequestDTO,
    completion: @escaping (Result<MoviesResponseDTO?, Error>) -> Void)
    
    func save(
        response: MoviesResponseDTO,
        for requestDTO: MoviesRequestDTO
    )
}
