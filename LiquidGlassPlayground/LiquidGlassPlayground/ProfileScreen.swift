//
//  ProfileScreen.swift
//  LiquidGlassPlayground — app/blood skeleton
//
//  SwiftUI screen bridged into the UIKit Profile tab via UIHostingController.
//  This is the "hybrid" seam: UIKit shell, SwiftUI content (as Blood does).
//

import SwiftUI

struct ProfileScreen: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                BloodTypeCard()
                EligibilityCard()
                BookButton()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}

private struct BloodTypeCard: View {
    var body: some View {
        VStack(spacing: 6) {
            Text(MockProfile.bloodType)
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundStyle(.red)
            Text("Blood type")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .playgroundGlass(cornerRadius: 24)
    }
}

private struct EligibilityCard: View {
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "checkmark.seal.fill")
                .font(.title)
                .foregroundStyle(.green)
            VStack(alignment: .leading, spacing: 2) {
                Text("Eligible to donate")
                    .font(.headline)
                Text("Last donation \(MockProfile.lastDonation)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .playgroundGlass(cornerRadius: 18)
    }
}

private struct BookButton: View {
    var body: some View {
        Button {
            // Placeholder — appointment flow is out of scope for the shell.
        } label: {
            Text("Book a donation")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
        }
        .buttonStyle(.glassProminentIfAvailable)
    }
}

// MARK: - Liquid Glass with iOS 18 fallback (branch-local helper)

extension View {
    /// Liquid Glass on iOS 26, graceful Material fallback on earlier versions.
    @ViewBuilder
    func playgroundGlass(cornerRadius: CGFloat) -> some View {
        if #available(iOS 26, *) {
            self.glassEffect(.regular, in: RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}

extension PrimitiveButtonStyle where Self == GlassProminentIfAvailableButtonStyle {
    static var glassProminentIfAvailable: GlassProminentIfAvailableButtonStyle { .init() }
}

struct GlassProminentIfAvailableButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26, *) {
            Button(configuration).buttonStyle(.glassProminent)
        } else {
            Button(configuration).buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ProfileScreen()
}
