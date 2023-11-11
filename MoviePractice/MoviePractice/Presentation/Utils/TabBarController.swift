//
//  TabBarController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/01.
//

import UIKit

protocol TabBarDelegate: AnyObject {
    func shouldHideTabBar(_ hide: Bool)
}

final class DefaultTabBarController: UIViewController, TabBarDelegate {
    private lazy var viewControllers: [UIViewController] = []
    private lazy var buttons: [UIButton] = []
    
    private lazy var tabBarView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    var selectedIndex = 0 {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        setupButtons()
        updateView()
    }
    
    private func setupTabBar() {
        view.addSubview(tabBarView)
        
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func setupButtons() {
        // 버튼의 넓이는 tab 개수에 맞춰서 유동적으로 변함
        let buttonWidth = view.bounds.width / CGFloat(viewControllers.count)
        
        for (index, viewController) in viewControllers.enumerated() {
            let button = UIButton()
            button.tag = index
            button.setTitle(viewController.title, for: .normal)
            button.setImage(UIImage(systemName: "circle"), for: .normal)
            button.setTitleColor(.darkGray, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            tabBarView.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor),
                button.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: CGFloat(index) * buttonWidth),
                button.widthAnchor.constraint(equalToConstant: buttonWidth),
                button.heightAnchor.constraint(equalTo: tabBarView.heightAnchor)
            ])
            
            buttons.append(button)
        }
    }
    
    private func updateView() {
        viewControllers.enumerated().forEach { (index, viewController) in
            if index == selectedIndex {
                addChild(viewController)
                view.insertSubview(viewController.view, belowSubview: tabBarView)
                viewController.view.frame = view.bounds
                viewController.didMove(toParent: self)
            } else if viewController.parent != nil {
                viewController.willMove(toParent: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            }
        }
        
        buttons.enumerated().forEach { (index, button) in
            button.isSelected = index == selectedIndex
        }
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
    }
    
    func shouldHideTabBar(_ hide: Bool) {
        tabBarView.isHidden = hide
    }
}
