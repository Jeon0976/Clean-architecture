//
//  LoginViewController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/06.
//

import UIKit

final class LoginViewController: UIViewController, Alertable {
    private var viewModel: LoginViewModel!
    
    private let disposeBag = DisposeBag()
    
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("로그인", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(
            self,
            action: #selector(loginTapped(_:)),
            for: .touchUpInside
        )
        
        return btn
    }()
    
    static func create(with viewModel: LoginViewModel) -> LoginViewController {
        let view = LoginViewController()
        view.viewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        [
            loginButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    @objc private func loginTapped(_ sender: UIButton) {
        viewModel.didTappedLogin()
    }
}
