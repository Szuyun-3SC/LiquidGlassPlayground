//
//  RootContainer.swift
//  LiquidGlassPlayground — app/blood skeleton
//
//  Bridges the UIKit UI tree into the SwiftUI App lifecycle. The entry point is
//  SwiftUI (a playground concession — Blood uses an AppDelegate), but everything
//  below mirrors Blood's UIKit architecture.
//

import SwiftUI
import UIKit

struct RootContainerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AppRootViewController {
        AppRootViewController()
    }

    func updateUIViewController(_ uiViewController: AppRootViewController, context: Context) {}
}

/// Gates the tab bar behind a Welcome screen, mirroring Blood's logged-out flow.
final class AppRootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        showTabs()
    }

    private func showWelcome() {
        let welcome = WelcomeViewController()
        welcome.onContinue = { [weak self] in self?.showTabs() }
        setRoot(welcome)
    }

    private func showTabs() {
        setupTabBarAppearance()
        setRoot(BloodTabBarController())
    }

    private func setRoot(_ child: UIViewController) {
        children.forEach { $0.willMove(toParent: nil); $0.view.removeFromSuperview(); $0.removeFromParent() }
        addChild(child)
        child.view.frame = view.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// Setup global `UITabBarAppearance`
    private func setupTabBarAppearance() {

        // tabBarAppearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.selectionIndicatorTintColor = .arcRed
        tabBarAppearance.stackedItemPositioning = .automatic

        // tabBarItemAppearance
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.normal.configure(
            textColor: .arcDarkGray
        )
        tabBarItemAppearance.selected.configure(
            textColor: .arcRed
        )

        // tabBarItemAppearance appearance
        tabBarAppearance.inlineLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = tabBarItemAppearance

        // tabBar
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

// MARK: - UITabBarItemStateAppearance + Extensions

private extension UITabBarItemStateAppearance {

    /// Configure with the given `textColor`
    ///
    /// - Parameters:
    ///   - textColor: `UIColor` for `iconColor` and `foregroundColor`
    func configure(textColor: UIColor) {
        iconColor = textColor
        titleTextAttributes = [
            .foregroundColor: textColor
        ]
    }
}
