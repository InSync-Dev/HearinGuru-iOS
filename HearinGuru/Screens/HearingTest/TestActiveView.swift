import SwiftUI
import AVFoundation

struct TestActiveView: View {

    @Environment(\.dismiss) private var dismiss

    // Frequencies tested (Hz) and which ear
    private let testSequence: [(freq: Double, ear: String)] = [
        (1000, "Left"), (2000, "Left"), (4000, "Left"),
        (1000, "Right"), (2000, "Right"), (4000, "Right"),
        (500,  "Left"), (500, "Right"),
        (8000, "Left"), (8000, "Right"),
    ]

    @State private var currentStep  = 0
    @State private var isPlaying    = false
    @State private var results: [TestResult] = []
    @State private var buttonPressed = false
    @State private var testComplete  = false

    @State private var audioPlayer: AVAudioPlayer?
    @State private var toneEngine = AVAudioEngine()

    // Current tone level in dB HL (starts at 40 dB, adaptive)
    @State private var currentLevel: Float = 40

    var body: some View {
        Group {
            if testComplete {
                TestResultView(results: results)
            } else {
                testUI
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") { dismiss() }
                    .foregroundStyle(.secondary)
            }
        }
        .onAppear { startNextTone() }
        .onDisappear { stopTone() }
    }

    @ViewBuilder
    private var testUI: some View {
        VStack(spacing: 0) {

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color.gray.opacity(0.15))
                    Rectangle()
                        .fill(AppTheme.primary)
                        .frame(width: geo.size.width * CGFloat(currentStep) / CGFloat(testSequence.count))
                        .animation(.easeInOut(duration: 0.4), value: currentStep)
                }
            }
            .frame(height: 4)

            Spacer()

            // Ear indicator
            let step = currentStep < testSequence.count ? testSequence[currentStep] : testSequence.last!
            VStack(spacing: 6) {
                Text("LISTENING · \(step.ear.uppercased()) EAR")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.secondary)
                    .tracking(1.2)
                Text("\(Int(step.freq)) Hz")
                    .font(.system(size: 48, weight: .thin, design: .rounded))
                    .foregroundStyle(AppTheme.primary)
            }

            Spacer()

            // Wave animation
            HStack(spacing: 3) {
                ForEach(0..<9, id: \.self) { i in
                    WaveBar(index: i, isPlaying: isPlaying)
                }
            }
            .frame(height: 48)

            Spacer()

            // Instruction
            Text(isPlaying ? "Press the button when you hear the tone" : "Get ready…")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            // Big hear button
            Button {
                handleHeard()
            } label: {
                ZStack {
                    Circle()
                        .fill(buttonPressed ? AppTheme.primary : AppTheme.primaryContainer)
                        .frame(width: 140, height: 140)
                        .shadow(color: AppTheme.primary.opacity(0.3), radius: 12, y: 4)
                    VStack(spacing: 4) {
                        Image(systemName: "ear.fill")
                            .font(.system(size: 36))
                        Text("I HEAR IT")
                            .font(.system(size: 12, weight: .bold))
                            .tracking(0.6)
                    }
                    .foregroundStyle(buttonPressed ? .white : AppTheme.primary)
                }
            }
            .buttonStyle(ScaleButtonStyle())
            .disabled(!isPlaying)

            Spacer()

            // Step counter
            Text("Step \(currentStep + 1) of \(testSequence.count)")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)

            Spacer().frame(height: 40)
        }
        .background(Color(.systemGroupedBackground))
    }


    // MARK: - Test logic

    private func startNextTone() {
        guard currentStep < testSequence.count else {
            testComplete = true
            return
        }

        isPlaying = false
        buttonPressed = false

        // Short delay then play tone
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            playTone(
                frequency: testSequence[currentStep].freq,
                ear: testSequence[currentStep].ear,
                level: currentLevel
            )
            isPlaying = true

            // Auto-advance if not pressed within 3 seconds (no response = didn't hear)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if isPlaying {
                    recordResult(heard: false)
                }
            }
        }
    }

    private func handleHeard() {
        guard isPlaying else { return }
        withAnimation(.spring(response: 0.2)) { buttonPressed = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            recordResult(heard: true)
        }
    }

    private func recordResult(heard: Bool) {
        guard currentStep < testSequence.count else { return }
        stopTone()
        isPlaying = false

        let step = testSequence[currentStep]
        results.append(TestResult(
            frequency: step.freq,
            ear: step.ear,
            dbLevel: currentLevel,
            heard: heard
        ))

        currentStep += 1
        if currentStep >= testSequence.count {
            testComplete = true
        } else {
            startNextTone()
        }
    }

    private func playTone(frequency: Double, ear: String, level: Float) {
        stopTone()
        toneEngine = AVAudioEngine()

        let sampleRate: Double = 44100
        var phase: Double = 0
        let angularFrequency = 2 * .pi * frequency / sampleRate
        let amplitude = Double(pow(10, (level - 100) / 20))

        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 2)!

        let sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let sample = Float(sin(phase) * amplitude)
                phase += angularFrequency
                if phase > 2 * .pi { phase -= 2 * .pi }
                for buffer in ablPointer {
                    let buf = buffer.mData!.assumingMemoryBound(to: Float.self)
                    buf[frame] = sample
                }
            }
            return noErr
        }

        toneEngine.attach(sourceNode)
        toneEngine.connect(sourceNode, to: toneEngine.mainMixerNode, format: format)

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            toneEngine.prepare()
            try toneEngine.start()
        } catch {
            print("[TestActiveView] tone error: \(error)")
        }
    }

    private func stopTone() {
        toneEngine.stop()
    }
}


// MARK: - Wave bar animation

private struct WaveBar: View {
    let index: Int
    let isPlaying: Bool

    private let baseHeights: [CGFloat] = [10, 22, 38, 28, 14, 34, 38, 20, 10]

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(AppTheme.primary.opacity(0.7))
            .frame(width: 4, height: isPlaying ? baseHeights[index] : 6)
            .animation(
                isPlaying
                    ? .easeInOut(duration: 0.7 + Double(index) * 0.06)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.08)
                    : .default,
                value: isPlaying
            )
    }
}


// MARK: - Result model

struct TestResult {
    let frequency: Double
    let ear: String
    let dbLevel: Float
    let heard: Bool
}


#Preview {
    NavigationStack { TestActiveView() }
}
