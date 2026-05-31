# CLAUDE.md — Liquid Glass Playground

Rules for Claude when working in this repo. These apply on **every branch**.

## What this repo is

A sandbox to experiment with Liquid Glass (iOS 26) on the UI *shapes* of real
apps. `main` is a bare empty SwiftUI app. Each `app/<name>` branch mirrors a real
app's UI structure with placeholder content and Liquid Glass applied.

## Hard guardrails — never violate

- **Never copy production code.** No business logic, API keys, secrets,
  networking, persistence, analytics, auth, or real data from a source app.
- **Mock/static data only.** Hard-coded sample arrays, placeholder strings, SF
  Symbols, and system/asset-catalog images. No real endpoints.
- The source app is read **only** to understand its UI architecture. Never clone
  or copy a source repo into this one.

## Mirror the original exactly

When building an `app/<name>` branch, reproduce the original app's UI structure:

- **Root navigation container** — `TabView`, `NavigationStack`,
  `NavigationSplitView`, `UITabBarController`, `UINavigationController`, etc.
- **Framework per screen** — SwiftUI, UIKit, or hybrid (e.g. `UIHostingController`
  wrapping SwiftUI inside a UIKit flow). Match what the real app does.
- **Screen hierarchy** — same tabs, same push/present flows, same rough screen
  inventory. Layout fidelity matters less than *structural* fidelity.

## Liquid Glass

- **Minimum deployment: iOS 18.0.** Gate every Liquid Glass API behind
  `#available(iOS 26, *)` and provide a graceful pre-26 fallback (plain
  `Material` / background). See [docs/liquid-glass-reference.md](docs/liquid-glass-reference.md).
- **Don't fight the system.** Prefer standard components (`TabView`, toolbars,
  `.sheet`, `NavigationStack`) that adopt Liquid Glass automatically before
  hand-rolling custom `glassEffect` surfaces.

## Per-branch documentation

Every `app/<name>` branch keeps its own `README.md` recording:

- The source app it mirrors.
- The navigation/framework structure that was reproduced.
- Which Liquid Glass changes were applied.

Also add the branch to the index table in the root `README.md`.
