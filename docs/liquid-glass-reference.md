# Liquid Glass Reference

A concise cheat-sheet for applying Liquid Glass consistently across app branches.
Liquid Glass is the iOS 26 design material. Build with Xcode 26+.

> **First principle: don't fight the system.** Standard components adopt Liquid
> Glass automatically on iOS 26. Reach for custom `glassEffect` surfaces only when
> the design genuinely needs a bespoke glass element.

## System adoption (free on iOS 26)

These get Liquid Glass automatically when built against the iOS 26 SDK — usually
nothing to do but use them:

- `TabView` — Liquid Glass tab bar (with bottom accessory / minimize behaviors).
- Toolbars (`.toolbar { ... }`) — glass toolbar items; group with
  `ToolbarItemGroup`; add separators with `ToolbarSpacer`.
- `.sheet` / presentations — glass backgrounds.
- `NavigationStack` / `NavigationSplitView` — glass nav bars.
- `.searchable` — glass search field.

## Custom glass (SwiftUI)

```swift
// Apply glass to any view, clipped to a shape.
myView
    .glassEffect(.regular, in: .rect(cornerRadius: 16))

// Interactive (responds to touch) + tinted.
myView
    .glassEffect(.regular.tint(.blue).interactive(), in: .capsule)
```

- **`GlassEffectContainer`** — wrap multiple glass elements so they blend/merge
  correctly and share rendering. Use when several glass shapes sit near each other.
- **`glassEffectID(_:in:)`** + a `@Namespace` — give glass elements identity so
  they morph/animate smoothly between states.
- **`glassEffectUnion(id:namespace:)`** — visually fuse adjacent glass shapes into
  one continuous surface.

### Buttons

```swift
Button("Action") { }.buttonStyle(.glass)            // standard glass
Button("Primary") { }.buttonStyle(.glassProminent)  // prominent / tinted
```

## iOS 18 fallback pattern

Minimum deployment is **iOS 18.0**, so every Liquid Glass API must be gated.
`main` ships no shared helper (it's a bare scaffold) — use inline availability
checks, or add a small local helper *within an app branch* if the repetition
hurts.

```swift
// Inline gate on a modifier.
extension View {
    @ViewBuilder
    func playgroundGlass(cornerRadius: CGFloat = 16) -> some View {
        if #available(iOS 26, *) {
            glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            background(.ultraThinMaterial, in: .rect(cornerRadius: cornerRadius))
        }
    }
}
```

```swift
// Gating a glass container / button.
if #available(iOS 26, *) {
    GlassEffectContainer { content }
} else {
    content
}
```

Rule of thumb: the iOS 26 branch uses real Liquid Glass; the fallback approximates
it with `Material` so the skeleton still builds and runs on iOS 18 simulators.

## Links

- [Liquid Glass — technology overview](https://developer.apple.com/documentation/technologyoverviews/liquid-glass)
- [Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass)
- [`glassEffect(_:in:)` (SwiftUI)](https://developer.apple.com/documentation/swiftui/view/glasseffect(_:in:))
- [`GlassEffectContainer`](https://developer.apple.com/documentation/swiftui/glasseffectcontainer)
