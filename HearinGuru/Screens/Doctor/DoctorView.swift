import SwiftUI

struct DoctorView: View {

    @State private var name     = ""
    @State private var phone    = ""
    @State private var concern  = ""
    @State private var submitted = false

    private let whatsappNumber = "917010000000"
    private let phoneNumber    = "+917010000000"

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Doctor hero
                ZStack(alignment: .bottomLeading) {
                    AppTheme.primaryGradient.frame(height: 200)
                    Image(systemName: "stethoscope")
                        .font(.system(size: 80, weight: .thin))
                        .foregroundStyle(.white.opacity(0.15))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Talk to a Specialist")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Free · Confidential · Within 24 hours")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(20)
                }

                VStack(spacing: 16) {

                    // Flow steps
                    HStack {
                        FlowStep(title: "You share\nyour concern")
                        Image(systemName: "chevron.right").foregroundStyle(AppTheme.primary).font(.system(size: 14))
                        FlowStep(title: "Specialist\ncalls you")
                        Image(systemName: "chevron.right").foregroundStyle(AppTheme.primary).font(.system(size: 14))
                        FlowStep(title: "You get\na solution")
                    }
                    .padding(14)
                    .background(AppTheme.primaryContainer)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 16)

                    // Headline
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Struggling to hear?")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        Text("A specialist will listen, review your concern, and guide you — at no cost.")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .lineSpacing(3)
                        HStack(spacing: 8) {
                            TrustBadge(label: "100% Free")
                            TrustBadge(label: "Within 24 hrs")
                            TrustBadge(label: "Private")
                        }
                        .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)

                    // Call CTA
                    Button {
                        if let url = URL(string: "tel:\(phoneNumber)") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "phone.fill")
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Call a Doctor Now")
                                    .font(.system(size: 15, weight: .bold))
                                Text("Talk to a specialist right away")
                                    .font(.system(size: 11))
                                    .opacity(0.8)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .frame(height: 56)
                        .background(AppTheme.primary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 16)
                    }
                    .buttonStyle(ScaleButtonStyle())

                    // WhatsApp CTA
                    Button {
                        let message = "Hi+HearinGuru%2C+I+need+help+with+my+hearing."
                        if let url = URL(string: "https://wa.me/\(whatsappNumber)?text=\(message)") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "message.fill")
                            Text("Chat on WhatsApp")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(AppTheme.primary, lineWidth: 1.5)
                        )
                        .foregroundStyle(AppTheme.primary)
                        .padding(.horizontal, 16)
                    }
                    .buttonStyle(ScaleButtonStyle())

                    Divider().padding(.horizontal, 16)

                    // Contact form
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Or send us a message")
                            .font(.system(size: 17, weight: .bold))
                        Text("We'll call you back within 24 hours.")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)

                        if submitted {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(AppTheme.secondary)
                                Text("Request received! We'll call you within 24 hours.")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.primary)
                            }
                            .padding(16)
                            .background(AppTheme.secondaryContainer)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        } else {
                            VStack(spacing: 10) {
                                TextField("Full name", text: $name)
                                    .padding(12)
                                    .background(AppTheme.surfaceLow)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.2)))

                                TextField("Phone number", text: $phone)
                                    .keyboardType(.phonePad)
                                    .padding(12)
                                    .background(AppTheme.surfaceLow)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.2)))

                                ZStack(alignment: .topLeading) {
                                    if concern.isEmpty {
                                        Text("Describe your hearing concern")
                                            .foregroundStyle(.secondary)
                                            .padding(12)
                                    }
                                    TextEditor(text: $concern)
                                        .frame(height: 90)
                                        .padding(8)
                                        .scrollContentBackground(.hidden)
                                }
                                .background(AppTheme.surfaceLow)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.2)))

                                Button {
                                    if !name.isEmpty && !phone.isEmpty {
                                        submitted = true
                                    }
                                } label: {
                                    Label("Request Callback", systemImage: "paperplane.fill")
                                        .font(.system(size: 15, weight: .bold))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 52)
                                        .background(name.isEmpty || phone.isEmpty ? Color.gray.opacity(0.3) : AppTheme.primary)
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                                .disabled(name.isEmpty || phone.isEmpty)
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 32)
                }
                .padding(.top, 16)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Doctor")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Flow step

private struct FlowStep: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 11, weight: .semibold))
            .multilineTextAlignment(.center)
            .foregroundStyle(AppTheme.primary)
            .frame(maxWidth: .infinity)
    }
}


#Preview {
    NavigationStack { DoctorView() }
}
