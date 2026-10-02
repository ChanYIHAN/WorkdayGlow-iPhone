import SwiftUI

struct WidgetLibraryView: View {
    @State private var selectedCategory: WidgetTemplateCategory = .featured
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 18) {
                    libraryHeader

                    TemplateCategoryStrip(selection: $selectedCategory)
                        .padding(.top, 6)

                    if filteredTemplates.isEmpty {
                        ContentUnavailableView.search(text: searchText)
                            .padding(.top, 48)
                    } else {
                        ForEach(filteredTemplates) { template in
                            TemplateNavigationCard(template: template)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 28)
            }
            .background(AppCanvas())
            .navigationTitle("组件库")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "搜索时间、健康、天气或行情")
            .navigationDestination(for: WidgetTemplateKind.self) { template in
                WidgetTemplateDetailView(template: template)
            }
        }
    }

    private var libraryHeader: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 17, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color("SkyGlow"), Color("AuroraLavender")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Image(systemName: "square.grid.3x3.square")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 54, height: 54)

            VStack(alignment: .leading, spacing: 3) {
                Text("150 款原创模板")
                    .font(.headline)
                Text("按场景筛选，也可以直接搜索")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(WidgetTemplateCategory.allCases.count - 1) 类")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.accentColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.accentColor.opacity(0.1), in: Capsule())
        }
        .padding(16)
        .appGlassSurface(cornerRadius: 24)
    }

    private var filteredTemplates: [WidgetTemplateKind] {
        let source = WidgetTemplateKind.templates(for: selectedCategory)
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return source }
        return source.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
                $0.subtitle.localizedCaseInsensitiveContains(query) ||
                $0.category.title.localizedCaseInsensitiveContains(query)
        }
    }
}
