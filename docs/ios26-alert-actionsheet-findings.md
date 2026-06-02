# iOS 26 — Alert & Action Sheet Findings

Findings from auditing `UIAlertController` behaviour on iOS 26 (Liquid Glass)
versus iOS 18, captured while building the `app/blood` Appointment screen. All
results below were reproduced on an iPhone 17 simulator (iOS 26.3.1); the iOS 18
column reflects prior behaviour / the audit reference screenshots.

> **TL;DR** — iOS 26 redesigned `UIAlertController`. Two things changed that you
> cannot control through public API: **action title colour** and **cancel
> grouping**. The only way to override either is a custom sheet (or private API,
> which we do not use).

## Summary

| Behaviour | iOS 18.x | iOS 26.x | Controllable? |
| --- | --- | --- | --- |
| `.default` / `.cancel` title colour | tint / accent | **label (black)** | ❌ no public API |
| `.destructive` title colour | red | red | (style-fixed) |
| `preferredAction` emphasis | **bold title** | **filled / tinted background** | ✅ set `preferredAction` |
| `.cancel` action grouping | **detached section** below | **grouped** in one card | ❌ no public API |
| Action sheet placement (iPhone) | bottom-anchored | over the originating view (iPad-style) | n/a |
| `.cancel` button when anchored to a `sourceView` | shown | **dropped** (tap-outside = cancel) | via anchoring |

---

## 1. Action title colour is decoupled from tint

On iOS 26 the action sheet colours titles purely by **style**:

| Action style | iOS 18 | iOS 26 |
| --- | --- | --- |
| `.default` | tint / accent | **label colour (black in light mode)** |
| `.cancel` | tint / accent (bold) | **label colour (black)**, bold |
| `.destructive` | red | red (unchanged) |

The pre-26 trick of setting the alert's tint **no longer works**. Verified three
ways — all left `.default` / `.cancel` black:

```swift
// ❌ none of these recolour .default / .cancel on iOS 26
present(alert, animated: true) { alert.view.tintColor = .red }  // after present
alert.view.tintColor = .red; present(alert, animated: true)      // before present
view.window?.tintColor = .red                                    // global window tint
```

`.destructive` was red in every case.

**To force a colour:** the only lever is the **undocumented `titleTextColor` KVC**
(`action.setValue(color, forKey: "titleTextColor")`) — private API, risks App
Store rejection and breakage across OS versions. Not used in this repo. Otherwise
build a custom sheet.

**Recommendation:** accept the system label colour — it is the intended iOS 26
appearance and matches Apple's own apps.

---

## 2. How `tint`/accent colour and `preferredAction` affect alerts & action sheets

These are the two levers most people reach for to emphasise an action. **What
each one actually does changed completely between iOS 18 and iOS 26.**

### `tint` / accent colour

| | iOS 18.x | iOS 26.x |
| --- | --- | --- |
| `.default` / `.cancel` title | drawn in the **tint colour** | **label colour (black)** — tint ignored for titles |
| `.destructive` title | red (overrides tint) | red |
| Where tint *does* show | nowhere else | on the **`preferredAction`'s filled background** (see below) |

On iOS 18 the tint is the colour of every non-destructive action's **text**. On
iOS 26 the redesign drops tint from action titles entirely — verified: setting
`view.tintColor` before/after present or via the window has no effect on titles
(see §1). Tint's only remaining visible role on the redesigned alert is the fill
of the emphasised (`preferredAction`) button.

### `preferredAction`

`preferredAction` only applies to the **`.alert`** style — it has **no effect on
`.actionSheet`** (an action sheet ignores it).

| | iOS 18.x | iOS 26.x |
| --- | --- | --- |
| Emphasis style | preferred action's title shown **bold** | preferred action rendered as a **prominent filled button** |
| Role of tint | colours the (bold) text | colours the **button's background fill** |

The emphasis migrated from *typography* (bold text) to *shape + fill* (a
prominent coloured button), and that fill is where the alert's tint now lands.
This is what the `alertColourWithPreferredAction` repro row demonstrates: with
`view.tintColor = .purple` and a `preferredAction` set, iOS 26 draws the
preferred action as a purple-filled button while the other titles stay black.

> Verification note: the title-colour rows are confirmed by the §1 screenshots
> (action sheet). The `preferredAction` background behaviour is from the
> `alertColourWithPreferredAction` harness (`.alert` style + purple tint).

### Putting it together

- **iOS 18:** tint = the text colour of all `.default`/`.cancel` actions;
  `preferredAction` = make one of them **bold**. Both act on text.
- **iOS 26:** tint = the **background fill of the prominent action**;
  `preferredAction` = *which* action becomes that prominent filled button. Plain
  action titles are always label colour (black) regardless of tint.

---

## 3. The `.cancel` action is no longer in a separate section

| | iOS 18.x | iOS 26.x |
| --- | --- | --- |
| `.default` + `.destructive` | one card | one card |
| `.cancel` | **separate detached card** below, with a gap | **same card**, grouped with the rest |

iOS 18 always renders the `.cancel`-style action in its own detached section at
the bottom, regardless of the order it was added. iOS 26 groups everything
(including cancel) into a single rounded card. The detached-cancel section
**does not exist** in the iOS 26 design.

There is **no public API** — no property, flag, or method — on
`UIAlertController` / `UIAlertAction` to influence sectioning. The system decides
the layout from each action's `style` plus the OS version.

### SwiftUI is the same (and gives less control)

`.confirmationDialog` (the replacement for the deprecated `.actionSheet`) is
backed by the same `UIAlertController` action-sheet presentation. It renders
**identically** on iOS 26 and exposes *fewer* hooks — you only supply buttons
with `role: .cancel` / `.destructive` / none and the system lays them out.

```swift
.confirmationDialog("Are you sure you want to cancel this appointment?",
                    isPresented: $show, titleVisibility: .visible) {
    Button("Reschedule") { … }
    Button("Confirm Cancellation", role: .destructive) { … }
    Button("Dismiss", role: .cancel) { … }   // same grouped treatment on iOS 26
}
```

**To change grouping:** stop using the system sheet. Build a custom sheet —
UIKit (`UISheetPresentationController` + your own layout) or SwiftUI
(`.sheet` + `.presentationDetents([.height(…)])`) — and lay the buttons into
whatever sections you want. You then re-own the behaviours the system gives for
free: tap-outside-to-dismiss, accessibility, Dynamic Type, Liquid Glass styling,
iPad popover.

---

## 4. Placement, popover & the `.cancel` button on iOS 26

iOS 26 presents action sheets like iPad — **over the originating view** rather
than pinned to the bottom. The `.cancel` button's *presence* depends on
anchoring:

- **No `sourceView`** → the sheet is **centred** and the `.cancel` button **is
  shown** (grouped into the card).
- **`sourceView` set** (popover/anchored) → the `.cancel` button is **dropped**;
  tapping outside the popover invokes the cancel handler. This matches Apple's
  note in *Getting the user's attention with alerts and action sheets*.

```swift
// iPad (and iOS 26 regular-width) REQUIRES a popover anchor or the app traps.
if let popover = alert.popoverPresentationController {
    popover.sourceView = anchorView
    popover.sourceRect = anchorView.bounds
    popover.permittedArrowDirections = []   // hides the arrow; centres the popover
}
```

### Side effect: hiding the arrow removes the present animation

Setting `permittedArrowDirections = []` removes the directional arrow **and** the
scale/expand-from-source animation (the popover normally grows out of the arrow's
anchor point). With no anchor point, UIKit falls back to a plain centred fade —
which reads as "no animation". Keep a single direction (e.g. `.up`) to retain the
animation at the cost of showing the arrow.

---

## Recommendations

1. **Accept the iOS 26 system defaults** (black `.default`/`.cancel` titles,
   grouped cancel). It is the intended Liquid Glass appearance.
2. **Always anchor action sheets** with a `popoverPresentationController`
   `sourceView` — required on iPad/regular-width or the app traps. Be aware this
   drops the `.cancel` button on iOS 26.
3. **Custom sheet** only if a specific colour or grouping is a hard requirement.
4. **Never use private API** (`titleTextColor` KVC, internal layout poking) — App
   Store rejection risk and cross-version breakage. See `CLAUDE.md` guardrails.

## Sources

- [Getting the user's attention with alerts and action sheets — Apple](https://developer.apple.com/documentation/uikit/getting-the-user-s-attention-with-alerts-and-action-sheets)
- [How to get an anchored action sheet without the popover — Apple Developer Forums](https://developer.apple.com/forums/thread/803824)
- [Alerts and Action Sheets not using accent color — Apple Developer Forums](https://developer.apple.com/forums/thread/673147)
- [ActionSheetIOS `cancelButtonIndex` change on iOS 26 — React Native #55074](https://github.com/facebook/react-native/issues/55074)
- [Changing UIAlertAction text color — Igor Kulman](https://blog.kulman.sk/changing-uialertaction-text-color/)

## Repro harness

`AppointmentDetailViewController` (on `app/blood`) has rows that exercise each
case: action-sheet vs alert colours, preferred action, popover vs no-popover, and
cancel grouping. Run the app → **Profile → Appointment** to reproduce on a
simulator.
