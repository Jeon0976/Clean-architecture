//
//  MoviesTopRatedViewController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/10.
//

import UIKit

final class MoviesTopRatedViewController: UIViewController {
    
    private var viewModel: MoviesTopRatedViewModel!
    private var posterImageUseCase: PosterImagesUseCase?
    private var moviesCollectionViewController: MoviesTopRatedCollectionViewController?
    
    private let disposeBag = DisposeBag()
    
    private lazy var moviesTopRatedContainer: UIView = {
        let view = UIView()
        
        let layout = UICollectionViewFlowLayout()

        moviesCollectionViewController = MoviesTopRatedCollectionViewController(collectionViewLayout: layout)
        if let moviesCV = moviesCollectionViewController {
            moviesCV.viewModel = viewModel
            moviesCV.posterImageUseCase = posterImageUseCase
            moviesCV.collectionView.backgroundColor = .clear
            add(child: moviesCV, container: view)
            
            view.addSubview(moviesCV.view)
        }
        
        return view
    }()
    
    static func create(
        with viewModel: MoviesTopRatedViewModel,
        posterImageUseCase: PosterImagesUseCase?
    ) -> MoviesTopRatedViewController {
        let view = MoviesTopRatedViewController()
        view.viewModel = viewModel
        view.posterImageUseCase = posterImageUseCase
        return view
    }
    
    deinit {
        print("MoviesTopRated View Controller Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind(to: viewModel)
        
        viewModel.viewDidLoad()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
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
            moviesTopRatedContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func bind(to viewModel: MoviesTopRatedViewModel) {
        viewModel.items
            .subscribe(on: self, disposeBag: disposeBag)
            .onNext { [weak self] _ in
                self?.updateCollectionView()
            }
        
        viewModel.loading
            .subscribe(on: self, disposeBag: disposeBag)
            .onNext { [weak self] in
                self?.updateLoading($0)
            }
        
        viewModel.isResetCompleted
            .subscribe(on: self, disposeBag: disposeBag)
            .onNext { [weak self] in
                self?.refreshCollectionView($0)
            }
        
    }
    
    private func updateCollectionView() {
        moviesCollectionViewController?.reload()
    }
    
    private func updateLoading(_ loading: MoviesTopRatedModelLoading?) {
        moviesCollectionViewController?.isLoading(loading)
    }
    
    private func refreshCollectionView(_ refresh: Bool) {
        moviesCollectionViewController?.isRefresh(refresh)
    }
    
}

