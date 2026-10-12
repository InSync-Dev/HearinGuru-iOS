import SwiftUI

struct LearnView: View {

    @State private var query       = ""
    @State private var selectedCat = "All topics"

    private let categories = ["All topics", "Hearing Loss", "Prevention", "For Families", "FAQ"]

    private let articleIcons: [Color] = [
        AppTheme.primaryContainer,
        AppTheme.primaryContainer,
        AppTheme.secondaryContainer,
        AppTheme.tertiaryContainer,
        AppTheme.primaryContainer,
        AppTheme.errorContainer,
        AppTheme.secondaryContainer,
        AppTheme.tertiaryContainer,
    ]

    private var visibleArticles: [(index: Int, article: ArticleFullContent)] {
        articleContents.enumerated().filter { _, article in
            let matchesSearch = query.isEmpty || article.title.localizedCaseInsensitiveContains(query)
            let matchesCat = selectedCat == "All topics" || article.meta.localizedCaseInsensitiveContains(selectedCat)
            return matchesSearch && matchesCat
        }.map { ($0, $1) }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search articles...", text: $query)
                    if !query.isEmpty {
                        Button { query = "" } label: {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(AppTheme.surfaceLow)
                .clipShape(Capsule())
                .overlay(Capsule().strokeBorder(Color.gray.opacity(0.2), lineWidth: 1))
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 10)

                // Category chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            Button { selectedCat = cat } label: {
                                Text(cat)
                                    .font(.system(size: 13, weight: .semibold))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(selectedCat == cat ? AppTheme.primary : AppTheme.surfaceLow)
                                    .foregroundStyle(selectedCat == cat ? .white : .primary)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule().strokeBorder(
                                            selectedCat == cat ? AppTheme.primary : Color.gray.opacity(0.2),
                                            lineWidth: 1
                                        )
                                    )
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }

                if visibleArticles.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40, weight: .thin))
                            .foregroundStyle(.secondary)
                        Text("No articles found")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                } else {
                    // Featured card (first visible article)
                    if let first = visibleArticles.first {
                        NavigationLink(destination: ArticleDetailView(article: first.article)) {
                            FeaturedArticleCard(article: first.article)
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .padding(.horizontal, 16)
                    }

                    Spacer().frame(height: 8)

                    // ALL ARTICLES label
                    Text("ALL ARTICLES")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.secondary)
                        .tracking(0.8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)

                    // Article list
                    VStack(spacing: 0) {
                        ForEach(Array(visibleArticles.dropFirst().enumerated()), id: \.1.index) { i, item in
                            NavigationLink(destination: ArticleDetailView(article: item.article)) {
                                ArticleRow(
                                    article: item.article,
                                    bgColor: articleIcons[item.index % articleIcons.count]
                                )
                            }
                            .buttonStyle(.plain)

                            if i < visibleArticles.count - 2 {
                                Divider().padding(.leading, 90)
                            }
                        }
                    }
                    .background(AppTheme.surfaceLow)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 16)
                }

                Spacer().frame(height: 24)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Learn")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Featured card

private struct FeaturedArticleCard: View {
    let article: ArticleFullContent

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Gradient header
            ZStack(alignment: .topLeading) {
                AppTheme.primaryGradient.frame(height: 130)
                Image(systemName: article.icon)
                    .font(.system(size: 54, weight: .thin))
                    .foregroundStyle(.white.opacity(0.22))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text("GUIDE")
                    .font(.system(size: 11, weight: .heavy))
                    .tracking(0.4)
                    .foregroundStyle(AppTheme.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.white.opacity(0.92))
                    .clipShape(Capsule())
                    .padding(12)
            }
            .clipShape(
                .rect(
                    topLeadingRadius: 16,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 16
                )
            )

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.primary)
                    .lineSpacing(2)
                Text(article.meta)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .background(AppTheme.surfaceLow)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.gray.opacity(0.12), lineWidth: 1))
    }
}


// MARK: - Article row

private struct ArticleRow: View {
    let article: ArticleFullContent
    let bgColor: Color

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(bgColor)
                    .frame(width: 60, height: 60)
                Image(systemName: article.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(AppTheme.primary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .lineSpacing(2)
                Text(article.meta)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}


#Preview {
    NavigationStack { LearnView() }
}
