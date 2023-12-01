//
//  MovieListTableViewController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/25.
//

import UIKit

final class MoviesListTableViewController: UITableViewController {
    var viewModel: MoviesSearchViewModel!
    
    var posterImagesUseCase: PosterImagesUseCase?
    var nextPageLoadingSpinner: UIActivityIndicatorView?

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        tableView.register(MoviesListItemCell.self, forCellReuseIdentifier: MoviesListItemCell.identifier)
        
        tableView.estimatedRowHeight = MoviesListItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func updateLoading(_ loading: MoviesSearchViewModelLoading?) {
        switch loading {
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = makeActivityIndicator(size: .init(width: tableView.frame.width, height: 44))
            tableView.tableFooterView = nextPageLoadingSpinner
        case .fullScreen, .none:
            tableView.tableFooterView = nil
        }
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension MoviesListTableViewController {
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MoviesListItemCell.identifier,
            for: indexPath
        ) as? MoviesListItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(MoviesListItemCell.self) with reuseIdentifier: \(MoviesListItemCell.identifier)")
            return UITableViewCell()
        }

        cell.fill(
            with: viewModel.items.value[indexPath.row],
            posterImagesUseCase: posterImagesUseCase)
        
        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}
