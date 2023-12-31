//
//  DefaultMoviesSearchRepository.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

final class DefaultMoviesSearchRepository {
    private let dataTransferService: DataTransferService
    private let cache: MoviesResponseStorage
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        cache: MoviesResponseStorage,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.cache = cache
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultMoviesSearchRepository: MoviesSearchRepository {
    func fetchMoviesList(
        query: MovieQuery,
        page: Int,
        cached: @escaping (MoviesSearchPage) -> Void,
        completion: @escaping (Result<MoviesSearchPage, Error>) -> Void
    ) -> Cancellable? {
        let requestDTO = MoviesSearchRequestDTO(
            query: query.query,
            page: page
        )
        let task = RepositoryTask()
        
        cache.getResponse(for: requestDTO) { [weak self, backgroundQueue] result in
            if case let .success(responeDTO?) = result {
                cached(responeDTO.toDomain())
            }
            
            guard !task.isCancelled else { return }
            
            let endPonit = APIEndpoints.getSearchMovies(with: requestDTO)
            task.networkTask = self?.dataTransferService.request(
                with: endPonit,
                on: backgroundQueue) { result in
                switch result {
                case .success(let responseDTO):
                    self?.cache.save(
                        response: responseDTO,
                        for: requestDTO
                    )
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
}
