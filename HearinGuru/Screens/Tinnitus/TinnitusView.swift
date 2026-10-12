import SwiftUI

private struct SoundOption: Identifiable {
    let id    = UUID()
    let index: Int
    let name: String
    let description: String
    let emoji: String
    let subtitle: String
}

struct TinnitusView: View {

    @EnvironmentObject private var service: AudioService

    @State private var volume: Float = 0.65
    @State private var selectedTimer = "30 min"

    private let sounds: [SoundOption] = [
        SoundOption(index: 0, name: "White Noise",  description: "Gentle broad sound · Relieves ringing", emoji: "🌫️", subtitle: "Good for tinnitus"),
        SoundOption(index: 1, name: "Pink Noise",   description: "Warm natural sound · Relaxing",         emoji: "🌸", subtitle: "Warm, natural feel"),
        SoundOption(index: 2, name: "Ocean Waves",  description: "Rhythm of the sea · Sleep aid",          emoji: "🌊", subtitle: "Calming, for sleep"),
        SoundOption(index: 3, name: "Rainfall",     description: "Steady rain sounds · Focus",             emoji: "🌧️", subtitle: "Steady, peaceful"),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Player card
                VStack(spacing: 0) {
                    Text("NOW PLAYING")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white.opacity(0.4))
                        .tracking(1)

                    Spacer().frame(height: 8)

                    Text(sounds[service.selectedSoundIndex].name)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text(sounds[service.selectedSoundIndex].description)
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.5))

                    Spacer().frame(height: 20)

                    // Wave bars
                    HStack(spacing: 3) {
                        ForEach(0..<9, id: \.self) { i in
                            TinnitusWaveBar(index: i, isPlaying: service.tinnitusPlaying)
                        }
                    }
                    .frame(height: 48)

                    Spacer().frame(height: 22)

                    // Transport controls
                    HStack(spacing: 28) {
                        Button {
                            let prev = (service.selectedSoundIndex - 1 + sounds.count) % sounds.count
                            service.startTinnitus(soundIndex: prev, volume: volume)
                        } label: {
                            Image(systemName: "backward.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(.white)
                                .frame(width: 52, height: 52)
                                .background(.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        .buttonStyle(ScaleButtonStyle())

                        Button {
                            if service.tinnitusPlaying {
                                service.stopTinnitus()
                            } else {
                                service.startTinnitus(soundIndex: service.selectedSoundIndex, volume: volume)
                            }
                        } label: {
                            Image(systemName: service.tinnitusPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.15))
                                .frame(width: 68, height: 68)
                                .background(Color(red: 0.73, green: 0.84, blue: 1.0))
                                .clipShape(Circle())
                        }
                        .buttonStyle(ScaleButtonStyle())

                        Button {
                            let next = (service.selectedSoundIndex + 1) % sounds.count
                            service.startTinnitus(soundIndex: next, volume: volume)
                        } label: {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(.white)
                                .frame(width: 52, height: 52)
                                .background(.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.10, green: 0.10, blue: 0.18))
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .padding(.horizontal, 16)

                // Volume
                ControlCard(title: "Volume") {
                    HStack(spacing: 12) {
                        Image(systemName: "speaker.fill").foregroundStyle(.secondary).font(.system(size: 14))
                        Slider(value: $volume, in: 0.1...1.0, step: 0.01) { _ in
                            service.setVolume(volume)
                        }
                        .tint(AppTheme.primary)
                        Text("\(Int(volume * 100))%")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(AppTheme.primary)
                            .frame(width: 38, alignment: .trailing)
                    }
                }

                // Sound selection grid
                VStack(alignment: .leading, spacing: 8) {
                    Text("CHOOSE A SOUND")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                        .tracking(0.8)
                        .padding(.horizontal, 16)

                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                        spacing: 10
                    ) {
                        ForEach(sounds) { sound in
                            let isSelected = service.selectedSoundIndex == sound.index
                            Button {
                                service.startTinnitus(soundIndex: sound.index, volume: volume)
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(sound.emoji).font(.system(size: 28))
                                    Text(sound.name)
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundStyle(.primary)
                                    Text(sound.subtitle)
                                        .font(.system(size: 12))
                                        .foregroundStyle(.secondary)
                                }
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(isSelected ? AppTheme.primaryContainer : AppTheme.surfaceLow)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(
                                            isSelected ? AppTheme.primary : Color.gray.opacity(0.2),
                                            lineWidth: isSelected ? 1.5 : 1
                                        )
                                )
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                }

                // Auto-stop timer
                VStack(alignment: .leading, spacing: 8) {
                    Text("AUTO STOP AFTER")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                        .tracking(0.8)
                        .padding(.horizontal, 16)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(["15 min", "30 min", "1 hour", "2 hours", "Off"], id: \.self) { option in
                                Button {
                                    selectedTimer = option
                                } label: {
                                    Text(option)
                                        .font(.system(size: 13, weight: .semibold))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(selectedTimer == option ? AppTheme.primary : AppTheme.surfaceLow)
                                        .foregroundStyle(selectedTimer == option ? .white : .primary)
                                        .clipShape(Capsule())
                                        .overlay(
                                            Capsule().strokeBorder(
                                                selectedTimer == option ? AppTheme.primary : Color.gray.opacity(0.2),
                                                lineWidth: 1
                                            )
                                        )
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }

                Spacer().frame(height: 24)
            }
            .padding(.top, 16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Tinnitus Relief")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Wave bar

private struct TinnitusWaveBar: View {
    let index: Int
    let isPlaying: Bool

    private let baseHeights: [CGFloat] = [10, 22, 38, 28, 14, 34, 38, 20, 10]

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color(red: 0.73, green: 0.84, blue: 1.0).opacity(0.8))
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


#Preview {
    NavigationStack { TinnitusView() }
        .environmentObject(AudioService())
}
