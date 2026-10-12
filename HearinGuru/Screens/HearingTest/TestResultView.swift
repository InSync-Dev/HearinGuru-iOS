import SwiftUI

struct TestResultView: View {

    var results: [TestResult] = []

    // Derive overall level from median unheard threshold
    private var hearingProfile: HearingProfile {
        let unheard = results.filter { !$0.heard }
        if unheard.isEmpty { return .normal }
        let avgDb = unheard.map(\.dbLevel).reduce(0, +) / Float(unheard.count)
        switch avgDb {
        case ..<26:  return .normal
        case 26..<41: return .mild
        case 41..<56: return .moderate
        case 56..<71: return .moderatelySevere
        default:     return .severe
        }
    }

    enum HearingProfile: String {
        case normal           = "Normal"
        case mild             = "Mild Loss"
        case moderate         = "Moderate Loss"
        case moderatelySevere = "Moderately Severe"
        case severe           = "Severe Loss"

        var color: Color {
            switch self {
            case .normal:           return .green
            case .mild:             return Color(red: 0.6, green: 0.8, blue: 0.2)
            case .moderate:         return .orange
            case .moderatelySevere: return Color(red: 0.9, green: 0.4, blue: 0.1)
            case .severe:           return .red
            }
        }

        var emoji: String {
            switch self {
            case .normal:           return "✅"
            case .mild:             return "🟡"
            case .moderate:         return "🟠"
            case .moderatelySevere: return "🔴"
            case .severe:           return "🚨"
            }
        }

        var advice: String {
            switch self {
            case .normal:
                return "Your hearing appears to be within normal range. Keep protecting your ears from loud noise."
            case .mild:
                return "You may be missing some soft sounds and high-frequency consonants. Consider a professional hearing evaluation."
            case .moderate:
                return "You likely struggle to follow speech without visual cues in noisy settings. A hearing aid consultation is recommended."
            case .moderatelySevere:
                return "This level of hearing loss significantly affects daily communication. Please book a professional audiologist appointment."
            case .severe:
                return "Severe hearing loss detected. Please consult an audiologist or ENT specialist as soon as possible."
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer().frame(height: 8)

                // Result card
                VStack(spacing: 12) {
                    Text(hearingProfile.emoji)
                        .font(.system(size: 56))

                    Text(hearingProfile.rawValue)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(hearingProfile.color)

                    Text("Hearing Screening Result")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(AppTheme.surfaceLow)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 16)

                // Advice
                VStack(alignment: .leading, spacing: 8) {
                    Text("What this means")
                        .font(.system(size: 15, weight: .bold))
                    Text(hearingProfile.advice)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                }
                .padding(16)
                .background(AppTheme.primaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 16)

                // Frequency breakdown
                if !results.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Frequency breakdown")
                            .font(.system(size: 15, weight: .bold))
                            .padding(.horizontal, 16)

                        ForEach(Array(Set(results.map(\.ear))).sorted(), id: \.self) { ear in
                            let earResults = results.filter { $0.ear == ear }
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(ear) Ear")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 16)

                                ForEach(earResults, id: \.frequency) { result in
                                    HStack {
                                        Text("\(Int(result.frequency)) Hz")
                                            .font(.system(size: 13, weight: .medium))
                                            .frame(width: 70, alignment: .leading)
                                        Spacer()
                                        Text(result.heard ? "Heard" : "Not heard")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundStyle(result.heard ? .green : .red)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 3)
                                            .background(result.heard ? Color.green.opacity(0.12) : Color.red.opacity(0.12))
                                            .clipShape(Capsule())
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 16)
                    .background(AppTheme.surfaceLow)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 16)
                }

                // Disclaimer
                Text("This is a screening tool, not a clinical diagnosis. Results may vary based on environment and equipment. Consult a qualified audiologist for a full evaluation.")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                // CTAs
                VStack(spacing: 10) {
                    NavigationLink(destination: DoctorView()) {
                        HStack(spacing: 8) {
                            Image(systemName: "stethoscope")
                            Text("Book Free Consultation")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(AppTheme.primary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.horizontal, 16)

                    NavigationLink(destination: HearingAidsView()) {
                        HStack(spacing: 8) {
                            Image(systemName: "ear.and.waveform")
                            Text("Browse Hearing Aids")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(AppTheme.primary, lineWidth: 1.5)
                        )
                        .foregroundStyle(AppTheme.primary)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.horizontal, 16)
                }

                Spacer().frame(height: 24)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Your Results")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    NavigationStack { TestResultView() }
}
