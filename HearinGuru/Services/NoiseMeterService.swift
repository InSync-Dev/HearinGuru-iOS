import AVFoundation
import Combine

final class NoiseMeterService: ObservableObject {

    @Published var isMonitoring = false
    @Published var dbLevel: Float   = 30
    @Published var riskLevel: RiskLevel = .safe

    private var engine    = AVAudioEngine()
    private var isRunning = false

    enum RiskLevel: String {
        case safe     = "Safe"
        case moderate = "Moderate"
        case loud     = "Loud"
        case danger   = "Dangerous"

        var color: String {
            switch self {
            case .safe:     return "green"
            case .moderate: return "yellow"
            case .loud:     return "orange"
            case .danger:   return "red"
            }
        }

        static func from(db: Float) -> RiskLevel {
            switch db {
            case ..<70:  return .safe
            case 70..<85: return .moderate
            case 85..<100: return .loud
            default:     return .danger
            }
        }
    }


    // MARK: - Control

    func start() {
        guard !isRunning else { return }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.record)
            try session.setActive(true)

            engine = AVAudioEngine()
            engine.prepare()
            try engine.start()
            installTap()
            isRunning   = true
            isMonitoring = true
        } catch {
            print("[NoiseMeterService] error: \(error)")
        }
    }

    func stop() {
        guard isRunning else { return }
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        isRunning    = false
        isMonitoring = false
    }


    // MARK: - Tap

    private func installTap() {
        let input  = engine.inputNode
        let format = input.outputFormat(forBus: 0)

        input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard let self else { return }
            let channelData = buffer.floatChannelData?[0]
            let frameLength = Int(buffer.frameLength)
            guard let data = channelData, frameLength > 0 else { return }

            var sum: Float = 0
            for i in 0..<frameLength { sum += data[i] * data[i] }
            let rms = sqrt(sum / Float(frameLength))
            let db  = rms > 0 ? 20 * log10(rms) + 94 : 30  // SPL offset approx

            DispatchQueue.main.async {
                let clampedDb = max(30, min(120, db))
                self.dbLevel    = clampedDb
                self.riskLevel  = RiskLevel.from(db: clampedDb)
            }
        }
    }
}
