//
//  MyPageViewController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/13.
//

import UIKit

final class MyPageViewController: UIViewController {
    private var viewModel: MyPageViewModel!
    
    private let disposeBag = DisposeBag()
    
    private lazy var logoutButton: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("로그아웃", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(
            self,
            action: #selector(logoutTapped(_:)),
            for: .touchUpInside
        )
        
        return btn
    }()
    
    static func create(with viewModel: MyPageViewModel) -> MyPageViewController {
        let view = MyPageViewController()
        view.viewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    deinit {
        print("MyPageViewController Deinit")
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        [
            logoutButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    @objc private func logoutTapped(_ sender: UIButton) {
        viewModel.didTappedLogout()
    }
}
