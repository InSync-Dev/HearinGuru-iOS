import AVFoundation
import Combine

final class AudioService: NSObject, ObservableObject {

    @Published var tinnitusPlaying    = false
    @Published var selectedSoundIndex = 0
    @Published var volume: Float      = 0.65

    private var engine    = AVAudioEngine()
    private var mixerNode = AVAudioMixerNode()

    // Mutable audio state lives here — captured by render block, never touched by main thread.
    // This eliminates the data race that caused EXC_BAD_ACCESS.
    private final class NoiseState {
        var pink         = PinkNoiseGenerator()
        var waveEnvelope: Double = 0
        var waveDir:      Double = 1
        var sampleCount:  Int    = 0
        var rainPhase:    Double = 0
    }

    override init() {
        super.init()
        setupSessionAndObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    // MARK: - Session + observers

    private func setupSessionAndObservers() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("[AudioService] session setup error: \(error)")
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption(_:)),
            name:     AVAudioSession.interruptionNotification,
            object:   nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleConfigChange),
            name:     .AVAudioEngineConfigurationChange,
            object:   nil
        )
    }

    @objc private func handleInterruption(_ notification: Notification) {
        guard
            let info = notification.userInfo,
            let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue)
        else { return }

        DispatchQueue.main.async {
            switch type {
            case .began:
                self.tinnitusPlaying = false

            case .ended:
                // Restart if we were playing before interruption
                let optionValue = info[AVAudioSessionInterruptionOptionKey] as? UInt ?? 0
                let shouldResume = AVAudioSession.InterruptionOptions(rawValue: optionValue)
                    .contains(.shouldResume)
                if shouldResume {
                    self.startTinnitus(
                        soundIndex: self.selectedSoundIndex,
                        volume:     self.volume
                    )
                }

            @unknown default:
                break
            }
        }
    }

    @objc private func handleConfigChange() {
        // Hardware config changed (e.g. headphones plugged/unplugged)
        guard tinnitusPlaying else { return }
        let idx = selectedSoundIndex
        let vol = volume
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.startTinnitus(soundIndex: idx, volume: vol)
        }
    }


    // MARK: - Public control

    func startTinnitus(soundIndex: Int, volume: Float) {
        selectedSoundIndex = soundIndex
        self.volume        = volume
        tearDownEngine()
        buildAndStart(soundIndex: soundIndex, volume: volume)
        tinnitusPlaying = true
    }

    func stopTinnitus() {
        tearDownEngine()
        tinnitusPlaying = false
    }

    func setVolume(_ value: Float) {
        volume = value
        mixerNode.outputVolume = value
    }


    // MARK: - Engine lifecycle

    private func tearDownEngine() {
        if engine.isRunning { engine.stop() }
        // Replace engine — ARC releases the old one.
        // Do NOT call engine.detach() after stop(); the node may still
        // be referenced by the (now-finishing) render thread.
        engine    = AVAudioEngine()
        mixerNode = AVAudioMixerNode()
    }

    private func buildAndStart(soundIndex: Int, volume: Float) {
        // Fresh state for this session — render block owns it exclusively.
        let state  = NoiseState()
        let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)!

        // Render block: captures state + soundIndex by value, never captures self.
        let renderBlock: AVAudioSourceNodeRenderBlock = { _, _, frameCount, audioBufferList in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let sample = AudioService.sample(state: state, soundIndex: soundIndex)
                for buffer in ablPointer {
                    let buf = buffer.mData!.assumingMemoryBound(to: Float.self)
                    buf[frame] = sample
                }
            }
            return noErr
        }

        let sourceNode = AVAudioSourceNode(format: format, renderBlock: renderBlock)
        engine.attach(sourceNode)
        engine.attach(mixerNode)
        engine.connect(sourceNode, to: mixerNode,          format: format)
        engine.connect(mixerNode,  to: engine.mainMixerNode, format: format)
        mixerNode.outputVolume = volume

        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
            engine.prepare()
            try engine.start()
        } catch {
            print("[AudioService] engine start error: \(error)")
            tinnitusPlaying = false
        }
    }


    // MARK: - Noise generators (static — cannot accidentally capture self)

    private static func sample(state: NoiseState, soundIndex: Int) -> Float {
        switch soundIndex {
        case 0: return Float.random(in: -1.0...1.0) * 0.30      // white noise
        case 1: return state.pink.next() * 0.40                  // pink noise
        case 2: return oceanSample(state: state)                 // ocean waves
        case 3: return rainSample(state: state)                  // rainfall
        default: return Float.random(in: -1.0...1.0) * 0.30
        }
    }

    private static func oceanSample(state: NoiseState) -> Float {
        state.sampleCount += 1
        if state.sampleCount % 512 == 0 {
            state.waveEnvelope += state.waveDir * 0.002
            if state.waveEnvelope > 1 { state.waveDir = -1 }
            if state.waveEnvelope < 0 { state.waveDir =  1 }
        }
        return Float.random(in: -1.0...1.0) * Float(state.waveEnvelope) * 0.35
    }

    private static func rainSample(state: NoiseState) -> Float {
        state.rainPhase += 0.0003
        let mod = Float(0.5 + 0.5 * sin(state.rainPhase))
        return state.pink.next() * mod * 0.30
    }
}


// MARK: - Pink noise generator (Voss-McCartney algorithm)

final class PinkNoiseGenerator {
    private var b = [Float](repeating: 0, count: 7)

    func next() -> Float {
        let white = Float.random(in: -1.0...1.0)
        b[0] =  0.99886 * b[0] + white * 0.0555179
        b[1] =  0.99332 * b[1] + white * 0.0750759
        b[2] =  0.96900 * b[2] + white * 0.1538520
        b[3] =  0.86650 * b[3] + white * 0.3104856
        b[4] =  0.55000 * b[4] + white * 0.5329522
        b[5] = -0.76160 * b[5] + white * 0.0168980
        let pink = (b[0]+b[1]+b[2]+b[3]+b[4]+b[5]+b[6] + white*0.5362) * 0.11
        b[6] = white * 0.115926
        return max(-1, min(1, pink))
    }
}
