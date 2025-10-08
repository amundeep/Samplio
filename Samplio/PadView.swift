import SwiftUI

struct PadView: View {
    let pad: Pad
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            content
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
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
            .overlay(glowOverlay)
            .shadow(
                color: .black.opacity(isPressed ? 0.15 : 0.35),
                radius: isPressed ? 2 : 8,
                x: 0,
                y: isPressed ? 1 : 4
            )
    }

    @ViewBuilder
    private var glowOverlay: some View {
        if isPressed {
            let base = RoundedRectangle(cornerRadius: 12, style: .continuous)
            base
                .stroke(Color.red.opacity(0.9), lineWidth: 4)
                .blur(radius: 6)
                .overlay(
                    base
                        .stroke(Color.red.opacity(0.6), lineWidth: 10)
                        .blur(radius: 12)
                )
                .overlay(
                    base
                        .stroke(Color.red.opacity(0.3), lineWidth: 16)
                        .blur(radius: 20)
                )
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
