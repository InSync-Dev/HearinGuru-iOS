import AVFoundation
import Combine

final class AmplifierService: ObservableObject {

    @Published var isOn      = false
    @Published var gain: Float = 1.5
    @Published var dbLevel: Float = -60

    private var engine     = AVAudioEngine()
    private var mixerNode  = AVAudioMixerNode()
    private var isRunning  = false


    // MARK: - Control

    func start() {
        guard !isRunning else { return }
        do {
            try configureSession()
            buildEngine()
            try engine.start()
            installTap()
            isRunning = true
            isOn      = true
        } catch {
            print("[AmplifierService] start error: \(error)")
        }
    }

    func stop() {
        guard isRunning else { return }
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        isRunning = false
        isOn      = false
        dbLevel   = -60
    }

    func setGain(_ value: Float) {
        gain = value
        mixerNode.outputVolume = value
    }


    // MARK: - Setup

    private func configureSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(
            .playAndRecord,
            mode: .measurement,
            options: [.defaultToSpeaker, .allowBluetooth]
        )
        try session.setActive(true)
    }

    private func buildEngine() {
        engine    = AVAudioEngine()
        mixerNode = AVAudioMixerNode()

        let input  = engine.inputNode
        let output = engine.outputNode
        let format = input.outputFormat(forBus: 0)

        engine.attach(mixerNode)
        engine.connect(input, to: mixerNode, format: format)
        engine.connect(mixerNode, to: output, format: format)
        mixerNode.outputVolume = gain
        engine.prepare()
    }

    private func installTap() {
        let input  = engine.inputNode
        let format = input.outputFormat(forBus: 0)

        input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard let self else { return }
            let channelData = buffer.floatChannelData?[0]
            let frameLength = Int(buffer.frameLength)
            guard let data = channelData, frameLength > 0 else { return }

            var sum: Float = 0
            for i in 0..<frameLength {
                sum += data[i] * data[i]
            }
            let rms = sqrt(sum / Float(frameLength))
            let db  = rms > 0 ? 20 * log10(rms) : -60

            DispatchQueue.main.async {
                self.dbLevel = max(-60, min(0, db))
            }
        }
    }
}
