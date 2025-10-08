import Foundation
import AVFoundation
import Combine

final class AudioEngine: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    
    private let engine = AVAudioEngine()
    private let mixer = AVAudioMixerNode()
    private var players: [String: AVAudioPlayerNode] = [:]
    private let session = AVAudioSession.sharedInstance()

    init() {
        setupSession()
        setupEngine()
    }

    private func setupSession() {
        do {
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }

    private func setupEngine() {
        engine.attach(mixer)
        engine.connect(mixer, to: engine.mainMixerNode, format: engine.mainMixerNode.outputFormat(forBus: 0))
        start()
    }

    func start() {
        if !engine.isRunning {
            do { try engine.start() } catch { print("Engine failed to start: \(error)") }
        }
    }

    func stop() {
        engine.stop()
    }

    // All nodes are connected with explicit formats; fallback click matches downstream channel count.
    // Load and play a bundled audio file by name (without extension). If not found, play a short click.
    func playSample(named name: String, withExtension ext: String = "wav") {
        let key = "\(name).\(ext)"
        let player = players[key] ?? {
            let p = AVAudioPlayerNode()
            engine.attach(p)
            engine.connect(p, to: mixer, format: mixer.outputFormat(forBus: 0))
            players[key] = p
            return p
        }()

        if let url = Bundle.main.url(forResource: name, withExtension: ext) {
            do {
                let file = try AVAudioFile(forReading: url)
                player.stop()
                player.scheduleFile(file, at: nil, completionHandler: nil)
                if !player.isPlaying { player.play() }
            } catch {
                print("Failed to play sample \(key): \(error)")
                playFallbackClick(on: player)
            }
        } else {
            // Placeholder: play a generated click so tapping pads gives feedback without assets
            playFallbackClick(on: player)
        }
    }

    private func playFallbackClick(on player: AVAudioPlayerNode) {
        let outputFormat: AVAudioFormat
        if let connFormat = engine.outputConnectionPoints(for: player, outputBus: 0).first?.node?.outputFormat(forBus: 0) {
            outputFormat = connFormat
        } else {
            // Fallback to mixer's output if connection points are not available
            outputFormat = mixer.outputFormat(forBus: 0)
        }

        let channels = Int(outputFormat.channelCount)
        let sampleRate = outputFormat.sampleRate
        let duration: Double = 0.03 // 30ms click
        let frameCount = AVAudioFrameCount(sampleRate * duration)

        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: AVAudioChannelCount(channels)),
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            return
        }

        buffer.frameLength = frameCount

        // Fill all channels with the same mono click signal
        for ch in 0..<channels {
            if let ptr = buffer.floatChannelData?[ch] {
                for i in 0..<Int(frameCount) {
                    let t = Float(i) / Float(frameCount)
                    ptr[i] = (1.0 - t) * 0.5
                }
            }
        }

        player.stop()
        player.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
        if !player.isPlaying { player.play() }
    }
}
