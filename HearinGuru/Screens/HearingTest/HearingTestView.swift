import SwiftUI

struct HearingTestView: View {

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Hero
                ZStack {
                    AppTheme.primaryGradient
                    VStack(spacing: 12) {
                        Image(systemName: "ear.and.waveform")
                            .font(.system(size: 56, weight: .thin))
                            .foregroundStyle(.white.opacity(0.9))
                        Text("5-Minute Hearing Test")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Free · No account required")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.75))
                    }
                    .padding(32)
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 0))

                VStack(spacing: 16) {

                    // How it works
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How it works")
                            .font(.system(size: 17, weight: .bold))
                            .padding(.horizontal, 16)

                        ForEach(steps, id: \.0) { step in
                            HStack(alignment: .top, spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(AppTheme.primaryContainer)
                                        .frame(width: 36, height: 36)
                                    Text("\(step.0)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(AppTheme.primary)
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(step.1)
                                        .font(.system(size: 14, weight: .semibold))
                                    Text(step.2)
                                        .font(.system(size: 13))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                        }
                    }

                    // Trust badges
                    HStack(spacing: 8) {
                        TrustBadge(label: "100% Free")
                        TrustBadge(label: "Private")
                        TrustBadge(label: "~5 minutes")
                    }
                    .padding(.horizontal, 16)

                    // Requirements
                    HStack(spacing: 12) {
                        Image(systemName: "headphones")
                            .foregroundStyle(AppTheme.primary)
                            .font(.system(size: 20))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Use headphones for best results")
                                .font(.system(size: 14, weight: .semibold))
                            Text("In-ear or over-ear headphones give the most accurate reading")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(14)
                    .background(AppTheme.primaryContainer)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 16)

                    // CTA
                    NavigationLink(destination: TestActiveView()) {
                        HStack(spacing: 10) {
                            Image(systemName: "play.fill")
                            Text("Start Hearing Test")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppTheme.primary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 16)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }

                Spacer().frame(height: 24)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Hearing Test")
        .navigationBarTitleDisplayMode(.inline)
    }

    private let steps: [(Int, String, String)] = [
        (1, "Find a quiet place", "Go somewhere with minimal background noise"),
        (2, "Put on headphones", "Use any headphones or earbuds you have"),
        (3, "Press when you hear a tone", "A tone will play — tap the button as soon as you hear it"),
        (4, "Get your results", "We'll show your hearing profile across frequencies"),
    ]
}


#Preview {
    NavigationStack { HearingTestView() }
}
