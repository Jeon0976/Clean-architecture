//
//  MoviesListViewController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/25.
//

import UIKit

final class MoviesListViewController: UIViewController, Alertable {
    
    /// - 강제 옵셔널를 사용하여 뷰 컨트롤러가 기능하는 데 중요한 역할을 함을 명확하게 표현합니다.
    /// - 이 방법은 `viewModel`의 중요성을 강조하고, 실수로 `nil`을 할당하는 것을 방지하는 데 도움이 될 수 있습니다.
    private var viewModel: MoviesListViewModel!
    private var posterImagesRepository: PosterImagesRepository?
    private var moviesTableViewController: MoviesListTableViewController?
    
    private let disposeBag = DisposeBag()
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var moviesListContainer: UIView = {
        let view = UIView()
        
        moviesTableViewController = MoviesListTableViewController()
        if let moviesTV = moviesTableViewController {
            moviesTV.viewModel = viewModel
            moviesTV.posterImagesRepository = posterImagesRepository
            moviesTV.view.backgroundColor = .white
            add(child: moviesTV, container: view)
            
            view.addSubview(moviesTV.view)
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
    
    static func create(
        with viewModel: MoviesListViewModel,
        posterImagesRepostiory: PosterImagesRepository?
    ) -> MoviesListViewController {
        let view = MoviesListViewController()
        view.viewModel = viewModel
        view.posterImagesRepository = posterImagesRepostiory
        
        return view
    }
    
    deinit {
        print("List View Controller Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBehaviours()
        
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
    
    private func bind(to viewModel: MoviesListViewModel) {
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
    
    private func setupBehaviours() {
//        addBehaviors([
//            BackButtonEmptyTitleNavigationBarBehavior(),
//            BlackStyleNavigationBarBehavior()
//        ])
    }
    
    private func updateTimes() {
        moviesTableViewController?.reload()
    }
    
    private func updateLoading(_ loading: MoviesListViewModelLoading?) {
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
extension MoviesListViewController {
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "추가"
        // ??
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barStyle = .default
        searchController.searchBar.frame = searchBarContainer.bounds
        // ??
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        // ??
        definesPresentationContext = true
        if #available(iOS 13.0, *) {
            // accessibility는 테스트를 위해?
            searchController.searchBar.searchTextField.accessibilityIdentifier = Identifier.searchField
        }
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel.didSearch(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

extension MoviesListViewController: UISearchControllerDelegate {
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
