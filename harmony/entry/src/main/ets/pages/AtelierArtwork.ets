import { WidgetTemplate } from '../model/WidgetCatalog';
import { AtelierDesign, DesignMetric, designFor } from '../model/AtelierDesign';

@Component
export struct AtelierArtwork {
  @Prop item: WidgetTemplate;
  private get design(): AtelierDesign { return designFor(this.item.title); }

  @Builder
  private Headline() {
    Text(this.design.value).fontSize(27).fontWeight(FontWeight.Medium)
      .fontColor(this.design.palette[2]).maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
    Text(this.design.caption).fontSize(11).fontColor(this.design.palette[4]).maxLines(1)
  }

  @Builder
  private Metrics() {
    Row({ space: 12 }) {
      ForEach(this.design.metrics, (metric: DesignMetric) => {
        Column({ space: 5 }) {
          Text(metric.label).fontSize(10).fontColor(this.design.palette[4])
          Text(metric.value).fontSize(14).fontWeight(FontWeight.Medium).fontColor(this.design.palette[2]).maxLines(1)
        }.layoutWeight(1).alignItems(HorizontalAlign.Start)
      }, (metric: DesignMetric) => metric.label)
    }.width('100%')
  }

  build() {
    Column({ space: 10 }) {
      Text(this.design.eyebrow).fontSize(9).letterSpacing(1.3).fontColor(this.design.palette[4]).width('100%')
      if (this.design.layout === 'orbit' || this.design.layout === 'dial') {
        Row({ space: 18 }) {
          Stack() {
            Progress({ value: this.design.progress * 100, total: 100, type: ProgressType.Ring })
              .width(92).height(92).color(this.design.palette[3]).style({ strokeWidth: 5 })
            Circle().width(58).height(58).fill(Color.Transparent).stroke(this.design.palette[4]).strokeWidth(1)
            if (this.design.layout === 'dial') {
              Text('╱').fontSize(30).fontColor(this.design.palette[3])
            }
          }
          Column({ space: 6 }) { this.Headline() }.layoutWeight(1).alignItems(HorizontalAlign.Start)
        }.layoutWeight(1)
      } else if (this.design.layout === 'list') {
        ForEach(this.design.rows, (metric: DesignMetric) => {
          Row() {
            Text(metric.label).fontSize(12).fontColor(this.design.palette[4])
            Blank()
            Text(metric.value).fontSize(15).fontWeight(FontWeight.Medium).fontColor(this.design.palette[2]).maxLines(1)
          }.width('100%').padding({ bottom: 8 }).border({ width: { bottom: 0.5 }, color: this.design.palette[4] })
        }, (metric: DesignMetric) => metric.label)
      } else if (this.design.layout === 'bento') {
        Row({ space: 12 }) {
          Column({ space: 8 }) { this.Headline() }.layoutWeight(2).alignItems(HorizontalAlign.Start)
          Column({ space: 12 }) {
            ForEach(this.design.metrics.slice(0, 2), (metric: DesignMetric) => {
              Column({ space: 4 }) {
                Text(metric.label).fontSize(10).fontColor(this.design.palette[4])
                Text(metric.value).fontSize(14).fontWeight(FontWeight.Medium).fontColor(this.design.palette[2]).maxLines(1)
              }.width('100%').alignItems(HorizontalAlign.Start)
            }, (metric: DesignMetric) => metric.label)
          }.layoutWeight(1)
        }.layoutWeight(1)
      } else if (this.design.layout === 'mosaic') {
        Row({ space: 6 }) {
          ForEach([0, 1, 2], (index: number) => {
            Stack({ alignContent: Alignment.Bottom }) {
              Circle().width(28).height(28).fill(this.design.palette[0]).offset({ x: 9, y: -32 })
              Ellipse().width(140).height(68).fill(this.design.palette[2]).opacity(0.28).offset({ x: -20, y: 20 })
            }.height(78).layoutWeight(index === 0 ? 2 : 1).backgroundColor(this.design.palette[3]).opacity(0.85 - index * 0.15).borderRadius(10).clip(true)
          }, (index: number) => index.toString())
        }.width('100%')
        Text(this.design.value).fontSize(20).fontWeight(FontWeight.Medium).fontColor(this.design.palette[2]).maxLines(1)
      } else {
        Column({ space: 7 }) { this.Headline() }.width('100%').alignItems(HorizontalAlign.Start)
        if (this.design.layout === 'timeline' || this.design.layout === 'waveform') {
          Row({ space: 7 }) {
            ForEach(this.design.series, (value: number, index: number) => {
              Column().height(12 + value * 26).layoutWeight(1).borderRadius(this.design.layout === 'waveform' ? 12 : 3)
                .backgroundColor(this.design.palette[3]).opacity(0.45 + value * 0.5)
            }, (value: number, index: number) => index.toString())
          }.height(38).width('100%').alignItems(VerticalAlign.Bottom)
        } else if (this.design.layout === 'constellation') {
          Row({ space: 6 }) {
            ForEach([0, 1, 2, 3, 4, 5, 6], (index: number) => {
              Column({ space: 6 }) {
                ForEach([0, 1, 2], (row: number) => {
                  Circle().width(7).height(7).fill(this.design.palette[3]).opacity(index * 3 + row < this.design.progress * 21 ? 1 : 0.2)
                }, (row: number) => row.toString())
              }
            }, (index: number) => index.toString())
          }.width('100%')
        } else if (this.design.layout === 'gauge') {
          Progress({ value: this.design.progress * 100, total: 100, type: ProgressType.Linear })
            .width('100%').color(this.design.palette[3]).style({ strokeWidth: 5 })
        } else {
          Divider().color(this.design.palette[4]).opacity(0.4)
          this.Metrics()
        }
      }
      Blank()
      Text(this.item.title + '  ·  EKHART').fontSize(10).fontWeight(FontWeight.Medium).fontColor(this.design.palette[2]).width('100%')
    }.width('100%').height(202).padding(18).alignItems(HorizontalAlign.Start).borderRadius(22)
      .linearGradient({ angle: 135, colors: [[this.design.palette[0], 0], [this.design.palette[1], 1]] })
  }
}
