//
//  TabBarController.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/01.
//

import UIKit

enum TabBarPage {
    case search
    case topRated
    case myPage
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .search
        case 1:
            self = .topRated
        case 2:
            self = .myPage
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .search:
            return "Search"
        case .topRated:
            return "Popular"
        case .myPage:
            return "MyPage"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .search:
            return 0
        case .topRated:
            return 1
        case .myPage:
            return 2
        }
    }
}

protocol TabBarDelegate: AnyObject {
    func shouldHideTabBar(_ hide: Bool)
}

final class DefaultTabBarController: UIViewController, TabBarDelegate {
    private let tabBarHeight: CGFloat = 56
    
    private lazy var viewControllers: [UIViewController] = []
    private lazy var buttons: [UIButton] = []
    
    private lazy var tabBarView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    var selectedIndex: Int = 0 {
        willSet {
            previousIndex = selectedIndex
        }
        didSet {
            updateView()
        }
    }
    
    private var previousIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(CFGetRetainCount(self))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(CFGetRetainCount(self))

    }
    
    deinit {
        print("TabBar Deinit")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        updateTabBarHeight()
    }

    
    func setViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        setupButtons()
        updateView()
    }
    
    private func setupTabBar() {
        self.view.backgroundColor = .white
        view.addSubview(tabBarView)
        
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updateTabBarHeight() {
        NSLayoutConstraint.activate([
            tabBarView.heightAnchor.constraint(equalToConstant: tabBarHeight + view.safeAreaInsets.bottom)
        ])
    }
    
    private func setupButtons() {
        // 버튼의 넓이는 tab 개수에 맞춰서 유동적으로 변함
        let buttonWidth = view.bounds.width / CGFloat(viewControllers.count)
        
        for (index, viewController) in viewControllers.enumerated() {
            let button = UIButton()
            button.tag = index
            button.setTitle(viewController.title, for: .normal)
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
        deleteView()
        setupView()

        buttons.forEach { $0.isSelected = ($0.tag == selectedIndex) }
    }
    
    private func deleteView() {
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
    }
    
    private func setupView() {
        let selectedVC = viewControllers[selectedIndex]
        
        self.addChild(selectedVC)
        view.insertSubview(selectedVC.view, belowSubview: tabBarView)
        
        selectedVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            selectedVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectedVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectedVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        selectedVC.didMove(toParent: self)
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
    }
    
    func shouldHideTabBar(_ hide: Bool) {
        tabBarView.isHidden = hide
    }
}

