import SwiftUI

private struct AppNotification: Identifiable {
    let id       = UUID()
    let icon:    String
    let bgColor: Color
    let title:   String
    let body:    String
    let time:    String
    let isUnread: Bool
}

struct NotificationsView: View {

    @State private var notifications: [AppNotification] = [
        AppNotification(icon: "ear",               bgColor: AppTheme.primaryContainer,   title: "Take your weekly hearing check",     body: "It only takes 5 minutes. Track how your hearing changes over time.",                    time: "Today",      isUnread: true),
        AppNotification(icon: "speaker.slash.fill", bgColor: AppTheme.secondaryContainer, title: "Protect your ears today",            body: "Noise levels in your area are high. Consider using earplugs.",                          time: "Yesterday",  isUnread: true),
        AppNotification(icon: "waveform",           bgColor: AppTheme.tertiaryContainer,  title: "Tinnitus tip",                       body: "Try 20 minutes of pink noise before bed. It helps many people fall asleep faster.",       time: "2 days ago", isUnread: false),
        AppNotification(icon: "book",               bgColor: AppTheme.primaryContainer,   title: "New article: Tinnitus causes & relief", body: "Our audiologists published a comprehensive guide on managing tinnitus.",              time: "3 days ago", isUnread: false),
        AppNotification(icon: "stethoscope",        bgColor: AppTheme.errorContainer,     title: "Your free consultation is available", body: "A HearinGuru specialist is ready to speak with you — no appointment needed.",          time: "1 week ago", isUnread: false),
        AppNotification(icon: "checkmark.circle",   bgColor: AppTheme.secondaryContainer, title: "Hearing test complete",              body: "You took a hearing test. View your results in the Tools tab.",                          time: "1 week ago", isUnread: false),
    ]

    private var unreadCount: Int { notifications.filter(\.isUnread).count }

    var body: some View {
        List {
            ForEach(notifications) { notification in
                NotificationRow(notification: notification)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(
                        notification.isUnread
                            ? AppTheme.primaryContainer.opacity(0.25)
                            : AppTheme.surface
                    )
            }
        }
        .listStyle(.plain)
        .background(Color(.systemGroupedBackground))
        .navigationTitle(unreadCount > 0 ? "Notifications (\(unreadCount))" : "Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if unreadCount > 0 {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Mark all read") {
                        notifications = notifications.map {
                            AppNotification(
                                icon: $0.icon, bgColor: $0.bgColor,
                                title: $0.title, body: $0.body,
                                time: $0.time, isUnread: false
                            )
                        }
                    }
                    .font(.system(size: 13))
                }
            }
        }
    }
}


// MARK: - Row

private struct NotificationRow: View {
    let notification: AppNotification

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(notification.bgColor)
                    .frame(width: 48, height: 48)
                Image(systemName: notification.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(.primary)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(notification.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if notification.isUnread {
                        Circle()
                            .fill(AppTheme.primary)
                            .frame(width: 8, height: 8)
                    }
                }
                Text(notification.body)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
                    .lineLimit(3)
                Text(notification.time)
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
                    .padding(.top, 2)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}


#Preview {
    NavigationStack { NotificationsView() }
}
