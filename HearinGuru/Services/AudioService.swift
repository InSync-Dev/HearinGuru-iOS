import AVFoundation
import Combine

final class AudioService: NSObject, ObservableObject {

    @Published var tinnitusPlaying = false
    @Published var selectedSoundIndex = 0
    @Published var volume: Float = 0.65

    private var engine        = AVAudioEngine()
    private var sourceNode:   AVAudioSourceNode?
    private var mixerNode     = AVAudioMixerNode()
    private var pinkGenerator = PinkNoiseGenerator()
    private var phase:        Double = 0

    override init() {
        super.init()
        configureSession()
    }


    // MARK: - Session

    private func configureSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers]
            )
            try session.setActive(true)
        } catch {
            print("[AudioService] session error: \(error)")
        }
    }


    // MARK: - Tinnitus control

    func startTinnitus(soundIndex: Int, volume: Float) {
        selectedSoundIndex = soundIndex
        self.volume        = volume
        stopEngine()
        buildAndStartEngine(soundIndex: soundIndex, volume: volume)
        tinnitusPlaying = true
    }

    func stopTinnitus() {
        stopEngine()
        tinnitusPlaying = false
    }

    func setVolume(_ value: Float) {
        volume = value
        mixerNode.outputVolume = value
    }


    // MARK: - Engine

    private func buildAndStartEngine(soundIndex: Int, volume: Float) {
        engine = AVAudioEngine()
        pinkGenerator = PinkNoiseGenerator()
        phase = 0

        let format = AVAudioFormat(
            standardFormatWithSampleRate: 44100,
            channels: 1
        )!

        mixerNode = AVAudioMixerNode()
        engine.attach(mixerNode)

        let renderBlock: AVAudioSourceNodeRenderBlock = { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self else { return noErr }
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let sample = self.generateSample(soundIndex: soundIndex)
                for buffer in ablPointer {
                    let buf = buffer.mData!.assumingMemoryBound(to: Float.self)
                    buf[frame] = sample
                }
            }
            return noErr
        }

        sourceNode = AVAudioSourceNode(format: format, renderBlock: renderBlock)
        engine.attach(sourceNode!)
        engine.connect(sourceNode!, to: mixerNode, format: format)
        engine.connect(mixerNode, to: engine.mainMixerNode, format: format)
        mixerNode.outputVolume = volume

        do {
            engine.prepare()
            try engine.start()
        } catch {
            print("[AudioService] engine start error: \(error)")
        }
    }

    private func stopEngine() {
        engine.stop()
        if let node = sourceNode {
            engine.detach(node)
            sourceNode = nil
        }
    }

    private func generateSample(soundIndex: Int) -> Float {
        switch soundIndex {
        case 0: return Float.random(in: -1.0...1.0) * 0.3           // White noise
        case 1: return pinkGenerator.next() * 0.4                    // Pink noise
        case 2: return oceanWaveSample()                             // Ocean
        case 3: return rainSample()                                  // Rainfall
        default: return Float.random(in: -1.0...1.0) * 0.3
        }
    }

    private var waveEnvelope: Double = 0
    private var waveEnvelopeDir: Double = 1
    private var waveSampleCount = 0

    private func oceanWaveSample() -> Float {
        waveSampleCount += 1
        if waveSampleCount % 512 == 0 {
            waveEnvelope += waveEnvelopeDir * 0.002
            if waveEnvelope > 1 { waveEnvelopeDir = -1 }
            if waveEnvelope < 0 { waveEnvelopeDir = 1 }
        }
        let noise = Float.random(in: -1.0...1.0)
        return noise * Float(waveEnvelope) * 0.35
    }

    private var rainPhase: Double = 0

    private func rainSample() -> Float {
        let noise = pinkGenerator.next()
        rainPhase += 0.0003
        let mod = 0.5 + 0.5 * sin(rainPhase)
        return noise * Float(mod) * 0.3
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
        let pink = (b[0]+b[1]+b[2]+b[3]+b[4]+b[5]+b[6]+white*0.5362) * 0.11
        b[6] = white * 0.115926
        return max(-1, min(1, pink))
    }
}
