//
//  MoviesTopRatedCell.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/11.
//

import UIKit

final class MoviesTopRatedCell: UICollectionViewCell {
    static let identifier = String(describing: MoviesTopRatedCell.self)
    
    private var viewModel: MoviesTopRatedCollectionItemViewModel!
    private var posterImagesRepository: PosterImagesRepository?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() }}
    private let mainQueue: DispatchQueueType = DispatchQueue.main
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var testlabel: UILabel = {
        let imageView = UILabel()
        
        return imageView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        self.backgroundColor = .lightGray
        
        [
            posterImageView,
            testlabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            testlabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            testlabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    func test() {
        print("Test")
        posterImageView.backgroundColor = .black
        testlabel.text = "Test"
    }
    
    func fill(
        with viewModel: MoviesTopRatedCollectionItemViewModel,
        posterImagesRepository: PosterImagesRepository?
    ) {
        self.viewModel = viewModel
        self.posterImagesRepository = posterImagesRepository
        
        
    }
    
    private func updatePosterImage(width: Int) {
        posterImageView.image = nil
        
        guard let posterImagePath = viewModel.posterImagePath else { return }
        
        imageLoadTask = posterImagesRepository?.fetchImage(with: posterImagePath, width: width, compltion: { [weak self] result in
            self?.mainQueue.async {
                guard self?.viewModel.posterImagePath == posterImagePath else { return }
                
                if case let .success(data) = result {
                    self?.posterImageView.image = UIImage(data: data)
                }
                
                self?.imageLoadTask = nil
            }
        })
    }
}
