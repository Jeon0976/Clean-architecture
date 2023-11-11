//
//  DefaultMoviesTopRatedRepository.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/10.
//

import Foundation

final class DefaultMoviesTopRatedRepository {
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultMoviesTopRatedRepository: MoviesTopRatedRepository {
    func fetchMoviesList(page: Int, completion: @escaping (Result<MoviesTopRatedPage, Error>) -> Void) -> Cancellable? {
        let requestDTO = MoviesTopRateRequestDTO(page: page)
        
        let task = RepositoryTask()
        
        let endPoint = APIEndpoints.getTopRatedMovies(with: requestDTO)
        
        task.networkTask = self.dataTransferService.request(with: endPoint, on: backgroundQueue) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return task
    }
    
}
