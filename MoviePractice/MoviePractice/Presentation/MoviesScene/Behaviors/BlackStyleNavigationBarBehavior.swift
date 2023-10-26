//
//  BlackStyleNavigationBarBehavior.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/26.
//

import UIKit

struct BlackStyleNavigationBarBehavior: ViewControllerLifecycleBehavior {

    func viewDidLoad(viewController: UIViewController) {
        viewController.navigationController?.navigationBar.barStyle = .black
    }
}
