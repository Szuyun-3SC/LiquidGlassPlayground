//
//  MockData.swift
//  LiquidGlassPlayground — app/blood skeleton
//
//  Static placeholder data only. No production data, networking, or real models.
//

import UIKit

enum BloodTheme {
    static let red = UIColor(red: 0.906, green: 0.075, blue: 0.141, alpha: 1.0)
}

enum MockProfile {
    static let bloodType = "O+"
    static let lastDonation = "8 weeks ago"
}

enum MockBadges {
    static let items: [(symbol: String, title: String, subtitle: String)] = [
        ("drop.fill", "First Donation", "Unlocked"),
        ("heart.fill", "Lifesaver", "Unlocked"),
        ("star.fill", "Gallon Club", "Locked"),
        ("bolt.heart.fill", "Rapid Responder", "Locked"),
    ]
}

enum MockSocial {
    static let team = ["Alex M.", "Jordan P.", "Sam R.", "Taylor K."]
    static let leaderboard = ["City Donors — 1,204", "Red Squad — 980", "The Pints — 845", "O Positives — 612"]
}
