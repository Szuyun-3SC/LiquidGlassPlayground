//
//  ProfileScreen.swift
//  LiquidGlassPlayground — app/blood skeleton
//
//  SwiftUI screen bridged into the UIKit Profile tab via UIHostingController.
//  This is the "hybrid" seam: UIKit shell, SwiftUI content (as Blood does).
//

import SwiftUI
import MapKit

enum GlassStyle: CaseIterable {
    case clear
    case regular

    @available(iOS 26.0, *)
    var glassStyle: Glass {
        switch self {
        case .clear: .clear
        case .regular: .regular
        }
    }
}

struct ProfileScreen: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) private var accessibilityReduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(verbatim: "Color scheme: \(String(describing: colorScheme).capitalized)")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(verbatim: "Reduce transparency: \(accessibilityReduceTransparency ? "On" : "Off")")
                        .font(.headline)

                    Text(verbatim: "Increase Contrast: \(colorSchemeContrast == .increased ? "On" : "Off")")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundStyle(Color.white)
                .background(Color.accentColor.clipShape(RoundedRectangle(cornerRadius: 24)))
                .padding(.bottom, 24)

                HStack {
                    ForEach(GlassStyle.allCases, id: \.self) { style in
                        Text("Glass style: \(String(describing: style).capitalized)")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .foregroundStyle(Color.arcDarkGray)
                            .background(.white, in: Capsule())
                    }
                }

                ButtonsDemo()

                if #available(iOS 26.0, *) {
                    GlassViewsDemo()
                }

//                BloodTypeCard()
//                EligibilityCard()
//                BookButton()
            }
            .padding()
        }
        .scrollBounceBehavior(.basedOnSize)
        .background {
            Map(coordinateRegion: $region)
                .ignoresSafeArea()
        }
    }
}

private struct ButtonsDemo: View {
    var body: some View {
        VStack {
            HStack {
                ForEach(
                    GlassStyle.allCases,
                    id: \.self
                ) { style in
                    Button {
                        // Placeholder — appointment flow is out of scope for the shell.
                    } label: {
                        Text("Button")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.glassProminentIfAvailable(style))
                }
            }
            .frame(maxWidth: .infinity)

            HStack {
                ForEach(
                    GlassStyle.allCases,
                    id: \.self
                ) { style in
                    Button {
                        // Placeholder — appointment flow is out of scope for the shell.
                    } label: {
                        Text("ultraThinMaterial (0.6)")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.glassProminentIfAvailable(style))
                    .background(.ultraThinMaterial.opacity(0.6), in: RoundedRectangle(cornerRadius: 26))
                }
            }
            .frame(maxWidth: .infinity)

            HStack {
                ForEach(
                    GlassStyle.allCases,
                    id: \.self
                ) { style in
                    Button {
                        // Placeholder — appointment flow is out of scope for the shell.
                    } label: {
                        Text("ultraThinMaterial")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.glassProminentIfAvailable(style))
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 26))
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

@available(iOS 26.0, *)
private struct GlassViewContainer: View {
    var body: some View {
        HStack {
            ForEach(
                GlassStyle.allCases,
                id: \.self
            ) { style in
                GlassEffectContainer(spacing: 40.0) {
                    HStack(spacing: 20.0) {
                        Image(systemName: "scribble.variable")
                            .frame(width: 80.0, height: 80.0)
                            .font(.system(size: 36))
                            .glassEffect(style.glassStyle)
                            .offset(x: 10.0, y: 0.0)

                        Image(systemName: "eraser.fill")
                            .frame(width: 80.0, height: 80.0)
                            .font(.system(size: 36))
                            .glassEffect(style.glassStyle)
                            .offset(x: -10.0, y: 0.0)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct GlassViewsDemo: View {
    var body: some View {
        HStack {
            ForEach(
                GlassStyle.allCases,
                id: \.self
            ) { style in
                VStack(spacing: 6) {
                    Text("Blood type")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(MockProfile.bloodType)
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(.red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .playgroundGlass(glass: style, cornerRadius: 24)
            }
        }
        .frame(maxWidth: .infinity)
    }
}


private struct BloodTypeCard: View {
    var body: some View {
        VStack(spacing: 6) {
            Text("Blood type")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(MockProfile.bloodType)
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundStyle(.red)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .playgroundGlass(glass: .regular, cornerRadius: 24)
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
        .playgroundGlass(glass: .regular, cornerRadius: 18)
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
        .buttonStyle(.glassProminentIfAvailable(.regular))
    }
}

// MARK: - Liquid Glass with iOS 18 fallback (branch-local helper)

extension View {
    /// Liquid Glass on iOS 26, graceful Material fallback on earlier versions.
    @ViewBuilder
    func playgroundGlass(glass: GlassStyle, cornerRadius: CGFloat) -> some View {
        if #available(iOS 26, *) {
            self.glassEffect(glass.glassStyle, in: RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}

extension PrimitiveButtonStyle where Self == GlassProminentIfAvailableButtonStyle {
    static func glassProminentIfAvailable(
        _ style: GlassStyle
    ) -> GlassProminentIfAvailableButtonStyle {
        GlassProminentIfAvailableButtonStyle(style)
    }
}

struct GlassProminentIfAvailableButtonStyle: PrimitiveButtonStyle {
    let style: GlassStyle

     init(_ style: GlassStyle) {
        self.style = style
    }

     func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26, *) {
            Button(configuration).buttonStyle(.glass(style == .clear ? .clear : .regular))
        } else {
            Button(configuration).buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ProfileScreen()
}
