//
//  AppointmentDetailViewController+Preview.swift
//  LiquidGlassPlayground — app/blood skeleton
//
//  SwiftUI wrapper so the UIKit AppointmentDetailViewController renders in a live
//  Xcode preview. Kept in its own file to avoid touching the VC itself.
//

import SwiftUI
import UIKit

/// Hosts AppointmentDetailViewController inside a UINavigationController — matching
/// how it's pushed in the app, so the preview shows the nav bar and title too.
private struct AppointmentDetailPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let nav = UINavigationController(rootViewController: AppointmentDetailViewController())
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

#Preview {
    AppointmentDetailPreview()
        .ignoresSafeArea()
}
