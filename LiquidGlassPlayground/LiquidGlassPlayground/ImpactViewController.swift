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
        updateLeaveButton()

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
        updateLeaveButton()
        tableView.reloadData()
    }

    /// The "Leave" action only makes sense on the My Team segment.
    private func updateLeaveButton() {
        navigationItem.rightBarButtonItem = segmented.selectedSegmentIndex == 0
            ? UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(handleLeaveCurrentTeam))
            : nil
    }

    /// Ported from Blood's `TeamScreen.handleLeaveCurrentTeam` — UI shape only. The
    /// original clears the user's team and syncs it over the network; here Continue
    /// is a mock no-op.
    @objc private func handleLeaveCurrentTeam() {
        let leaveAlertController = UIAlertController(
            title: "Leave \(MockSocial.teamName)?",
            message: "You'll lose your team standing and progress.",
            preferredStyle: .alert
        )
        leaveAlertController.addAction(UIAlertAction(title: "Continue", style: .default) { _ in
            // Mock: the original sets user.team = nil and calls profileController.updateUser.
        })
        leaveAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(leaveAlertController, animated: true, completion: nil)
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
