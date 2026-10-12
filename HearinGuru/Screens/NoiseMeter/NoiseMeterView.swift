import SwiftUI

struct NoiseMeterView: View {

    @EnvironmentObject private var service: NoiseMeterService

    private var meterColor: Color {
        switch service.riskLevel {
        case .safe:     return .green
        case .moderate: return .yellow
        case .loud:     return .orange
        case .danger:   return .red
        }
    }

    private var fraction: CGFloat {
        CGFloat((service.dbLevel - 30) / 90)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Big meter
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.12), lineWidth: 18)
                        .frame(width: 220, height: 220)

                    Circle()
                        .trim(from: 0, to: min(1, fraction))
                        .stroke(
                            meterColor,
                            style: StrokeStyle(lineWidth: 18, lineCap: .round)
                        )
                        .frame(width: 220, height: 220)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut(duration: 0.15), value: service.dbLevel)

                    VStack(spacing: 4) {
                        Text("\(Int(service.dbLevel))")
                            .font(.system(size: 56, weight: .thin, design: .rounded))
                            .foregroundStyle(meterColor)
                        Text("dB SPL")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.secondary)
                        Text(service.riskLevel.rawValue.uppercased())
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(meterColor)
                            .tracking(1.2)
                    }
                }
                .padding(.top, 24)

                // Risk level bar
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        ForEach(riskZones, id: \.label) { zone in
                            Text(zone.label)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(zone.color)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    HStack {
                        Text("30 dB")
                        Spacer()
                        Text("120 dB")
                    }
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)

                // Start/Stop button
                Button {
                    if service.isMonitoring { service.stop() } else { service.start() }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: service.isMonitoring ? "stop.fill" : "mic.fill")
                        Text(service.isMonitoring ? "Stop Monitoring" : "Start Monitoring")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(service.isMonitoring ? AppTheme.errorContainer : AppTheme.primary)
                    .foregroundStyle(service.isMonitoring ? AppTheme.error : .white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 16)
                }
                .buttonStyle(ScaleButtonStyle())

                // Reference guide
                VStack(alignment: .leading, spacing: 0) {
                    Text("REFERENCE LEVELS")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                        .tracking(0.8)
                        .padding(.bottom, 10)

                    ForEach(referenceItems, id: \.sound) { item in
                        HStack {
                            Text(item.sound)
                                .font(.system(size: 13))
                            Spacer()
                            Text(item.level)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(item.color)
                        }
                        .padding(.vertical, 8)
                        Divider()
                    }
                }
                .padding(16)
                .background(AppTheme.surfaceLow)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 16)

                Spacer().frame(height: 24)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Noise Meter")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { service.stop() }
    }

    private let riskZones: [(label: String, color: Color)] = [
        ("Safe",     .green),
        ("Moderate", .yellow),
        ("Loud",     .orange),
        ("Danger",   .red),
    ]

    private let referenceItems: [(sound: String, level: String, color: Color)] = [
        ("Whisper",              "30 dB",  .green),
        ("Normal conversation",  "60 dB",  .green),
        ("Busy traffic",         "85 dB",  .orange),
        ("Lawn mower",           "90 dB",  .orange),
        ("Concert / Club",       "110 dB", .red),
        ("Firecrackers",         "140 dB", .red),
    ]
}


#Preview {
    NavigationStack { NoiseMeterView() }
        .environmentObject(NoiseMeterService())
}
