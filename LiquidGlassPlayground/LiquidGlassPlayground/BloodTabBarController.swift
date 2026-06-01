//
//  BloodTabBarController.swift
//  LiquidGlassPlayground — app/blood skeleton
//
//  Mirrors Blood's root: a UITabBarController with 3 tabs, each wrapped in its
//  own UINavigationController. On iOS 26 the tab bar and nav bars adopt Liquid
//  Glass automatically — no code needed (system adoption).
//

import UIKit

final class BloodTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = BloodTheme.red

        viewControllers = [
            wrap(ProfileViewController(), title: "Profile", image: .profile),
            wrap(BadgesViewController(), title: "Badges", image: .badges),
            wrap(ImpactViewController(), title: "Impact", image: .impact),
        ]
    }

    private func wrap(_ root: UIViewController, title: String, image: UIImage) -> UINavigationController {
        root.title = title
        root.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: nil)
        let nav = UINavigationController(rootViewController: root)
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }
}
