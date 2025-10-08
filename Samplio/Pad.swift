import Foundation
import SwiftUI

struct Pad: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var color: Color
    var sampleName: String // without extension
}

extension Array where Element == Pad {
    static func mpcDefaultGrid() -> [Pad] {
        // Precompute any colors with modifiers to help the type-checker
        let gray60 = Color.gray.opacity(0.6)
        let black60 = Color.black.opacity(0.6)

        // Give the array an explicit element type to reduce inference work
        let names: [(title: String, color: Color)] = [
            ("Kick", .red), ("Snare", .orange), ("HiHat", .yellow), ("Clap", .green),
            ("Tom1", .mint), ("Tom2", .teal), ("Rim", .cyan), ("Cowbell", .blue),
            ("Shaker", .indigo), ("Ride", .purple), ("Crash", .pink), ("Perc1", .brown),
            ("Perc2", .gray), ("Vox1", gray60), ("Vox2", black60), ("FX", .black)
        ]
        return names.map { pair in
            Pad(title: pair.title, color: pair.color, sampleName: pair.title)
        }
    }
}
