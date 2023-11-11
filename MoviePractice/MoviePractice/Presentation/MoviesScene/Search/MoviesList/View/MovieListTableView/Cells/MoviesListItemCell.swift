//
//  MoviesListItemCell.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/25.
//

import UIKit

final class MoviesListItemCell: UITableViewCell {
    static let identifier = String(describing: MoviesListItemCell.self)
    static let height = CGFloat(130)
    
    private var viewModel: MoviesListItemViewModel!
    private var posterImagesRepository: PosterImagesRepository?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() }}
    private let mainQueue: DispatchQueueType = DispatchQueue.main
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        [
            titleLabel,
            dateLabel,
            overviewLabel,
            posterImageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.contentView.bottomAnchor.constraint(greaterThanOrEqualTo: overviewLabel.bottomAnchor, constant: 10),
            
            posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(greaterThanOrEqualTo: dateLabel.trailingAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(greaterThanOrEqualTo: overviewLabel.trailingAnchor, constant: 8),
            posterImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.contentView.bottomAnchor.constraint(greaterThanOrEqualTo: posterImageView.bottomAnchor, constant: 10),
            posterImageView.widthAnchor.constraint(equalToConstant: 70),
            posterImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func fill(
        with viewModel: MoviesListItemViewModel,
        posterImagesRepository: PosterImagesRepository?
    ) {
        self.viewModel = viewModel
        self.posterImagesRepository = posterImagesRepository
        
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.releaseDate
        overviewLabel.text = viewModel.overview
        updatePosterImage(width: Int(posterImageView.imageSizeAfterAspectFit.scaledSize.width))
    }
    
    private func updatePosterImage(width: Int) {
        posterImageView.image = nil
        guard let posterImagePath = viewModel.posterImagePath else { return }
        
        imageLoadTask = posterImagesRepository?.fetchImage(
            with: posterImagePath,
            width: width,
            compltion: { [weak self] result in
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
