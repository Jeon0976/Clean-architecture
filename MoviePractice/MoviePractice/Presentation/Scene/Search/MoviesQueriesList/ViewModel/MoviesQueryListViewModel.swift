//
//  MoviesQueryListViewModel.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/26.
//

import Foundation

typealias MoviesQueryListViewModelDidSelectAction = (MovieQuery) -> Void

protocol MoviesQueryListViewModelInput {
    func viewWillAppear()
    func didSelect(item: MoviesQueryListItemViewModel)
}

protocol MoviesQueryListViewModelOutput {
    var items: Observable<[MoviesQueryListItemViewModel]> { get }
 }

typealias MoviesQueryListViewModel =  MoviesQueryListViewModelInput & MoviesQueryListViewModelOutput

typealias FetchRecentMovieQueriesUseCaseFactory = (FetchRecentMovieQueriesUseCase.RequestValue, @escaping (FetchRecentMovieQueriesUseCase.ResultValue) -> Void) -> UseCase

final class DefaultMoviesQueryListViewModel: MoviesQueryListViewModel {
    private let numberOfQueriesToShow: Int
    private let fetchRecentMovieQueriesUseCaseFactory: FetchRecentMovieQueriesUseCaseFactory
    private let didSelect: MoviesQueryListViewModelDidSelectAction
    private let mainQueue: DispatchQueueType
    
    // MARK: Output
    let items: Observable<[MoviesQueryListItemViewModel]> = Observable([])
    
    init(
        numberOfQueriesToShow: Int,
        fetchRecentMovieQueriesUseCaseFactory: @escaping FetchRecentMovieQueriesUseCaseFactory,
        didSelect:  @escaping MoviesQueryListViewModelDidSelectAction,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.numberOfQueriesToShow = numberOfQueriesToShow
        self.fetchRecentMovieQueriesUseCaseFactory = fetchRecentMovieQueriesUseCaseFactory
        self.didSelect = didSelect
        self.mainQueue = mainQueue
    }
    
    private func updateMoviesQueries() {
        let request = FetchRecentMovieQueriesUseCase.RequestValue(maxCount: numberOfQueriesToShow)
        
        let completion: (FetchRecentMovieQueriesUseCase.ResultValue) -> Void = { [weak self] result in
            self?.mainQueue.async {
                switch result {
                case .success(let items):
                    self?.items.value = items
                        .map { $0.query }
                        .map(MoviesQueryListItemViewModel.init)
                case .failure:
                    break
                }
            }
        }
        
        let useCase = fetchRecentMovieQueriesUseCaseFactory(request, completion)
        
        useCase.start()
    }
}

extension DefaultMoviesQueryListViewModel {
    func viewWillAppear() {
        updateMoviesQueries()
    }
    
    func didSelect(item: MoviesQueryListItemViewModel) {
        didSelect(MovieQuery(query: item.query))
    }
}
