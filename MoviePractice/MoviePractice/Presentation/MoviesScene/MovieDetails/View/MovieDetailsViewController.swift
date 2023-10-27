//
//  MovieDetailsViewController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/26.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    private var viewModel: MovieDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var overviewTextView: UITextView = {
        let textView = UITextView()
        
        textView.font = .systemFont(ofSize: 18, weight: .semibold)
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    static func create(with viewModel: MovieDetailsViewModel) -> MovieDetailsViewController {
        let view = MovieDetailsViewController()
        view.viewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind(to: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewModel.updatePosterImage(width: Int(posterImageView.imageSizeAfterAspectFit.scaledSize.width))
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        title = viewModel.title
        posterImageView.isHidden = viewModel.isPosterImageHidden
        overviewTextView.text = viewModel.overview
        view.accessibilityIdentifier = AccessibilityIdentifier.movieDetailsView
        
        [
            posterImageView,
            overviewTextView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 300),
            
            overviewTextView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            overviewTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            overviewTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            overviewTextView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func bind(to: MovieDetailsViewModel) {
        viewModel.posterImage
            .subscribe(on: self, disposeBag: disposeBag)
            .onNext { [weak self] in
                self?.posterImageView.image = $0.flatMap(UIImage.init)
            }
        
        viewModel.backgroundColor
            .subscribe(on: self, disposeBag: disposeBag)
            .onNext { [weak self] in
                self?.view.backgroundColor = $0
            }
        
        viewModel.textColor
            .subscribe(on: self, disposeBag: disposeBag)
            .onNext { [weak self] in
                self?.overviewTextView.textColor = $0
            }
    }
}
