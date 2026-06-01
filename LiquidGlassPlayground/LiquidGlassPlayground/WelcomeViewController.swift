//
//  WelcomeViewController.swift
//  LiquidGlassPlayground — app/blood skeleton
//
//  Placeholder login gate (Blood presents WelcomeViewController to logged-out
//  users). No real auth — "Continue" drops straight into the tabs.
//

import UIKit

final class WelcomeViewController: UIViewController {
    var onContinue: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BloodTheme.red

        let title = UILabel()
        title.text = "Blood"
        title.font = .systemFont(ofSize: 44, weight: .bold)
        title.textColor = .white

        let subtitle = UILabel()
        subtitle.text = "Liquid Glass playground skeleton"
        subtitle.font = .preferredFont(forTextStyle: .body)
        subtitle.textColor = .white.withAlphaComponent(0.9)
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .center

        var config = UIButton.Configuration.filled()
        config.title = "Continue"
        config.baseBackgroundColor = .white
        config.baseForegroundColor = BloodTheme.red
        config.cornerStyle = .large
        config.contentInsets = .init(top: 14, leading: 40, bottom: 14, trailing: 40)
        let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.onContinue?()
        })

        let stack = UIStackView(arrangedSubviews: [title, subtitle, button])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.setCustomSpacing(40, after: subtitle)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32),
        ])
    }
}
