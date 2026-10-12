import SwiftUI

enum AppTheme {

    // MARK: - Brand colours
    static let primary   = Color(red: 0.11, green: 0.44, blue: 0.85)
    static let secondary = Color(red: 0.10, green: 0.67, blue: 0.60)
    static let tertiary  = Color(red: 0.60, green: 0.32, blue: 0.71)
    static let error     = Color(red: 0.82, green: 0.18, blue: 0.18)

    // MARK: - Container colours (light/dark adaptive)
    static let primaryContainer   = Color(red: 0.85, green: 0.92, blue: 1.00)
    static let secondaryContainer = Color(red: 0.82, green: 0.95, blue: 0.93)
    static let tertiaryContainer  = Color(red: 0.94, green: 0.88, blue: 0.99)
    static let errorContainer     = Color(red: 1.00, green: 0.88, blue: 0.88)

    // MARK: - Surface colours
    static let surfaceLow = Color(UIColor.secondarySystemBackground)
    static let surface    = Color(UIColor.systemBackground)
    static let surfaceContainer = Color(UIColor.tertiarySystemBackground)

    // MARK: - Gradients
    static let primaryGradient = LinearGradient(
        colors: [primary, secondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let secondaryGradient = LinearGradient(
        colors: [secondary, tertiary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let tertiaryGradient = LinearGradient(
        colors: [tertiary, primary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}


// MARK: - Reusable card modifier
struct CardModifier: ViewModifier {
    var cornerRadius: CGFloat = 16
    var padding: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .background(AppTheme.surfaceLow)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
            .padding(.horizontal, padding)
    }
}


// MARK: - Trust badge
struct TrustBadge: View {
    let label: String

    var body: some View {
        Text(label)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(AppTheme.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(AppTheme.secondaryContainer)
            .clipShape(Capsule())
    }
}


// MARK: - Section header
struct SectionHeader: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(AppTheme.primary)
                .font(.system(size: 16, weight: .semibold))
            Text(title)
                .font(.system(size: 16, weight: .bold))
        }
        .padding(.horizontal, 16)
    }
}


// MARK: - Press-scale button style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}


extension View {
    func cardStyle(cornerRadius: CGFloat = 16, hPadding: CGFloat = 16) -> some View {
        self.modifier(CardModifier(cornerRadius: cornerRadius, padding: hPadding))
    }
}
