////
////  test.swift
////  MoviePractice
////
////  Created by 전성훈 on 2024/01/23.
////
//
//import UIKit
//
//final class TestViewController: UIViewController {
//    
//    private var test1TableViewController: Test1TableViewController?
//    private var test2TableViewController: Test2TableViewController?
//    
//    private lazy var test1ViewContainer: UIView = {
//        let view = UIView()
//        
//        test1TableViewController = Test1TableViewController.create()
//        
//        if let test1 = test1TableViewController {
//            add(child: test1, container: view)
//            view.addSubview(test1.view)
//        }
//        
//        return view
//    }()
//    
//    private lazy var test2ViewContaier: UIView = {
//        let view = UIView()
//        
//        test2TableViewController = Test2TableViewController()
//        if let test2 = test2TableViewController {
//            add(child: test2, container: view)
//            view.addSubview(test2.view)
//        }
//        
//        view.isHidden = true
//        return view
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupLayout()
//        setupAttribute()
//    }
//    
//    private func setupLayout() {
//        
//    }
//    
//    private func setupAttribute() {
//        
//    }
//    
//    func toggleTable() {
//        test1TableViewController?.remove()
//        test1TableViewController = nil
//        test1ViewContainer.isHidden = true
//    }
//    
//    private func addChildViewController(_ childViewController: UIViewController, toContainerView containerView: UIView) {
//        // 기존에 있던 자식 뷰 컨트롤러를 제거합니다.
//        for child in children {
//            child.remove()
//        }
//        
//        // 새로운 자식 뷰 컨트롤러를 추가합니다.
//        add(child: childViewController, container: containerView)
//    }
//    
//    @objc private func showTable1() {
//        // Test1TableViewController가 아직 초기화되지 않았으면 생성합니다.
//        if test1TableViewController == nil {
//            test1TableViewController = Test1TableViewController.create()
//        }
//        // Test1TableViewController를 test1ViewContainer에 추가합니다.
//        if let test1 = test1TableViewController {
//            addChildViewController(test1, toContainerView: test1ViewContainer)
//        }
//        test1ViewContainer.isHidden = false
//        test2ViewContaier.isHidden = true
//    }
//    
//    @objc private func showTable2() {
//        // Test2TableViewController가 아직 초기화되지 않았으면 생성합니다.
//        if test2TableViewController == nil {
//            test2TableViewController = Test2TableViewController()
//        }
//        // Test2TableViewController를 test2ViewContainer에 추가합니다.
//        if let test2 = test2TableViewController {
//            addChildViewController(test2, toContainerView: test2ViewContaier)
//        }
//        test1ViewContainer.isHidden = true
//        test2ViewContaier.isHidden = false
//    }
//
//}
//
//
//// UIViewController+AddChild
//extension UIViewController {
//    func add(child: UIViewController, container: UIView) {
//        addChild(child)
//        child.view.frame = container.bounds
//        container.addSubview(child.view)
//        child.didMove(toParent: self)
//    }
//    
//    func remove() {
//        guard parent != nil else { return }
//        
//        willMove(toParent: nil)
//        removeFromParent()
//        view.removeFromSuperview()
//    }
//}
//
//
//// static func으로 한 이유 (Factory Method)
//// 1. 코드의 명확성, 가독성 init 대신 create 명명된 팩토리 메서드를 사용
//// 2. 의존성 추가 (모든 의존성을 명시적으로 전달)
//// 서브클래스에서 오버라이딩 방지
//
//final class Test1TableViewController: UITableViewController {
//    private var activityIndicatorView: UIActivityIndicatorView?
//        
//    // MARK: Lifecycle
//    
//    static func create() -> Test1TableViewController {
//        return Test1TableViewController()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupTable()
//    }
//    
//    private func setupTable() {
//        tableView.register(Test1TableViewCell.self, forCellReuseIdentifier: Test1TableViewCell.identifier)
//        
//        tableView.estimatedRowHeight = Test1TableViewCell.height
//        tableView.rowHeight = UITableView.automaticDimension
//    }
//    
//    func reload() {
//        tableView.reloadData()
//    }
//}
//
//// UITableViewDataSource
//extension Test1TableViewController {
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        1
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: Test1TableViewCell.identifier, for: indexPath) as? Test1TableViewCell else {
//            return UITableViewCell()
//        }
//        
//        cell.fill()
//        
//        return cell
//    }
//}
//
//// UITableViewDelegate
////extension Test1TableViewController {
////    override func tableView(
////        _ tableView: UITableView,
////        heightForRowAt indexPath: IndexPath
////    ) -> CGFloat {
////        return viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
////    }
////    
////    override func tableView(
////        _ tableView: UITableView,
////        didSelectRowAt indexPath: IndexPath
////    ) {
////        viewModel.didSelectItem(at: indexPath.row)
////    }
////}
//
//final class Test1TableViewCell: UITableViewCell {
//    static let identifier = String(describing: Test1TableViewCell.self)
//    static let height: CGFloat = 100
//        
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupView() {
//        
//    }
//    
//    // Data Binding
//    func fill() {
//        
//    }
//}
//
//final class Test2TableViewController: UITableViewController {
//    
//}
//
////extension UITableViewController {
////    func makeActivityIndicator(size: CGSize) -> UIActivityIndicatorView {
////        let style: UIActivityIndicatorView.Style
////        if #available(iOS 12.0, *) {
////            if self.traitCollection.userInterfaceStyle == .dark {
////                style = .medium
////            } else {
////                style = .large
////            }
////        } else {
////            style = .gray
////        }
////        
////        let activityIndicator = UIActivityIndicatorView(style: style)
////        activityIndicator.startAnimating()
////        activityIndicator.isHidden = false
////        activityIndicator.frame = .init(origin: .zero, size: size)
////        
////        return activityIndicator
////    }
////}
////
