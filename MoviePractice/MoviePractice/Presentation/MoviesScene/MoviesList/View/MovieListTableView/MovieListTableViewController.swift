//
//  MovieListTableViewController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/25.
//

import UIKit

final class MoviesListTableViewController: UITableViewController {
    var viewModel: MoviesListViewModel!
    
    var posterImagesRepository: PosterImagesRepository?
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
