import SwiftUI

struct DiscoveryView: View {
    @State private var selectedCategory: WidgetTemplateCategory = .featured

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    brandHeader
                    featuredStories
                    TemplateCategoryStrip(selection: $selectedCategory)

                    if selectedCategory == .featured {
                        featuredSections
                    } else {
                        filteredSection
                    }
                }
                .padding(.bottom, 28)
            }
            .background(Color("GalleryCanvas").ignoresSafeArea())
            .navigationDestination(for: WidgetTemplateKind.self) { template in
                WidgetTemplateDetailView(template: template)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var brandHeader: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color("AuroraLavender"), Color("SkyGlow"), Color("SeaGlass")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Image(systemName: "sparkles")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .frame(width: 44, height: 44)
            .shadow(color: Color("AuroraLavender").opacity(0.35), radius: 12, y: 6)

            VStack(alignment: .leading, spacing: 0) {
                Text("下班")
                    .font(.title2)
                    .fontWeight(.black)
                + Text("光轨")
                    .font(.title2)
                    .fontWeight(.regular)

                Text("把一天过得更有节奏")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "person.crop.circle.fill")
                .font(.title)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color("PlumInk"))
                .accessibilityLabel("个人设置")
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var featuredStories: some View {
        TabView {
            FeaturedStoryCard(
                template: .workdayRail,
                eyebrow: "本周精选",
                title: "让下班变得\n看得见",
                accent: Color("SeaGlass")
            )

            FeaturedStoryCard(
                template: .incomeBento,
                eyebrow: "收入主题",
                title: "每一小时\n都算数",
                accent: Color("ButterGlow")
            )

            FeaturedStoryCard(
                template: .afterworkPlan,
                eyebrow: "轻松一下",
                title: "今晚留给\n真正的生活",
                accent: Color("RoseGlow")
            )

            FeaturedStoryCard(
                template: .weatherNow,
                eyebrow: "天气系列",
                title: "把今天的天空\n放在桌面",
                accent: Color("SkyGlow")
            )
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 300)
    }

    @ViewBuilder
    private var featuredSections: some View {
        VStack(spacing: 16) {
            TemplateSectionHeader("今日精选", subtitle: "从一眼读懂，到一眼心动")

            TemplateNavigationCard(template: .minimalCountdown)
            TemplateNavigationCard(template: .incomeBento)
        }
        .padding(.horizontal)

        VStack(spacing: 14) {
            TemplateSectionHeader("小号灵感", subtitle: "桌面角落也可以很有性格")
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 14) {
                    SmallTemplateCard(template: .progressOrbit)
                    SmallTemplateCard(template: .afterworkPlan)
                    SmallTemplateCard(template: .minimalCountdown)
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
        }

        VStack(spacing: 16) {
            TemplateSectionHeader("一周与发薪", subtitle: "把重要的日子放在眼前")
            TemplateNavigationCard(template: .weekRhythm)
            TemplateNavigationCard(template: .paydayCalendar)
        }
        .padding(.horizontal)

        VStack(spacing: 16) {
            TemplateSectionHeader("健康一览", subtitle: "温和呈现，不制造健康焦虑")
            TemplateNavigationCard(template: .healthBento)

            HStack(spacing: 14) {
                CompactTemplateNavigationCard(template: .sleepRibbon)
                CompactTemplateNavigationCard(template: .oxygenPulse)
            }
        }
        .padding(.horizontal)

        VStack(spacing: 16) {
            TemplateSectionHeader("天气与时间", subtitle: "出门之前，看一眼就够")
            TemplateNavigationCard(template: .weatherNow)
            TemplateNavigationCard(template: .weatherHourly)
            TemplateNavigationCard(template: .worldClock)
        }
        .padding(.horizontal)

        VStack(spacing: 16) {
            TemplateSectionHeader("我们的日子", subtitle: "纪念认真生活，也纪念彼此")
            TemplateNavigationCard(template: .loveDays)

            HStack(spacing: 14) {
                CompactTemplateNavigationCard(template: .loveOrbit)
                CompactTemplateNavigationCard(template: .editorialClock)
            }
        }
        .padding(.horizontal)
    }

    private var filteredSection: some View {
        VStack(spacing: 16) {
            TemplateSectionHeader(
                "\(selectedCategory.title)组件",
                subtitle: "共 \(WidgetTemplateKind.templates(for: selectedCategory).count) 款原创模板"
            )

            ForEach(WidgetTemplateKind.templates(for: selectedCategory)) { template in
                TemplateNavigationCard(template: template)
            }
        }
        .padding(.horizontal)
    }
}

private struct CompactTemplateNavigationCard: View {
    let template: WidgetTemplateKind

    var body: some View {
        NavigationLink(value: template) {
            VStack(alignment: .leading, spacing: 10) {
                WidgetPreviewView(template: template, size: .small, cornerRadius: 22)

                Text(template.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)

                Text(template.subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .padding(12)
            .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 26, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct FeaturedStoryCard: View {
    let template: WidgetTemplateKind
    let eyebrow: String
    let title: String
    let accent: Color

    var body: some View {
        NavigationLink(value: template) {
            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(eyebrow)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(accent)

                        Text(title)
                            .font(.title)
                            .fontWeight(.black)
                            .fontDesign(.rounded)
                            .multilineTextAlignment(.leading)
                    }

                    Spacer()

                    Image(systemName: "arrow.up.right")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.55))
                        .padding(10)
                        .background(Color.white.opacity(0.08), in: Circle())
                }

                WidgetPreviewView(template: template, size: .medium, cornerRadius: 22)
            }
            .padding(18)
            .foregroundStyle(.white)
            .background(
                LinearGradient(
                    colors: [Color("PlumInk"), Color("GlowSurfaceAlt")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 34, style: .continuous)
            )
            .overlay(alignment: .topTrailing) {
                Circle()
                    .fill(accent.opacity(0.18))
                    .frame(width: 150, height: 150)
                    .blur(radius: 18)
                    .offset(x: 42, y: -64)
                    .allowsHitTesting(false)
            }
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }
}

struct TemplateNavigationCard: View {
    let template: WidgetTemplateKind

    var body: some View {
        NavigationLink(value: template) {
            VStack(alignment: .leading, spacing: 12) {
                WidgetPreviewView(
                    template: template,
                    size: template.supportedSizes.contains(.medium) ? .medium : .small,
                    cornerRadius: 24
                )

                HStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(template.title)
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text(template.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 0)

                    WidgetSizeChips(sizes: template.supportedSizes)

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(14)
            .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct SmallTemplateCard: View {
    let template: WidgetTemplateKind

    var body: some View {
        NavigationLink(value: template) {
            VStack(alignment: .leading, spacing: 10) {
                WidgetPreviewView(template: template, size: .small, cornerRadius: 24)
                    .frame(width: 164)

                Text(template.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text(template.subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .frame(width: 164, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
}
