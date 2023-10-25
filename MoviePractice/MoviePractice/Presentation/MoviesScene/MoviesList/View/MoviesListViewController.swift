//
//  MoviesListViewController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/25.
//

import UIKit

final class MoviesListViewController: UIViewController, Alertable {
    
    private var viewModel: MoviesListViewModel!
    private var posterImagesRepository: PosterImagesRepository?
    
    private var moviesTableViewController: MoviesListTableViewController?
    private var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Lifecycle
    
    static func create(with viewModel: MoviesListViewModel, posterImagesRepostiory: PosterImagesRepository?) -> MoviesListViewController {
        let view = MoviesListViewController()
        view.viewModel = viewModel
        view.posterImagesRepository = posterImagesRepostiory
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
    }
}
