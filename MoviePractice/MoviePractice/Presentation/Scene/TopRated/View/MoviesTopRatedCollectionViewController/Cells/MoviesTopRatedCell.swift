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
    private var posterImageUseCase: PosterImagesUseCase?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() }}
    private let mainQueue: DispatchQueueType = DispatchQueue.main
        
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var posterTitle: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var posterReleaseDate: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var ratingCountLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        
        [
            posterTitle,
            posterReleaseDate,
            ratingLabel,
            ratingCountLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            labelStackView.addArrangedSubview($0)
        }
        
        [
            posterImageView,
            labelStackView
            
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            labelStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            labelStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func fill(
        with viewModel: MoviesTopRatedCollectionItemViewModel,
        selected isSelected: Bool,
        posterImageUseCase: PosterImagesUseCase?
    ) {
        self.viewModel = viewModel
        self.posterImageUseCase = posterImageUseCase
        
        updateLabel()
        updateVisibility(isSelected)
        
        let width = Int(posterImageView.imageSizeAfterAspectFit.scaledSize.width)
        width == 0 ? updatePosterImage(width: 300) : updatePosterImage(width: width)
    }
    
    
    private func updatePosterImage(width: Int) {
        posterImageView.image = nil
        
        guard let posterImagePath = viewModel.posterImagePath else { return }
        
        // 캐시에서 이미지를 먼저 확인합니다.
        let cacheKey = NSString(string: posterImagePath)
        
        if let cachedImage = ImageCache.shared.object(forKey: cacheKey) {
            posterImageView.image = cachedImage
            return
        }
        
        imageLoadTask = posterImageUseCase?.execute(
            requestValue: .init(
                imagePath: posterImagePath,
                imageWidth: width),
            completion: { [weak self] result  in
                self?.mainQueue.async {
                    guard self?.viewModel.posterImagePath == posterImagePath else { return }
                    print(posterImagePath)
                    if case let .success(data) = result, let image = UIImage(data: data) {
                        // 이미지를 캐시에 저장합니다.
                        ImageCache.shared.setObject(image, forKey: cacheKey)
                        self?.posterImageView.image = image
                    }

                    self?.imageLoadTask = nil
                }
            })
        
    }
    
    private func updateLabel() {
        self.posterTitle.text = viewModel.title
        self.posterReleaseDate.text = viewModel.releaseDate
        self.ratingLabel.text = viewModel.rating
        self.ratingCountLabel.text = viewModel.ratingCount
    }
    
    private func updateVisibility(_ isSelected: Bool) {

        if isSelected {
            posterImageView.alpha = 0.2
            labelStackView.alpha = 1
        } else {
            posterImageView.alpha = 1
            labelStackView.alpha = 0
        }
    }
}


class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

// 이제 캐시 인스턴스를 사용하여 이미지를 저장하고 검색할 수 있습니다.
