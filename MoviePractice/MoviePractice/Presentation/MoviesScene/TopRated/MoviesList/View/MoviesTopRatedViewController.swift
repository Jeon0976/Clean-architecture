//
//  MoviesTopRatedViewController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/10.
//

import UIKit

final class MoviesTopRatedViewController: UIViewController {
    
    private var viewModel: MoviesTopRatedViewModel!
    private var posterImagesRepository: PosterImagesRepository?
    private var moviesCollectionViewController: MoviesTopRatedCollectionViewController?
    
    private let disposeBag = DisposeBag()
    
    private lazy var moviesTopRatedContainer: UIView = {
        let view = UIView()
        
        let layout = UICollectionViewFlowLayout()

        moviesCollectionViewController = MoviesTopRatedCollectionViewController(collectionViewLayout: layout)
        if let moviesCV = moviesCollectionViewController {
            moviesCV.viewModel = viewModel
            moviesCV.posterImagesRepository = posterImagesRepository
            moviesCV.collectionView.backgroundColor = .white
            add(child: moviesCV, container: view)
            
            view.addSubview(moviesCV.view)
        }
        
        return view
    }()
    
    static func create(with viewModel: MoviesTopRatedViewModel) -> MoviesTopRatedViewController {
        let view = MoviesTopRatedViewController()
        view.viewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind(to: viewModel)
    }
    
    private func setupView() {
        self.view.backgroundColor = .darkGray
        moviesTopRatedContainer.backgroundColor = .lightGray
        
        [
            moviesTopRatedContainer
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            moviesTopRatedContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            moviesTopRatedContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            moviesTopRatedContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            moviesTopRatedContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func bind(to viewModel: MoviesTopRatedViewModel) {
        
    }
}

