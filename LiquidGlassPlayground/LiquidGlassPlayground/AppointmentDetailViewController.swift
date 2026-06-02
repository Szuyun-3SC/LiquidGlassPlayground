//
//  AppointmentDetailViewController.swift
//  LiquidGlassPlayground — app/blood skeleton
//
//  Placeholder mirror of Blood's appointment detail screen. Blood's original is a
//  table-driven detail VC whose "Cancel" row presents a confirmation action sheet.
//  Only the action-sheet UI shape is ported here — analytics, networking, HUD,
//  and CMS localisation from the original are intentionally dropped (mock only).
//

import UIKit

final class AppointmentDetailViewController: UITableViewController {
    private enum Row: CaseIterable {
        case summary
        case reschedule
        case cancel
        case cancelNoPopover
        case actionsColor
        case alertColour
        case alertColourWithPreferredAction
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Appointment"
        navigationItem.largeTitleDisplayMode = .never
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "row")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Row.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath)
        var config = cell.defaultContentConfiguration()

        switch Row.allCases[indexPath.row] {
        case .summary:
            config.text = MockAppointment.date
            config.secondaryText = MockAppointment.center
            cell.selectionStyle = .none
            cell.accessoryType = .none
        case .reschedule:
            config.text = "Reschedule"
            config.textProperties.color = view.tintColor
            cell.accessoryType = .disclosureIndicator
        case .cancel:
            config.text = "Cancel appointment (popover)"
            config.textProperties.color = BloodTheme.red
            cell.accessoryType = .none
        case .cancelNoPopover:
            config.text = "Cancel appointment (no popover)"
            config.textProperties.color = BloodTheme.red
            cell.accessoryType = .none
        case .actionsColor:
            config.text = "Actions colours"
            config.textProperties.color = BloodTheme.red
            cell.accessoryType = .none
        case .alertColour:
            config.text = "Alert colours"
            config.textProperties.color = BloodTheme.red
            cell.accessoryType = .none
        case .alertColourWithPreferredAction:
            config.text = "Alert colours with preferred action"
            config.textProperties.color = BloodTheme.red
            cell.accessoryType = .none
        }

        cell.contentConfiguration = config
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Row.allCases[indexPath.row] {
        case .summary:
            break
        case .reschedule:
            handleReschedule()
        case .cancel:
            handleCancel(from: tableView.cellForRow(at: indexPath))
        case .cancelNoPopover:
            handleCancelWithoutPopover()
        case .actionsColor:
            handleActionsColor(.actionSheet, preferredActionStyle: nil)
        case .alertColour:
            handleActionsColor(.alert, preferredActionStyle: nil)
        case .alertColourWithPreferredAction:
            handleActionsColor(.alert, preferredActionStyle: .default)
        }
    }

    // MARK: - Actions

    /// Anchored variant. On iPad (regular-width) the action sheet shows in a popover.
    /// UIKit then drops the .cancel button, and a tap outside the popover invokes the
    /// cancel handler — see Apple's "Getting the user's attention with alerts and
    /// action sheets". The popover needs an anchor or it traps.
    private func handleCancel(from sourceCell: UITableViewCell?) {
        let cancelAlertController = makeCancelAlert()
        if let popover = cancelAlertController.popoverPresentationController {
            popover.sourceView = sourceCell ?? view
            popover.sourceRect = (sourceCell ?? view).bounds
            // Empty set hides the directional arrow; UIKit centers the popover.
            popover.permittedArrowDirections = []
        }
        present(cancelAlertController, animated: true, completion: nil)
    }

    /// Un-anchored variant, for comparison. On iPhone this presents the standard
    /// bottom action sheet with the Cancel button shown. ⚠️ On iPad it would trap
    /// because the popover has no anchor — exactly what the anchored variant avoids.
    private func handleCancelWithoutPopover() {
        present(makeCancelAlert(), animated: true, completion: nil)
    }

    private func makeCancelAlert() -> UIAlertController {
        let cancelAlertController = UIAlertController(
            title: "Cancel appointment",
            message: nil,
            preferredStyle: .actionSheet
        )

        cancelAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        let rescheduleAction = UIAlertAction(title: "Reschedule", style: .default) { [weak self] _ in
            self?.handleReschedule()
        }
        cancelAlertController.addAction(rescheduleAction)

        let continueAction = UIAlertAction(title: "Continue", style: .destructive) { [weak self] _ in
            // Mock: the original cancels the appointment over the network, then pops
            // back on success. Here we just pop.
            self?.navigationController?.popViewController(animated: true)
        }
        cancelAlertController.addAction(continueAction)

        return cancelAlertController
    }

    private func handleActionsColor(
        _ style: UIAlertController.Style,
        preferredActionStyle: UIAlertAction.Style?
    ) {
        let alertController = UIAlertController(
            title: "Demonstrate action colours",
            message: nil,
            preferredStyle: style
        )

        let preferredAction = UIAlertAction(title: "Default style", style: .default, handler: nil)
        alertController.addAction(preferredAction)
        alertController.addAction(UIAlertAction(title: "Destructive style", style: .destructive, handler: nil))
        alertController.addAction(UIAlertAction(title: "Cancel style", style: .cancel, handler: nil))

        if let preferredActionStyle {
            alertController.view.tintColor = .purple
            alertController.preferredAction = preferredAction
        }

        present(alertController, animated: true, completion: nil)
    }

    private func handleReschedule() {
        // Mock — the original pushes a multi-step reschedule flow.
    }
}
