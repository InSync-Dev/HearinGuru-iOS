import SwiftUI

private struct AidType: Identifiable {
    let id       = UUID()
    let abbrev:  String
    let name:    String
    let tagline: String
    let priceRange: String
    let bestFor: String
    let pros: [String]
    let cons: [String]
}

private struct BrandInfo: Identifiable {
    let id = UUID()
    let name: String
    let origin: String
    let segment: String
}

private struct FaqItem: Identifiable {
    let id       = UUID()
    let question: String
    let answer:   String
}

private let aidTypes: [AidType] = [
    AidType(abbrev: "BTE", name: "Behind-the-Ear",      tagline: "Versatile & powerful",  priceRange: "₹15,000 – ₹1,20,000", bestFor: "Mild to profound loss",          pros: ["Long battery life", "Easy to handle", "Powerful amplification"],      cons: ["Visible behind ear", "May whistle with glasses"]),
    AidType(abbrev: "RIC", name: "Receiver-in-Canal",   tagline: "Discreet & natural",     priceRange: "₹25,000 – ₹2,00,000", bestFor: "Mild to severe loss",            pros: ["Nearly invisible", "Natural sound", "Comfortable fit"],                cons: ["Receiver exposed to moisture", "Higher cost"]),
    AidType(abbrev: "ITE", name: "In-the-Ear",          tagline: "Easy to wear",           priceRange: "₹20,000 – ₹1,50,000", bestFor: "Mild to moderately severe loss", pros: ["Easy to insert", "Volume control on shell", "Good for arthritis"],     cons: ["More visible", "May feel occluded"]),
    AidType(abbrev: "CIC", name: "Completely-in-Canal", tagline: "Maximum discretion",     priceRange: "₹40,000 – ₹2,50,000", bestFor: "Mild to moderate loss",          pros: ["Nearly invisible", "Reduced wind noise", "Natural feel"],              cons: ["Tiny batteries", "No manual controls", "Not for severe loss"]),
]

private let brands: [BrandInfo] = [
    BrandInfo(name: "Phonak",          origin: "Swiss",    segment: "Mid–Premium"),
    BrandInfo(name: "Signia",          origin: "German",   segment: "Mid–Premium"),
    BrandInfo(name: "Widex",           origin: "Danish",   segment: "Premium"),
    BrandInfo(name: "Starkey",         origin: "American", segment: "Mid–Premium"),
    BrandInfo(name: "ReSound",         origin: "Danish",   segment: "Mid–Premium"),
    BrandInfo(name: "Oticon",          origin: "Danish",   segment: "Premium"),
    BrandInfo(name: "Siemens / Signia",origin: "German",   segment: "Mid"),
    BrandInfo(name: "Unitron",         origin: "Canadian", segment: "Entry–Mid"),
    BrandInfo(name: "Bernafon",        origin: "Swiss",    segment: "Mid"),
    BrandInfo(name: "Interton",        origin: "Danish",   segment: "Entry"),
]

private let faqs: [FaqItem] = [
    FaqItem(question: "Do I really need a prescription?",
            answer: "In India, a hearing aid can be purchased over the counter, but a professional hearing evaluation ensures you get the right model and fitting for your specific hearing loss pattern."),
    FaqItem(question: "How long do hearing aids last?",
            answer: "Most hearing aids last 5–7 years with proper maintenance. Daily cleaning, moisture protection, and regular audiologist visits extend lifespan significantly."),
    FaqItem(question: "Are there government subsidies?",
            answer: "Yes. The ADIP scheme by the Ministry of Social Justice provides free or subsidised hearing aids to persons with disability below the income threshold. Contact your local district rehabilitation centre."),
    FaqItem(question: "Bluetooth vs non-Bluetooth — which is better?",
            answer: "Bluetooth hearing aids stream audio directly from phones and TVs, which is very convenient. However, they cost more and drain batteries faster. For most first-time users, a quality non-BT model is a practical start."),
]

struct HearingAidsView: View {

    var onSeeDoctor: () -> Void = {}

    @State private var selectedAidIndex = 0
    @State private var expandedFaqIndex: Int? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Hero
                ZStack {
                    LinearGradient(
                        colors: [AppTheme.primaryContainer, AppTheme.tertiaryContainer],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    VStack(spacing: 8) {
                        Image(systemName: "ear.and.waveform")
                            .font(.system(size: 44, weight: .thin))
                            .foregroundStyle(AppTheme.primary)
                        Text("Hearing Aid Guide")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.primary)
                        Text("Types · Brands · Prices · FAQs")
                            .font(.system(size: 14))
                            .foregroundStyle(AppTheme.primary.opacity(0.8))
                    }
                    .padding(32)
                }
                .frame(height: 160)

                VStack(spacing: 24) {

                    // Aid types
                    VStack(spacing: 12) {
                        SectionHeader(icon: "square.grid.2x2", title: "Types of Hearing Aids")
                            .padding(.top, 20)

                        // Type selector
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(aidTypes.indices, id: \.self) { i in
                                    Button { selectedAidIndex = i } label: {
                                        Text(aidTypes[i].abbrev)
                                            .font(.system(size: 13, weight: .semibold))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 7)
                                            .background(selectedAidIndex == i ? AppTheme.primary : AppTheme.surfaceLow)
                                            .foregroundStyle(selectedAidIndex == i ? .white : .primary)
                                            .clipShape(Capsule())
                                            .overlay(
                                                Capsule().strokeBorder(
                                                    selectedAidIndex == i ? AppTheme.primary : Color.gray.opacity(0.2),
                                                    lineWidth: 1
                                                )
                                            )
                                    }
                                    .buttonStyle(ScaleButtonStyle())
                                }
                            }
                            .padding(.horizontal, 16)
                        }

                        // Detail card
                        AidDetailCard(aid: aidTypes[selectedAidIndex])
                            .padding(.horizontal, 16)
                    }

                    // Price table
                    VStack(spacing: 12) {
                        SectionHeader(icon: "indianrupeesign", title: "Price Ranges in India")
                        PriceTableView()
                    }

                    // Brands
                    VStack(spacing: 12) {
                        SectionHeader(icon: "star", title: "Popular Brands")
                        VStack(spacing: 0) {
                            ForEach(brands) { brand in
                                BrandRowView(brand: brand)
                                if brand.id != brands.last?.id { Divider().padding(.leading, 68) }
                            }
                        }
                        .background(AppTheme.surfaceLow)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 16)
                    }

                    // FAQs
                    VStack(spacing: 12) {
                        SectionHeader(icon: "questionmark.circle", title: "Frequently Asked Questions")
                        VStack(spacing: 8) {
                            ForEach(faqs.indices, id: \.self) { i in
                                FaqCardView(
                                    faq:        faqs[i],
                                    isExpanded: expandedFaqIndex == i,
                                    onToggle:   { expandedFaqIndex = expandedFaqIndex == i ? nil : i }
                                )
                                .padding(.horizontal, 16)
                            }
                        }
                    }

                    // CTA
                    VStack(spacing: 12) {
                        Image(systemName: "stethoscope")
                            .font(.system(size: 32, weight: .thin))
                            .foregroundStyle(AppTheme.primary)
                        Text("Not sure which hearing aid suits you?")
                            .font(.system(size: 16, weight: .bold))
                            .multilineTextAlignment(.center)
                        Text("Our audiologists can guide you to the right fit for your hearing loss, budget, and lifestyle.")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        NavigationLink(destination: DoctorView()) {
                            Label("Book Free Consultation", systemImage: "calendar")
                                .font(.system(size: 15, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppTheme.primary)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                    .padding(20)
                    .background(AppTheme.primaryContainer)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 24)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Hearing Aids")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Aid detail card

private struct AidDetailCard: View {
    let aid: AidType

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppTheme.primaryContainer)
                        .frame(width: 52, height: 52)
                    Text(aid.abbrev)
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(AppTheme.primary)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(aid.name).font(.system(size: 16, weight: .bold))
                    Text(aid.tagline).font(.system(size: 13)).foregroundStyle(.secondary)
                }
            }

            Divider()

            HStack {
                Label(aid.priceRange, systemImage: "indianrupeesign")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            HStack {
                Label(aid.bestFor, systemImage: "person.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }

            Divider()

            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pros").font(.system(size: 13, weight: .bold)).foregroundStyle(AppTheme.secondary)
                    ForEach(aid.pros, id: \.self) {
                        Text("• \($0)").font(.system(size: 12)).foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Cons").font(.system(size: 13, weight: .bold)).foregroundStyle(AppTheme.error)
                    ForEach(aid.cons, id: \.self) {
                        Text("• \($0)").font(.system(size: 12)).foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .background(AppTheme.surfaceLow)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.gray.opacity(0.12), lineWidth: 1))
    }
}


// MARK: - Price table

private struct PriceTableView: View {
    private let rows: [(String, String, String)] = [
        ("Entry",    "Basic amplification, mono",     "₹8,000 – ₹25,000"),
        ("Mid",      "Digital, directional mics",      "₹25,000 – ₹80,000"),
        ("Advanced", "Noise reduction, BT ready",      "₹80,000 – ₹1,80,000"),
        ("Premium",  "AI processing, rechargeable",    "₹1,80,000 – ₹3,50,000"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Segment").frame(maxWidth: .infinity, alignment: .leading)
                Text("Features").frame(maxWidth: .infinity, alignment: .leading)
                Text("Price").frame(maxWidth: .infinity, alignment: .trailing)
            }
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(AppTheme.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(AppTheme.primaryContainer)

            ForEach(rows.indices, id: \.self) { i in
                let row = rows[i]
                HStack {
                    Text(row.0)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(AppTheme.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(row.1)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(row.2)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(i % 2 == 0 ? AppTheme.surface : AppTheme.surfaceLow)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.15), lineWidth: 1))
        .padding(.horizontal, 16)
    }
}


// MARK: - Brand row

private struct BrandRowView: View {
    let brand: BrandInfo

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppTheme.secondaryContainer)
                    .frame(width: 40, height: 40)
                Text(String(brand.name.prefix(2)).uppercased())
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(AppTheme.secondary)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(brand.name).font(.system(size: 14, weight: .semibold))
                Text(brand.origin).font(.system(size: 12)).foregroundStyle(.secondary)
            }
            Spacer()
            Text(brand.segment)
                .font(.system(size: 11, weight: .semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(AppTheme.primaryContainer)
                .foregroundStyle(AppTheme.primary)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}


// MARK: - FAQ card

private struct FaqCardView: View {
    let faq: FaqItem
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(faq.question)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(AppTheme.primary)
                }
                .padding(16)

                if isExpanded {
                    Divider().padding(.horizontal, 16)
                    Text(faq.answer)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                        .padding(16)
                }
            }
            .background(AppTheme.surfaceLow)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.gray.opacity(0.12), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.25), value: isExpanded)
    }
}


#Preview {
    NavigationStack { HearingAidsView() }
}
