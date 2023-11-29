//
//  MoviesTopRatedViewModel.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/10.
//

import Foundation

struct MoviesTopRatedViewModelActions {
//    let showMovieDetails: (MovieWhenSearch) -> Void
}

protocol MoviesTopRatedModelInput: AnyObject {
    var items: Observable<[MoviesTopRatedCollectionItemViewModel]> { get }
    var detailTextShownStates: Observable<[IndexPath: Bool]> { get }
    var loading: Observable<MoviesTopRatedModelLoading?> { get }
    var error: Observable<String> { get }
    var isResetCompleted: Observable<Bool> { get }
}

protocol MoviesTopRatedModelOutput: AnyObject {
    func viewDidLoad()
    func reset()
    func didLoadNextPage()
    func didSelectedCell(_ indexPath: IndexPath)
}

enum MoviesTopRatedModelLoading {
    case fullScreen
    case nextPage
}

typealias MoviesTopRatedViewModel = MoviesTopRatedModelInput & MoviesTopRatedModelOutput

final class DefaultMoviesTopRatedViewModel: MoviesTopRatedViewModel {
    
    private let topRatedMoviesUseCase: TopRatedMoviesUseCase!
    private let actions: MoviesTopRatedViewModelActions!
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    var isResetCompleted: Observable<Bool> = Observable(false)

    private var pages: [MoviesTopRatedPage] = []
    private var moviesLoadTask: Cancellable? { willSet { moviesLoadTask?.cancel() } }
    private let mainQueue: DispatchQueueType
    
    var items: Observable<[MoviesTopRatedCollectionItemViewModel]> = Observable([])
    var detailTextShownStates: Observable<[IndexPath: Bool]> = Observable([:])
    var loading: Observable<MoviesTopRatedModelLoading?> = Observable(.none)
    var error: Observable<String> = Observable("")
    
    init(
        topRatedMoviesUseCase: TopRatedMoviesUseCase,
        actions: MoviesTopRatedViewModelActions,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.topRatedMoviesUseCase = topRatedMoviesUseCase
        self.actions = actions
        self.mainQueue = mainQueue
        
        print("Default Movies Top Rated View Model")
    }
    
    deinit {
        print("TopRated Deinit")
    }
    
    private func update() {
        resetPages()
        load(loading: .fullScreen)
    }
    
    private func load(loading: MoviesTopRatedModelLoading) {
        self.loading.value = loading
        
        moviesLoadTask = topRatedMoviesUseCase.execute(
            requestValue: .init(page: nextPage),
            completion: { [weak self] result in
                self?.mainQueue.async {
                    switch result {
                    case .success(let page):
                        self?.appendPage(page)
                    case .failure(let error):
                        self?.handle(error: error)
                    }
                    self?.loading.value = .none
                    self?.isResetCompleted.value = true
                }
        })
    }
    
    private func appendPage(_ moviesPage: MoviesTopRatedPage) {
        currentPage = moviesPage.page
        totalPageCount = moviesPage.totalPages
        
        pages = pages.filter { $0.page != moviesPage.page } + [moviesPage]
        
        items.value = pages.movies.map(MoviesTopRatedCollectionItemViewModel.init)
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
        detailTextShownStates.value.removeAll()
    }
        
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading movies", comment: "")
    }
}

// MARK: Input, View Event methods
extension DefaultMoviesTopRatedViewModel {
    func viewDidLoad() {
        update()
    }
    
    func reset() {
        isResetCompleted.value = false
        update()
    }
    
    func didLoadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        load(loading: .nextPage)
    }
    
    func didSelectedCell(_ indexPath: IndexPath) {
        let currentState = detailTextShownStates.value[indexPath] ?? false
        
        detailTextShownStates.value[indexPath] = !currentState
    }
}

// MARK: private
private extension Array where Element == MoviesTopRatedPage {
    var movies: [MovieWhenTopRated] { flatMap { $0.movies }}
}
