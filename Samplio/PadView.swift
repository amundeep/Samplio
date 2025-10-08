import SwiftUI

struct PadView: View {
    let pad: Pad
    let action: () -> Void

    @State private var isPressed = false
    @State private var hasFiredPress = false

    var body: some View {
        Button(action: {}) {
            content
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        if !hasFiredPress {
                            hasFiredPress = true
                            action()
                        }
                    }
                }
                .onEnded { _ in
                    isPressed = false
                    hasFiredPress = false
                }
        )
        .accessibilityLabel(Text(pad.title))
    }

    @ViewBuilder
    private var content: some View {
        ZStack {
            padBackground
            Text(pad.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .shadow(radius: 1)
        }
        .background(underGlow)
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.15, dampingFraction: 0.7), value: isPressed)
    }

    @ViewBuilder
    private var padBackground: some View {
        let base = RoundedRectangle(cornerRadius: 12, style: .continuous)

        base
            .fill(Color.gray.gradient)
            .overlay(
                base.stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .shadow(
                color: .black.opacity(isPressed ? 0.15 : 0.35),
                radius: isPressed ? 2 : 8,
                x: 0,
                y: isPressed ? 1 : 4
            )
    }

    @ViewBuilder
    private var underGlow: some View {
        if isPressed {
            let base = RoundedRectangle(cornerRadius: 12, style: .continuous)

            // A very tight, bright rim glow
            base
                .inset(by: -3) // minimal spread
                .stroke(Color.red.opacity(1.0), lineWidth: 4)
                .blur(radius: 6)
                .overlay(
                    base
                        .inset(by: -4)
                        .stroke(Color.red.opacity(0.9), lineWidth: 8)
                        .blur(radius: 10)
                )
                // Dramatic falloff via masked gradient ring
                .overlay(
                    base
                        .inset(by: -5)
                        .stroke(Color.red, lineWidth: 14)
                        .blur(radius: 14)
                        .mask(
                            base
                                .inset(by: -5)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.white, Color.white.opacity(0.4), Color.clear],
                                        startPoint: .center,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 14
                                )
                        )
                )
                .blendMode(.plusLighter)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    PadView(pad: Pad(title: "Kick", color: .red, sampleName: "Kick")) {}
        .frame(width: 100, height: 100)
        .padding()
        .background(Color.black)
}
