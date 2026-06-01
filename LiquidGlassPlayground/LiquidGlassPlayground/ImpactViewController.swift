//
//  ImpactViewController.swift
//  LiquidGlassPlayground — app/blood skeleton
//
//  Mirrors Blood's SocialViewController: a segmented container that swaps
//  between "My Team" and "Leaderboard". Pure UIKit, mock data.
//

import UIKit

final class ImpactViewController: UIViewController, UITableViewDataSource {
    private let segmented = UISegmentedControl(items: ["My Team", "Leaderboard"])
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private var rows: [String] {
        segmented.selectedSegmentIndex == 0 ? MockSocial.team : MockSocial.leaderboard
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground

        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        navigationItem.titleView = segmented

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "row")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    @objc private func segmentChanged() {
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = rows[indexPath.row]
        cell.contentConfiguration = config
        return cell
    }
}
