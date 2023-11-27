//
//  BackButtonEmptyTitleNavigationBarBehavior.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/26.
//

import UIKit

struct BackButtonEmptyTitleNavigationBarBehavior: ViewControllerLifecycleBehavior {
    func viewDidLoad(viewController: UIViewController) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
    }
}
