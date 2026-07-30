import SwiftUI

struct WidgetLibraryView: View {
    @State private var selectedCategory: WidgetTemplateCategory = .featured

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 18) {
                    TemplateCategoryStrip(selection: $selectedCategory)
                        .padding(.top, 6)

                    ForEach(WidgetTemplateKind.templates(for: selectedCategory)) { template in
                        TemplateNavigationCard(template: template)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 28)
            }
            .background(Color("GalleryCanvas").ignoresSafeArea())
            .navigationTitle("组件库")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: WidgetTemplateKind.self) { template in
                WidgetTemplateDetailView(template: template)
            }
        }
    }
}
