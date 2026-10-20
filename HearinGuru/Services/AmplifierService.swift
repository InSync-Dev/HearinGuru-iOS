import AVFoundation
import Combine

final class AmplifierService: ObservableObject {

    @Published var isOn:     Bool  = false
    @Published var gain:     Float = 1.5
    @Published var dbLevel:  Float = -60

    private var engine     = AVAudioEngine()
    private var mixerNode  = AVAudioMixerNode()
    private var isRunning  = false
    private var tapInstalled = false


    // MARK: - Control

    func start() {
        guard !isRunning else { return }

        // Request microphone permission first — crash without it
        AVAudioApplication.requestRecordPermission { [weak self] granted in
            guard let self else { return }
            DispatchQueue.main.async {
                if granted {
                    self.startInternal()
                } else {
                    print("[AmplifierService] microphone permission denied")
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
        isOn         = false
        dbLevel      = -60
    }

    func setGain(_ value: Float) {
        gain = value
        mixerNode.outputVolume = value
    }


    // MARK: - Internal start (called after permission granted)

    private func startInternal() {
        do {
            try configureSession()
            try buildEngine()
            try engine.start()
            installTap()
            isRunning = true
            isOn      = true
        } catch {
            print("[AmplifierService] start error: \(error)")
            tearDown()
        }
    }


    // MARK: - Session

    private func configureSession() throws {
        let session = AVAudioSession.sharedInstance()
        // .default mode (not .measurement) — works on all devices
        try session.setCategory(
            .playAndRecord,
            mode: .default,
            options: [.defaultToSpeaker, .allowBluetooth, .mixWithOthers]
        )
        try session.setActive(true)
    }


    // MARK: - Engine

    private func buildEngine() throws {
        engine    = AVAudioEngine()
        mixerNode = AVAudioMixerNode()

        let input  = engine.inputNode
        let output = engine.outputNode

        // Get hardware format from input
        let inputFormat  = input.inputFormat(forBus: 0)
        let outputFormat = output.inputFormat(forBus: 0)

        guard inputFormat.sampleRate > 0 else {
            throw NSError(
                domain: "AmplifierService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid input format — microphone unavailable"]
            )
        }

        engine.attach(mixerNode)
        engine.connect(input,     to: mixerNode, format: inputFormat)
        engine.connect(mixerNode, to: output,    format: outputFormat)
        mixerNode.outputVolume = gain
        engine.prepare()
    }

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
            let db  = rms > 0 ? 20 * log10(rms) : -60

            DispatchQueue.main.async {
                self.dbLevel = max(-60, min(0, db))
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
        isOn         = false
        engine       = AVAudioEngine()
        mixerNode    = AVAudioMixerNode()
    }
}
