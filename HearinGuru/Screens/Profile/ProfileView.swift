import SwiftUI

struct ProfileView: View {

    @State private var notificationsEnabled   = true
    @State private var weeklyReminderEnabled  = true

    var body: some View {
        List {

            // Avatar header
            Section {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.primaryGradient)
                            .frame(width: 64, height: 64)
                        Text("HG")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Profile")
                            .font(.system(size: 18, weight: .bold))
                        Text("Manage your hearing health journey")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }

            // Hearing health
            Section("Hearing Health") {
                ProfileInfoRow(icon: "ear", label: "Last test result", value: "Not yet taken", valueColor: .secondary)
                ProfileInfoRow(icon: "calendar", label: "Tests completed", value: "0", valueColor: .secondary)
                NavigationLink(destination: HearingTestView()) {
                    Label("Take a hearing test", systemImage: "play.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppTheme.primary)
                }
            }

            // Notifications
            Section("Notifications") {
                Toggle(isOn: $notificationsEnabled) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Push notifications")
                                .font(.system(size: 14, weight: .medium))
                            Text("Reminders and health tips")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "bell.fill")
                            .foregroundStyle(AppTheme.primary)
                    }
                }
                .tint(AppTheme.primary)

                Toggle(isOn: $weeklyReminderEnabled) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Weekly hearing reminder")
                                .font(.system(size: 14, weight: .medium))
                            Text("Every Monday at 9 AM")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(AppTheme.primary)
                    }
                }
                .tint(AppTheme.primary)
            }

            // About & support
            Section("About & Support") {
                ProfileNavRow(icon: "info.circle.fill",  label: "About HearinGuru")
                ProfileNavRow(icon: "lock.fill",          label: "Privacy Policy")
                ProfileNavRow(icon: "questionmark.circle.fill", label: "Help & FAQ")
                ProfileNavRow(icon: "star.fill",          label: "Rate this app")
            }

            // Version
            Section {
                HStack(spacing: 12) {
                    Image(systemName: "ear.and.waveform")
                        .foregroundStyle(AppTheme.primary)
                        .font(.system(size: 18))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("HearinGuru")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Version 1.0.0 · Hearing health for everyone")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Row helpers

private struct ProfileInfoRow: View {
    let icon: String
    let label: String
    let value: String
    var valueColor: Color = .primary

    var body: some View {
        HStack {
            Label(label, systemImage: icon)
                .font(.system(size: 14))
                .foregroundStyle(.primary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(valueColor)
        }
    }
}

private struct ProfileNavRow: View {
    let icon: String
    let label: String

    var body: some View {
        Button {} label: {
            Label(label, systemImage: icon)
                .font(.system(size: 14))
                .foregroundStyle(.primary)
        }
    }
}


#Preview {
    NavigationStack { ProfileView() }
}
