//
//  MoviesQueriesTableViewController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/26.
//

import UIKit

final class MoviesQueriesTableViewController: UITableViewController {
    private var viewModel: MoviesQueryListViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    
    static func create(with viewModel: MoviesQueryListViewModel) -> MoviesQueriesTableViewController {
        let view = MoviesQueriesTableViewController(style: .insetGrouped)
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bind(to: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppear()
    }
    
    private func bind(to viewModel: MoviesQueryListViewModel) {
        viewModel.items
            .subscribe(on: self, disposeBag: disposeBag)
            .onNext { [weak self] _ in
                self?.tableView.reloadData()
        }
    }
    
    private func setupViews() {
        tableView.backgroundColor = .clear
        tableView.register(
            MoviesQueriesItemCell.self,
            forCellReuseIdentifier: MoviesQueriesItemCell.reuseIdentifier
        )
        tableView.estimatedRowHeight = MoviesQueriesItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MoviesQueriesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesQueriesItemCell.reuseIdentifier, for: indexPath) as? MoviesQueriesItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(MoviesQueriesItemCell.self) with reuseIdentifier: \(MoviesQueriesItemCell.reuseIdentifier)")
            return UITableViewCell()
        }
        cell.fill(with: viewModel.items.value[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelect(item: viewModel.items.value[indexPath.row])
    }
}

