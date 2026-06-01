//
//  BadgesViewController.swift
//  LiquidGlassPlayground — app/blood skeleton
//
//  Pure UIKit table (Blood's Badges tab is a Storm/CMS-driven table). Mock rows.
//

import UIKit

final class BadgesViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "badge")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MockBadges.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "badge", for: indexPath)
        let badge = MockBadges.items[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = badge.title
        config.secondaryText = badge.subtitle
        config.image = UIImage(systemName: badge.symbol)
        config.imageProperties.tintColor = badge.subtitle == "Unlocked" ? BloodTheme.red : .tertiaryLabel
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = UIViewController()
        detail.view.backgroundColor = .systemBackground
        detail.title = MockBadges.items[indexPath.row].title
        navigationController?.pushViewController(detail, animated: true)
    }
}
