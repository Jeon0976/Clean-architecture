//
//  MoviesTopRatedCollectionViewController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/11.
//

import UIKit

final class MoviesTopRatedCollectionViewController: UICollectionViewController {
    var viewModel: MoviesTopRatedViewModel!
    
    var posterImagesRepository: PosterImagesRepository?
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    
    private var test = true
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind(to: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    private func setupView() {
        collectionView.register(MoviesTopRatedCell.self, forCellWithReuseIdentifier: MoviesTopRatedCell.identifier)
        
//        setupCollectionViewLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if test {
            setupCollectionViewLayout()
            test = !test
        }
    }

    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        // 셀과 셀 간격 조정
        let spacing: CGFloat = 15
        let numberOfItemsPerRow: CGFloat = 2
        let totalSpacing = (numberOfItemsPerRow - 1) * spacing

        // collectionView의 너비를 안전하게 계산
        let availableWidth = collectionView.frame.width - totalSpacing
        print(collectionView.bounds.width)
        print(totalSpacing)
        print(availableWidth)
        let itemWidth = max(availableWidth / numberOfItemsPerRow, 0) // 음수 방지
        let itemHeight = itemWidth * 1.3

        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    private func bind(to viewModel: MoviesTopRatedViewModel) {
        
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MoviesTopRatedCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesTopRatedCell.identifier, for: indexPath) as? MoviesTopRatedCell else {
            return UICollectionViewCell()
        }
        
        cell.test()
//        cell.fill(with: <#T##MoviesTopRatedCollectionItemViewModel#>, posterImagesRepository: <#T##PosterImagesRepository?#>)
        
        return cell
    }
    

}
