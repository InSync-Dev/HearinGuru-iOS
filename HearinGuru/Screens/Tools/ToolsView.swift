import SwiftUI

private struct CarouselSlide: Identifiable {
    let id   = UUID()
    let eyebrow: String
    let title: String
    let chipLabel: String
    let chipIcon: String
    let destination: AnyView
    let gradient: LinearGradient
}

private struct ToolTile: Identifiable {
    let id   = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let iconBg: Color
    let iconTint: Color
    let destination: AnyView
}


struct ToolsView: View {

    @State private var carouselIndex = 0

    private var slides: [CarouselSlide] {[
        CarouselSlide(
            eyebrow:     "Free · 5 minutes",
            title:       "Check your\nhearing today",
            chipLabel:   "Start test",
            chipIcon:    "play.fill",
            destination: AnyView(HearingTestView()),
            gradient:    AppTheme.primaryGradient
        ),
        CarouselSlide(
            eyebrow:     "Boost · Real-time",
            title:       "Hear every\nconversation clearly",
            chipLabel:   "Open amplifier",
            chipIcon:    "speaker.wave.3.fill",
            destination: AnyView(SoundAmplifierView()),
            gradient:    AppTheme.secondaryGradient
        ),
        CarouselSlide(
            eyebrow:     "Relief · Calming sounds",
            title:       "Quiet the\nringing in your ears",
            chipLabel:   "Start relief",
            chipIcon:    "waveform",
            destination: AnyView(TinnitusView()),
            gradient:    AppTheme.tertiaryGradient
        ),
    ]}

    private var tools: [ToolTile] {[
        ToolTile(
            icon:        "ear",
            title:       "Hearing Test",
            subtitle:    "Check how well you hear in 5 min",
            iconBg:      AppTheme.primaryContainer,
            iconTint:    AppTheme.primary,
            destination: AnyView(HearingTestView())
        ),
        ToolTile(
            icon:        "speaker.wave.3.fill",
            title:       "Sound Amplifier",
            subtitle:    "Boost voices, reduce background noise",
            iconBg:      AppTheme.secondaryContainer,
            iconTint:    AppTheme.secondary,
            destination: AnyView(SoundAmplifierView())
        ),
        ToolTile(
            icon:        "waveform.path.ecg",
            title:       "Noise Meter",
            subtitle:    "Is your environment safe for your ears?",
            iconBg:      AppTheme.tertiaryContainer,
            iconTint:    AppTheme.tertiary,
            destination: AnyView(NoiseMeterView())
        ),
        ToolTile(
            icon:        "waveform",
            title:       "Tinnitus Relief",
            subtitle:    "Soothing sounds to quiet the ringing",
            iconBg:      AppTheme.errorContainer,
            iconTint:    AppTheme.error,
            destination: AnyView(TinnitusView())
        ),
    ]}

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer().frame(height: 8)

                // Carousel
                carousel

                // Dot indicators
                HStack(spacing: 6) {
                    ForEach(slides.indices, id: \.self) { i in
                        Circle()
                            .fill(i == carouselIndex ? AppTheme.primary : Color.gray.opacity(0.3))
                            .frame(width: i == carouselIndex ? 8 : 5)
                            .animation(.spring(response: 0.3), value: carouselIndex)
                    }
                }
                .padding(.top, 10)

                // Tool tiles
                VStack(alignment: .leading, spacing: 8) {
                    Text("FREE TOOLS")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.secondary)
                        .tracking(0.8)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)

                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                        spacing: 10
                    ) {
                        ForEach(tools) { tile in
                            NavigationLink(destination: tile.destination) {
                                ToolTileCard(tile: tile)
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                }

                Spacer().frame(height: 24)
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear { startAutoAdvance() }
    }


    // MARK: - Carousel

    @ViewBuilder
    private var carousel: some View {
        TabView(selection: $carouselIndex) {
            ForEach(slides.indices, id: \.self) { index in
                let slide = slides[index]
                NavigationLink(destination: slide.destination) {
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(slide.gradient)

                        VStack(alignment: .leading, spacing: 0) {
                            Text(slide.eyebrow.uppercased())
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white.opacity(0.75))
                                .tracking(0.8)

                            Spacer().frame(height: 6)

                            Text(slide.title)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .lineSpacing(4)

                            Spacer().frame(height: 16)

                            Label(slide.chipLabel, systemImage: slide.chipIcon)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(.white.opacity(0.18))
                                .clipShape(Capsule())
                        }
                        .padding(20)
                    }
                    .frame(height: 175)
                }
                .buttonStyle(ScaleButtonStyle())
                .padding(.horizontal, 16)
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 175)
    }


    // MARK: - Auto-advance

    private func startAutoAdvance() {
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.4)) {
                carouselIndex = (carouselIndex + 1) % slides.count
            }
        }
    }
}


// MARK: - Tool tile card

private struct ToolTileCard: View {
    let tile: ToolTile

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(tile.iconBg)
                    .frame(width: 48, height: 48)
                Image(systemName: tile.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(tile.iconTint)
            }

            Spacer().frame(height: 10)

            // FREE badge
            Text("FREE")
                .font(.system(size: 10, weight: .heavy))
                .foregroundStyle(Color(red: 0.17, green: 0.36, blue: 0.21))
                .tracking(0.4)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color(red: 0.78, green: 0.91, blue: 0.80))
                .clipShape(Capsule())

            Spacer().frame(height: 4)

            Text(tile.title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.primary)

            Spacer().frame(height: 3)

            Text(tile.subtitle)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.surfaceLow)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }
}


#Preview {
    NavigationStack { ToolsView() }
        .environmentObject(AudioService())
}
