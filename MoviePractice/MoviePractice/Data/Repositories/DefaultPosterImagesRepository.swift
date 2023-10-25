//
//  DefaultPosterImagesRepository.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

final class DefaultPosterImagesRepository {
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

extension DefaultPosterImagesRepository: PosterImagesRepository {
    func fetchImage(
        with imagePath: String,
        width: Int,
        compltion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable? {
        let endPoint = APIEndpoints.getMoviePoster(
            path: imagePath,
            width: width
        )
        let task = RepositoryTask()
        task.networkTask = dataTransferService.request(
            with: endPoint,
            on: backgroundQueue
        ) { (result: Result<Data, DataTransferError>) in
            let result = result.mapError { $0 as Error }
            compltion(result)
        }
        
        return task
    }
}
