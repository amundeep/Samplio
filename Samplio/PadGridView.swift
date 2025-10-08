import SwiftUI

struct PadGridView: View {
    @StateObject private var audio = AudioEngine()
    @State private var pads: [Pad] = .mpcDefaultGrid()
    @State private var displayText: String = "Ready"

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        VStack(spacing: 12) {
            Spacer(minLength: 8)
            // Display area
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                Text(displayText)
                    .font(.title3.monospaced())
                    .foregroundStyle(.white.opacity(0.9))
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)

            // 4x4 grid
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(pads) { pad in
                    PadView(pad: pad) {
                        audio.playSample(named: pad.sampleName)
                        displayText = "Played: \(pad.title)"
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color(white: 0.06).ignoresSafeArea())
    }
}

#Preview {
    NavigationStack { PadGridView() }
}
