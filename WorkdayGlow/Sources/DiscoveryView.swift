import SwiftUI

struct DiscoveryView: View {
    @State private var selectedCategory: WidgetTemplateCategory = .featured

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    collectionHero
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
            .background(AppCanvas())
            .navigationDestination(for: WidgetTemplateKind.self) { template in
                WidgetTemplateDetailView(template: template)
            }
            .navigationTitle("发现")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var collectionHero: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    SectionBadge(text: "EKHART WIDGETS")

                    Text("让每一刻\n恰好可见")
                        .font(.largeTitle.weight(.bold))
                        .fontDesign(.rounded)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 12)

                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.system(size: 38, weight: .medium))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("SeaGlass"), Color("AuroraLavender"))
                    .frame(width: 56, height: 56)
                    .accessibilityHidden(true)
            }

            Text("奕刻 · 100 款原创设计 · 桌面与锁屏")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                GlassTag(title: "健康活动", symbol: "heart.fill", tint: Color("AuroraCoral"))
                GlassTag(title: "日程专注", symbol: "checklist", tint: Color("SkyGlow"))
                GlassTag(title: "每日灵感", symbol: "moon.stars.fill", tint: Color("AuroraLavender"))
            }
            .lineLimit(1)
            .minimumScaleFactor(0.78)
        }
        .padding(20)
        .appGlassSurface(cornerRadius: 30)
        .padding(.horizontal)
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

            FeaturedStoryCard(
                template: .controlDeck,
                eyebrow: "快捷工具",
                title: "常用开关\n一步就到",
                accent: Color("AuroraLavender")
            )

            FeaturedStoryCard(
                template: .photoMosaic,
                eyebrow: "私人画廊",
                title: "把喜欢的瞬间\n留在桌面",
                accent: Color("RoseGlow")
            )

            FeaturedStoryCard(
                template: .goldTrend,
                eyebrow: "参考行情",
                title: "汇率、黄金与股票\n清晰看懂",
                accent: Color("ButterGlow")
            )

            FeaturedStoryCard(
                template: .activeBento,
                eyebrow: "活动与恢复",
                title: "步数、距离与能量\n更完整了",
                accent: Color("SeaGlass")
            )

            FeaturedStoryCard(
                template: .glassAgenda,
                eyebrow: "日程与专注",
                title: "只留下今天\n真正重要的事",
                accent: Color("SkyGlow")
            )

            FeaturedStoryCard(
                template: .moonPhase,
                eyebrow: "每日灵感",
                title: "月相与日光\n也住进桌面",
                accent: Color("AuroraLavender")
            )
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 318)
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
            TemplateSectionHeader("活动与恢复", subtitle: "步数、距离与活动能量也能一眼看见")
            TemplateNavigationCard(template: .activeBento)

            HStack(spacing: 14) {
                CompactTemplateNavigationCard(template: .stepOrbit)
                CompactTemplateNavigationCard(template: .recoveryArc)
            }
        }
        .padding(.horizontal)

        VStack(spacing: 16) {
            TemplateSectionHeader("今天的计划", subtitle: "日程清晰，专注也更轻盈")
            TemplateNavigationCard(template: .glassAgenda)

            HStack(spacing: 14) {
                CompactTemplateNavigationCard(template: .weekPlanner)
                CompactTemplateNavigationCard(template: .focusNow)
            }
        }
        .padding(.horizontal)

        VStack(spacing: 16) {
            TemplateSectionHeader("每日灵感", subtitle: "不联网，也能每天有一点新鲜感")
            TemplateNavigationCard(template: .dailyQuote)

            HStack(spacing: 14) {
                CompactTemplateNavigationCard(template: .moonPhase)
                CompactTemplateNavigationCard(template: .solarRhythm)
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

        VStack(spacing: 16) {
            TemplateSectionHeader("快捷与连接", subtitle: "通过系统快捷指令，少滑几层菜单")
            TemplateNavigationCard(template: .controlDeck)

            HStack(spacing: 14) {
                CompactTemplateNavigationCard(template: .shortcutStack)
                CompactTemplateNavigationCard(template: .focusConsole)
            }
        }
        .padding(.horizontal)

        VStack(spacing: 16) {
            TemplateSectionHeader("汇率与市场", subtitle: "延迟参考行情，不制造交易焦虑")
            TemplateNavigationCard(template: .currencyMatrix)

            HStack(spacing: 14) {
                CompactTemplateNavigationCard(template: .goldSpot)
                CompactTemplateNavigationCard(template: .stockQuote)
            }

            TemplateNavigationCard(template: .watchlistBento)
        }
        .padding(.horizontal)

        VStack(spacing: 16) {
            TemplateSectionHeader("照片与音乐", subtitle: "把桌面变成只属于你的情绪画廊")
            TemplateNavigationCard(template: .photoFilmstrip)

            HStack(spacing: 14) {
                CompactTemplateNavigationCard(template: .photoPolaroid)
                CompactTemplateNavigationCard(template: .musicVinyl)
            }

            TemplateNavigationCard(template: .musicGlass)
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
            .appGlassSurface(cornerRadius: 26, interactive: true)
        }
        .buttonStyle(AppCardButtonStyle())
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
        .buttonStyle(AppCardButtonStyle())
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
            .appGlassSurface(cornerRadius: 30, interactive: true)
        }
        .buttonStyle(AppCardButtonStyle())
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
        .buttonStyle(AppCardButtonStyle())
    }
}
