//
//  MoviesSearchViewModel.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/25.
//

import Foundation

/// Coordinator 내부에 있는 화면 전환 메서드들 즉, private 메서드들을 나타내고 있습니다.
struct MoviesSearchViewModelActions {
    
    /// `MoviesSearchFlowCoordinator`의 `showMovieDetails(movie: MovieWhenSearch)` 메서드를 의미합니다.
    let showMovieDetails: (MovieWhenSearch) -> Void
    
    /// `MoviesSearchFlowCoordinator`의 `showMovieQueriesSuggestions(didSelect: @escaping MoviesQueryListViewModelDidSelectAction)` 메서드를 의미합니다.
    let showMovieQueriesSuggestions: (@escaping (_ disSelect: MovieQuery) -> Void) -> Void
    
    /// `MoviesSearchFlowCoordinator`의 `closeMovieQueriesSuggestions()` 메서드를 의미합니다.
    let closeMovieQueriesSuggestions: () -> Void
}

enum MoviesSearchViewModelLoading {
    case fullScreen
    case nextPage
}

protocol MoviesSearchviewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func didCancelSearch()
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
    func didSelectItem(at index: Int)
}

protocol MoviesSearchViewModelOutput {
    var items: Observable<[MoviesListItemViewModel]> { get }
    var loading: Observable<MoviesSearchViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

typealias MoviesSearchViewModel = MoviesSearchviewModelInput & MoviesSearchViewModelOutput

final class DefaultMoviesSearchViewModel: MoviesSearchViewModel {
    
    private let searchMoviesUseCase: SearchMoviesUseCase!
    private let actions: MoviesSearchViewModelActions!
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage}
    
    private var pages: [MoviesSearchPage] = []
    private var moviesLoadTask: Cancellable? { willSet { moviesLoadTask?.cancel() } }
    private let mainQueue: DispatchQueueType
    
    // MARK: Output
    var items: Observable<[MoviesListItemViewModel]> = Observable([])
    var loading: Observable<MoviesSearchViewModelLoading?> = Observable(.none)
    var query: Observable<String> = Observable("")
    var error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Movies", comment: "")
    
    // MARK: Init
    init(
        searchMoviesUseCase: SearchMoviesUseCase,
        actions: MoviesSearchViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }

    // MARK: Private
    private func appendPage(_ moviesPage: MoviesSearchPage){
        currentPage = moviesPage.page
        totalPageCount = moviesPage.totalPages
        
        pages = pages
            .filter { $0.page != moviesPage.page }
            + [moviesPage]
        
        items.value = pages.movies.map(MoviesListItemViewModel.init)
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
    }
    
    private func load(
        movieQuery: MovieQuery,
        loading: MoviesSearchViewModelLoading
    ) {
        self.loading.value = loading
        query.value = movieQuery.query
        
        moviesLoadTask = searchMoviesUseCase.execute(
            requestValue: .init(query: movieQuery, page: nextPage),
            cached: { [weak self] page in
                self?.mainQueue.async {
                    self?.appendPage(page)
                }
            },
            completion: { [weak self] result in
                self?.mainQueue.async {
                    switch result {
                    case .success(let page):
                        self?.appendPage(page)
                    case .failure(let error):
                        self?.handle(error: error)
                    }
                    self?.loading.value = .none
                }
            })
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading movies", comment: "")
    }
    
    private func update(movieQuery: MovieQuery) {
        resetPages()
        load(movieQuery: movieQuery, loading: .fullScreen)
    }
}

// MARK: Input. View Event methods
extension DefaultMoviesSearchViewModel {
    func viewDidLoad() {
        
    }
    
    func didLoadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        load(movieQuery: .init(query: query.value), loading: .nextPage)
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(movieQuery: MovieQuery(query: query))
    }
    
    func didCancelSearch() {
        moviesLoadTask?.cancel()
    }
    
    func showQueriesSuggestions() {
        actions?.showMovieQueriesSuggestions(update(movieQuery:))
    }
    
    func closeQueriesSuggestions() {
        actions?.closeMovieQueriesSuggestions()
    }
    
    func didSelectItem(at index: Int) {
        actions?.showMovieDetails(pages.movies[index])
    }
}

// MARK: private
private extension Array where Element == MoviesSearchPage {
    var movies: [MovieWhenSearch] { flatMap { $0.movies }}
}
