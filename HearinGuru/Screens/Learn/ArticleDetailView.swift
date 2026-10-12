import SwiftUI

struct ArticleDetailView: View {

    let article: ArticleFullContent

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // Hero
                ZStack(alignment: .bottomLeading) {
                    AppTheme.primaryGradient
                        .frame(height: 180)

                    Image(systemName: article.icon)
                        .font(.system(size: 80, weight: .thin))
                        .foregroundStyle(.white.opacity(0.15))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(article.meta)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.white.opacity(0.15))
                            .clipShape(Capsule())

                        Text(article.title)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .lineSpacing(4)
                    }
                    .padding(20)
                }

                // Content
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(Array(article.sections.enumerated()), id: \.0) { _, section in
                        VStack(alignment: .leading, spacing: 8) {
                            if let heading = section.heading {
                                Text(heading)
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundStyle(.primary)
                            }
                            Text(section.body)
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary)
                                .lineSpacing(5)
                        }
                    }
                }
                .padding(20)

                Spacer().frame(height: 32)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    NavigationStack {
        ArticleDetailView(article: articleContents[0])
    }
}
