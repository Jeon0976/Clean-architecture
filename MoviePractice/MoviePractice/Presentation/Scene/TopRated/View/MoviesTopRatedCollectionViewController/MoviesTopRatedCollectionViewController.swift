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
    
    private var afterViewDidLoad = true
    private var loading: MoviesTopRatedModelLoading?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    deinit {
        print("MoviesTopRated Collection Controller Deinit")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if afterViewDidLoad {
            setupCollectionViewLayout()
            afterViewDidLoad = !afterViewDidLoad
        }
    }
    
    private func setupView() {
        collectionView.register(
            MoviesTopRatedCell.self,
            forCellWithReuseIdentifier: MoviesTopRatedCell.identifier
        )
        collectionView.register(
            MoviesTopRatedCollectionLodingFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: MoviesTopRatedCollectionLodingFooterView.identifier
        )
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshCollectionView(_:)), for: .valueChanged)
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
        let itemWidth = max(availableWidth / numberOfItemsPerRow, 0) // 음수 방지
        let itemHeight = itemWidth * 1.3

        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    @objc private func refreshCollectionView(_ sender: UIRefreshControl) {
        viewModel.reset()
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    func isLoading(_ isLoading: MoviesTopRatedModelLoading?) {
        self.loading = isLoading
    }
    
    func isRefresh(_ isRefresh: Bool) {
        isRefresh ? collectionView.refreshControl?.endRefreshing() : nil
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MoviesTopRatedCollectionViewController {
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.items.value.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoviesTopRatedCell.identifier,
            for: indexPath
        ) as? MoviesTopRatedCell else {
            return UICollectionViewCell()
        }
                
        let isSelected = viewModel.detailTextShownStates.value[indexPath] ?? false
                
        cell.fill(
            with: viewModel.items.value[indexPath.row],
            selected: isSelected,
            posterImagesRepository: posterImagesRepository
        )
        
        if indexPath.row == viewModel.items.value.count - 4 {
            viewModel.didLoadNextPage()
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectedCell(indexPath)
        
        collectionView.reloadItems(at: [indexPath])

    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else { return UICollectionReusableView() }
        
        let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: MoviesTopRatedCollectionLodingFooterView.identifier,
            for: indexPath
        )
        
        
        return footer
    }
    
}

extension MoviesTopRatedCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
}
