//
//  ProfileViewController.swift
//  LiquidGlassPlayground — app/blood skeleton
//
//  UIKit Profile tab root that hosts the SwiftUI ProfileScreen via
//  UIHostingController — the hybrid bridge Blood uses for newer screens.
//

import UIKit
import SwiftUI

final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground

        let host = UIHostingController(rootView: ProfileScreen())
        addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        host.didMove(toParent: self)
    }
}
