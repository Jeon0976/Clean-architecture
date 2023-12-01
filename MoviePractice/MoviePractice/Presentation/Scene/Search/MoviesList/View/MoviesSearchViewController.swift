//
//  MoviesListViewController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/25.
//

import UIKit

final class MoviesSearchViewController: UIViewController, Alertable {
    
    /// - 강제 옵셔널를 사용하여 뷰 컨트롤러가 기능하는 데 중요한 역할을 함을 명확하게 표현합니다.
    /// - 이 방법은 `viewModel`의 중요성을 강조하고, 실수로 `nil`을 할당하는 것을 방지하는 데 도움이 될 수 있습니다.
    private var viewModel: MoviesSearchViewModel!
    private var posterImagesUseCase: PosterImagesUseCase?
    private var moviesTableViewController: MoviesListTableViewController?
    
    private let disposeBag = DisposeBag()
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var moviesListContainer: UIView = {
        let view = UIView()
        
        moviesTableViewController = MoviesListTableViewController.create(with: viewModel, posterImagesUseCase: posterImagesUseCase)
        
        if let movies = moviesTableViewController {
            movies.view.backgroundColor = .white
            add(child: movies, container: view)
            view.addSubview(movies.view)
        }
        
        return view
    }()
    
    private(set) lazy var suggestionsListContainer: UIView = {
        let view = UIView()

        return view
    }()
    
    private lazy var searchBarContainer: UIView = {
        let view = UIView()
        
        view.addSubview(searchController.searchBar)
        
        return view
    }()
    
    private lazy var emptyDataLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    // MARK: Lifecycle
    
    /// `ViewController`의 생성을 Static 메서드를 활용해서 생성 로직을 DIContainer에 중앙화 할 수 있습니다.
    /// - Parameter viewModel: `MoviesSearchViewController`가 사용할 뷰 모델, 이 뷰 모델은 로그인 관련 로직을 처리하는 데 사용됩니다.
    /// - Parameter posterImagesRepostiory: `MoviesListItemCell`에서 사용할 Repository입니다.
    /// - Returns: 초기화된 `MoviesSearchViewController` 인스턴스를 반환합니다.
    static func create(
        with viewModel: MoviesSearchViewModel,
        posterImagesUseCase: PosterImagesUseCase?
    ) -> MoviesSearchViewController {
        let view = MoviesSearchViewController()
        view.viewModel = viewModel
        view.posterImagesUseCase = posterImagesUseCase
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupSearchController()
    }
    
    // MARK: Private
    
    private func setupView() {
        emptyDataLabel.text = viewModel.emptyDataTitle
        self.view.backgroundColor = .white
        
        [
            emptyDataLabel,
            searchBarContainer,
            moviesListContainer,
            suggestionsListContainer
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            searchBarContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBarContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBarContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchBarContainer.heightAnchor.constraint(equalToConstant: 56),
            
            moviesListContainer.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor, constant: 0),
            moviesListContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            moviesListContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            moviesListContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            suggestionsListContainer.topAnchor.constraint(equalTo: moviesListContainer.topAnchor),
            suggestionsListContainer.leadingAnchor.constraint(equalTo: moviesListContainer.leadingAnchor),
            suggestionsListContainer.trailingAnchor.constraint(equalTo: moviesListContainer.trailingAnchor),
            suggestionsListContainer.bottomAnchor.constraint(equalTo: moviesListContainer.bottomAnchor),
            
            emptyDataLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emptyDataLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func bind(to viewModel: MoviesSearchViewModel) {
        viewModel.items
            .subscribe(on: self, disposeBag: disposeBag)
            .onNext { [weak self] _ in
            self?.updateTimes()
        }
        
        viewModel.loading
            .subscribe(on: self, disposeBag: disposeBag)
            .onNext { [weak self] in
            self?.updateLoading($0)
        }
        
        viewModel.query
            .subscribe(on: self, disposeBag: disposeBag)
            .onNext { [weak self] in
            self?.updateSearchQuery($0)
        }
        
        viewModel.error
            .subscribe(on: self, disposeBag: disposeBag)
            .onNext { [weak self] in
            self?.showError($0)
        }
    }
    
    private func updateTimes() {
        moviesTableViewController?.reload()
    }
    
    private func updateLoading(_ loading: MoviesSearchViewModelLoading?) {
        emptyDataLabel.isHidden = true
        moviesListContainer.isHidden = true
        suggestionsListContainer.isHidden = true
        LoadingView.hide()
        
        switch loading {
        case .fullScreen:
            LoadingView.show()
        case .nextPage:
            moviesListContainer.isHidden = false
        case .none:
            moviesListContainer.isHidden = viewModel.isEmpty
            emptyDataLabel.isHidden = !viewModel.isEmpty
        }
        
        moviesTableViewController?.updateLoading(loading)
        updateQueriesSuggestions()
    }
    
    private func updateQueriesSuggestions() {
        guard searchController.searchBar.isFirstResponder else {
            viewModel.closeQueriesSuggestions()
            return
        }
        viewModel.showQueriesSuggestions()
    }
    
    private func updateSearchQuery(_ query: String) {
        searchController.isActive = false
        searchController.searchBar.text = query
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
}

// MARK: Search Controller
extension MoviesSearchViewController {
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "추가"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barStyle = .default
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        definesPresentationContext = true
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.accessibilityIdentifier = Identifier.searchField
        }
    }
}

extension MoviesSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel.didSearch(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

extension MoviesSearchViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }
}
