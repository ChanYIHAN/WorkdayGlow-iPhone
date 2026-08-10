import { widgetCategories, WidgetCategory, widgetTemplates, WidgetTemplate } from '../model/WidgetCatalog';

const palettes: string[][] = [
  ['#F7F1E8', '#7CE1C8'],
  ['#1D1C27', '#34314A'],
  ['#65C7FF', '#AD91ED'],
  ['#191824', '#4A3E78'],
  ['#FFE27D', '#FF9E9F'],
  ['#AD91ED', '#FF8D90']
];

@Entry
@Component
struct Index {
  @State private query: string = '';
  @State private selectedCategory: WidgetCategory = WidgetCategory.Featured;
  @State private selectedTab: number = 0;

  private get filteredTemplates(): WidgetTemplate[] {
    const normalized: string = this.query.trim().toLowerCase();
    return widgetTemplates.filter((item: WidgetTemplate) => {
      const categoryMatches: boolean = this.selectedCategory === WidgetCategory.Featured || item.category === this.selectedCategory;
      const queryMatches: boolean = normalized.length === 0 || item.title.toLowerCase().includes(normalized) || item.subtitle.toLowerCase().includes(normalized);
      return categoryMatches && queryMatches;
    });
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 16 }) {
          Text(this.selectedTab === 1 ? '组件库' : '发现')
            .fontSize(38)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1D1C27')
            .width('100%')

          if (this.selectedTab === 0) {
            this.DiscoveryHero()
          }

          TextInput({ placeholder: '搜索时间、健康、天气或行情', text: this.query })
            .height(52)
            .fontSize(16)
            .borderRadius(22)
            .backgroundColor('#EFFFFFFF')
            .onChange((value: string) => { this.query = value; })

          Scroll() {
            Row({ space: 10 }) {
              ForEach(widgetCategories, (category: WidgetCategory) => {
                Text(category)
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.selectedCategory === category ? '#FFFFFF' : '#1D1C27')
                  .height(48)
                  .padding({ left: 18, right: 18 })
                  .borderRadius(24)
                  .backgroundColor(this.selectedCategory === category ? '#1D1C27' : '#EFFFFFFF')
                  .onClick(() => { this.selectedCategory = category; })
              }, (category: WidgetCategory) => category)
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)

          Row() {
            Column({ space: 3 }) {
              Text('100 款原创模板')
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1D1C27')
              Text('iOS / Android / HarmonyOS 同名目录')
                .fontSize(13)
                .fontColor('#6F6C79')
            }
            Blank()
            Text(`${this.filteredTemplates.length} 款`)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#176D61')
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)

          ForEach(this.filteredTemplates, (item: WidgetTemplate) => {
            WidgetGalleryCard({ item: item })
          }, (item: WidgetTemplate) => item.id)
        }
        .width('100%')
        .padding({ left: 18, right: 18, top: 16, bottom: 28 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      Row() {
        ForEach(['发现', '组件', '工具', '概览', '设置'], (tab: string, index: number) => {
          Column({ space: 5 }) {
            Circle()
              .width(8)
              .height(8)
              .fill(this.selectedTab === index ? '#36D5B1' : '#B1AEB9')
            Text(tab)
              .fontSize(12)
              .fontWeight(this.selectedTab === index ? FontWeight.Bold : FontWeight.Regular)
              .fontColor(this.selectedTab === index ? '#176D61' : '#6F6C79')
          }
          .layoutWeight(1)
          .height(58)
          .justifyContent(FlexAlign.Center)
          .onClick(() => { this.selectedTab = index; })
        })
      }
      .width('100%')
      .padding({ left: 10, right: 10, bottom: 4 })
      .backgroundColor('#F5FFFFFF')
      .border({ width: { top: 0.5 }, color: '#22000000' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F6FA')
  }

  @Builder
  private DiscoveryHero() {
    Column({ space: 11 }) {
      Text('EKHART WIDGETS')
        .fontSize(11)
        .fontWeight(FontWeight.Bold)
        .fontColor('#176D61')
        .letterSpacing(1)
        .width('100%')
      Text('让每一刻\n恰好可见')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1D1C27')
        .width('100%')
      Text('奕刻 · 100 款原创设计 · ArkUI 与 Form Kit')
        .fontSize(14)
        .fontColor('#625F6C')
        .width('100%')
      Row({ space: 8 }) {
        this.HeroTag('健康', '#176D61', '#2236D5B1')
        this.HeroTag('日程', '#23608A', '#2265C7FF')
        this.HeroTag('生活', '#66519B', '#22AD91ED')
      }
    }
    .width('100%')
    .padding(22)
    .borderRadius(30)
    .linearGradient({ angle: 135, colors: [['#D9F8F2', 0.0], ['#E7DFFF', 0.55], ['#FFFFFF', 1.0]] })
    .border({ width: 1, color: '#32FFFFFF' })
  }

  @Builder
  private HeroTag(title: string, color: string, background: string) {
    Text(title)
      .fontSize(13)
      .fontWeight(FontWeight.Bold)
      .fontColor(color)
      .padding({ left: 13, right: 13, top: 8, bottom: 8 })
      .borderRadius(18)
      .backgroundColor(background)
  }
}

@Component
struct WidgetGalleryCard {
  @Prop item: WidgetTemplate;

  private get isDark(): boolean {
    return this.item.palette === 1 || this.item.palette === 3;
  }

  build() {
    Column({ space: 11 }) {
      Column({ space: 12 }) {
        Row() {
          Text(this.item.title)
            .fontSize(19)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.isDark ? '#FFFFFF' : '#1D1C27')
          Blank()
          Text(this.item.category)
            .fontSize(11)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.isDark ? '#B7B2C8' : '#625F6C')
        }
        Row({ space: 9 }) {
          this.Metric('6,842', '今日', '#FF8D90')
          this.Metric('72%', '进度', '#36D5B1')
          this.Metric('良好', '状态', '#AD91ED')
        }
      }
      .width('100%')
      .height(170)
      .padding(17)
      .borderRadius(24)
      .linearGradient({
        angle: 135,
        colors: [[palettes[this.item.palette][0], 0.0], [palettes[this.item.palette][1], 1.0]]
      })

      Row() {
        Column({ space: 3 }) {
          Text(this.item.title)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1D1C27')
          Text(this.item.subtitle)
            .fontSize(12)
            .fontColor('#6F6C79')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        Blank()
        Text(this.item.category)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor('#176D61')
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding(13)
    .borderRadius(28)
    .backgroundColor('#EFFFFFFF')
    .border({ width: 0.5, color: '#18000000' })
  }

  @Builder
  private Metric(value: string, label: string, accent: string) {
    Column({ space: 5 }) {
      Circle().width(9).height(9).fill(accent)
      Blank()
      Text(value)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.isDark ? '#FFFFFF' : '#1D1C27')
      Text(label)
        .fontSize(11)
        .fontColor(this.isDark ? '#A8A4B4' : '#625F6C')
    }
    .layoutWeight(1)
    .height('100%')
    .padding(11)
    .borderRadius(16)
    .backgroundColor(this.isDark ? '#18FFFFFF' : '#14FFFFFF')
  }
}
