import AVFoundation
import Combine

final class NoiseMeterService: ObservableObject {

    @Published var isMonitoring = false
    @Published var dbLevel: Float   = 30
    @Published var riskLevel: RiskLevel = .safe

    private var engine       = AVAudioEngine()
    private var isRunning    = false
    private var tapInstalled = false

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
            case ..<70:       return .safe
            case 70..<85:     return .moderate
            case 85..<100:    return .loud
            default:          return .danger
            }
        }
    }


    // MARK: - Control

    func start() {
        guard !isRunning else { return }

        // Request microphone permission first
        AVAudioApplication.requestRecordPermission { [weak self] granted in
            guard let self else { return }
            DispatchQueue.main.async {
                if granted {
                    self.startInternal()
                } else {
                    print("[NoiseMeterService] microphone permission denied")
                }
            }
        }
    }

    func stop() {
        guard isRunning else { return }
        removeTapSafely()
        engine.stop()
        isRunning    = false
        tapInstalled = false
        isMonitoring = false
    }


    // MARK: - Internal start

    private func startInternal() {
        do {
            let session = AVAudioSession.sharedInstance()
            // Use .playAndRecord + .mixWithOthers so noise meter doesn't kill tinnitus playback
            try session.setCategory(
                .playAndRecord,
                mode: .measurement,
                options: [.mixWithOthers, .defaultToSpeaker]
            )
            try session.setActive(true)

            engine = AVAudioEngine()
            let inputFormat = engine.inputNode.inputFormat(forBus: 0)

            guard inputFormat.sampleRate > 0 else {
                print("[NoiseMeterService] invalid input format — mic unavailable")
                return
            }

            engine.prepare()
            try engine.start()
            installTap()
            isRunning    = true
            isMonitoring = true
        } catch {
            print("[NoiseMeterService] error: \(error)")
            tearDown()
        }
    }


    // MARK: - Tap

    private func installTap() {
        guard !tapInstalled else { return }
        let input  = engine.inputNode
        let format = input.inputFormat(forBus: 0)

        input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard let self else { return }
            guard let channelData = buffer.floatChannelData?[0] else { return }
            let frameLength = Int(buffer.frameLength)
            guard frameLength > 0 else { return }

            var sum: Float = 0
            for i in 0..<frameLength { sum += channelData[i] * channelData[i] }
            let rms = sqrt(sum / Float(frameLength))
            // +94 dB offset approximates FS dBFS → dB SPL conversion
            let db  = rms > 0 ? 20 * log10(rms) + 94 : 30

            DispatchQueue.main.async {
                let clamped = max(30, min(120, db))
                self.dbLevel   = clamped
                self.riskLevel = RiskLevel.from(db: clamped)
            }
        }
        tapInstalled = true
    }

    private func removeTapSafely() {
        guard tapInstalled else { return }
        engine.inputNode.removeTap(onBus: 0)
        tapInstalled = false
    }

    private func tearDown() {
        if engine.isRunning { engine.stop() }
        tapInstalled = false
        isRunning    = false
        isMonitoring = false
        engine       = AVAudioEngine()
    }
}
