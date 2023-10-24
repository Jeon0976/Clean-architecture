//
//  CoreDataMoviesResponseStorage.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation
import CoreData

final class CoreDataMoviesResponseStorage {
    private let coreDataStorage: CoreDataStorage
    
    init(
        coreDataStorage: CoreDataStorage = CoreDataStorage.shared
    ) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: Private
    /// 설명 필요
    private func fetchRequest(for requestDTO: MoviesRequestDTO) -> NSFetchRequest<MoviesRequestEntity> {
        let request: NSFetchRequest = MoviesRequestEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = $@ AND %K = %d",
            #keyPath(MoviesRequestEntity.query),
            requestDTO.query,
            #keyPath(MoviesRequestEntity.page),
            requestDTO.page
        )
        
        return request
    }
    
    private func deleteResponse(
        for requestDTO: MoviesRequestDTO,
        in context: NSManagedObjectContext
    ) {
        let request = fetchRequest(for: requestDTO)
        
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension CoreDataMoviesResponseStorage: MoviesResponseStorage {
    func getResponse(for request: MoviesRequestDTO, completion: @escaping (Result<MoviesResponseDTO?, Error>) -> Void) {
        coreDataStorage.perfromBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: request)
                let requestEntity = try context.fetch(fetchRequest).first
                
                completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func save(
        response: MoviesResponseDTO,
        for requestDTO: MoviesRequestDTO) {
        coreDataStorage.perfromBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDTO, in: context)
                
                let requestEntity = requestDTO.toEntity(in: context)
                requestEntity.response = response.toEntity(in: context)
                
                try context.save()
            } catch {
                debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
