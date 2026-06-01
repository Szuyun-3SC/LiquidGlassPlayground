# Branch: `app/blood`

Liquid Glass skeleton mirroring the **Blood (American Red Cross)** iOS app.
Placeholder screens + mock data only — no production code, logic, networking,
secrets, or real data.

## Source app structure (what was mirrored)

Blood is **~95% UIKit**, programmatic, with SwiftUI screens bridged via
`UIHostingController` (~5%). Its root is a `UITabBarController`
(`BloodTabBarController`) with **3 tabs**, each wrapped in its own
`UINavigationController`:

| Tab | Blood's root VC | Skeleton placeholder |
| --- | --------------- | -------------------- |
| Profile | `ProfileViewController` (donation summary, blood type, eligibility) | UIKit VC hosting SwiftUI `ProfileScreen` |
| Badges | Storm/CMS-driven badge table | UIKit `UITableViewController` with mock badges + push detail |
| Impact | `SocialViewController` (segmented My Team / Leaderboard) | UIKit VC with `UISegmentedControl` swapping two mock lists |

Logged-out users see a `WelcomeViewController` gate before the tabs — mirrored
here as a placeholder Welcome screen with a "Continue" button (no real auth).

## Scope

**Tabs shell only** (first pass): the login gate + 3-tab container with one
placeholder root per tab. Deeper flows (the multi-step Appointment booking,
Donation History, Settings, etc.) are intentionally **not** built yet.

## Decisions

- **Hybrid mirror**: UIKit shell + SwiftUI where Blood uses it. The Profile tab
  hosts a SwiftUI screen via `UIHostingController` to establish that seam.
- **Entry point**: the app entry is SwiftUI's `App` lifecycle, which hosts the
  UIKit tree via `RootContainerView` (`UIViewControllerRepresentable`). This is a
  playground concession — Blood uses an `AppDelegate`. Everything below the entry
  point (tab bar, nav stacks, view controllers) mirrors Blood's UIKit
  architecture, which is where Liquid Glass actually renders.

## Liquid Glass applied

- **System adoption (free on iOS 26)**: the `UITabBar` and `UINavigationBar`
  adopt Liquid Glass automatically — the floating glass tab bar and nav bars.
- **Explicit glass** on the SwiftUI `ProfileScreen`: the blood-type and
  eligibility cards use `.glassEffect`, and the "Book a donation" button uses
  `.glassProminent` — all gated with `#available(iOS 26, *)` and a `Material` /
  `.borderedProminent` fallback for the iOS 18 deployment target.

## Files (under `LiquidGlassPlayground/LiquidGlassPlayground/`)

| File | Role |
| ---- | ---- |
| `LiquidGlassPlaygroundApp.swift` | SwiftUI entry; hosts `RootContainerView` |
| `RootContainer.swift` | UIKit bridge + gate (Welcome → tabs) |
| `WelcomeViewController.swift` | Placeholder login gate |
| `BloodTabBarController.swift` | 3-tab `UITabBarController`, per-tab nav controllers |
| `ProfileViewController.swift` | UIKit Profile tab hosting the SwiftUI screen |
| `ProfileScreen.swift` | SwiftUI Profile content + Liquid Glass + iOS 18 fallback helper |
| `BadgesViewController.swift` | UIKit badges table + detail push |
| `ImpactViewController.swift` | UIKit segmented My Team / Leaderboard |
| `MockData.swift` | Static placeholder data + theme color |

## Build / run

- Builds with Xcode 26 against an iOS 26 simulator (verified on iPhone 17 Pro).
- Deployment target iOS 18.6; Liquid Glass APIs are availability-gated.
