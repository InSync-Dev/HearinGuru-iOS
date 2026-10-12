import SwiftUI

struct SoundAmplifierView: View {

    @EnvironmentObject private var service: AmplifierService

    @State private var gain: Float    = 1.5
    @State private var noiseReduction = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Player card
                VStack(spacing: 16) {
                    Image(systemName: service.isOn ? "speaker.wave.3.fill" : "speaker.slash.fill")
                        .font(.system(size: 44, weight: .thin))
                        .foregroundStyle(service.isOn ? .white : .white.opacity(0.5))
                        .animation(.easeInOut(duration: 0.3), value: service.isOn)

                    Text(service.isOn ? "Amplifying" : "Off")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    // dB level bar
                    if service.isOn {
                        LevelBar(level: service.dbLevel)
                    }

                    // Play/Stop button
                    Button {
                        if service.isOn {
                            service.stop()
                        } else {
                            service.setGain(gain)
                            service.start()
                        }
                    } label: {
                        Image(systemName: service.isOn ? "stop.fill" : "play.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(service.isOn ? Color(red: 0.1, green: 0.1, blue: 0.15) : .white)
                            .frame(width: 68, height: 68)
                            .background(service.isOn ? Color.white.opacity(0.85) : AppTheme.secondary)
                            .clipShape(Circle())
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.08, green: 0.08, blue: 0.18), Color(red: 0.14, green: 0.20, blue: 0.36)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .padding(.horizontal, 16)

                // Gain control
                ControlCard(title: "Amplification") {
                    HStack(spacing: 12) {
                        Image(systemName: "speaker.fill")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 14))
                        Slider(value: $gain, in: 1.0...4.0, step: 0.1) { _ in
                            if service.isOn { service.setGain(gain) }
                        }
                        .tint(AppTheme.secondary)
                        Text("\(Int((gain - 1) / 3 * 100))%")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(AppTheme.secondary)
                            .frame(width: 38, alignment: .trailing)
                    }
                }

                // Noise reduction toggle
                ControlCard(title: "Settings") {
                    Toggle(isOn: $noiseReduction) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Noise Reduction")
                                .font(.system(size: 14, weight: .medium))
                            Text("Filter background noise from mic")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .tint(AppTheme.secondary)
                }

                // Info card
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(AppTheme.primary)
                    Text("Your microphone picks up nearby sounds and plays them through your headphones in real time, making voices and conversations clearer.")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .lineSpacing(3)
                }
                .padding(14)
                .background(AppTheme.primaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 16)

                Spacer().frame(height: 24)
            }
            .padding(.top, 16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Sound Amplifier")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { service.stop() }
    }
}


// MARK: - Level bar

private struct LevelBar: View {
    let level: Float  // -60 to 0

    private var fraction: CGFloat {
        CGFloat((level + 60) / 60)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.15)).frame(height: 6)
                Capsule()
                    .fill(LinearGradient(colors: [AppTheme.secondary, AppTheme.primary], startPoint: .leading, endPoint: .trailing))
                    .frame(width: max(6, geo.size.width * fraction), height: 6)
            }
        }
        .frame(height: 6)
        .padding(.horizontal, 8)
    }
}


// MARK: - Control card

struct ControlCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.secondary)
                .tracking(0.8)
            content()
        }
        .padding(16)
        .background(AppTheme.surfaceLow)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
}


#Preview {
    NavigationStack { SoundAmplifierView() }
        .environmentObject(AmplifierService())
}
