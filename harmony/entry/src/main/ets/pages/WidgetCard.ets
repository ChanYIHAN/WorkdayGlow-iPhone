let storage: LocalStorage = new LocalStorage({
  title: '今日活力',
  steps: '6,842',
  distance: '4.8 km',
  energy: '386 千卡',
  progress: 72
});

@Entry(storage)
@Component
struct WidgetCard {
  @LocalStorageProp('title') title: string = '今日活力';
  @LocalStorageProp('steps') steps: string = '6,842';
  @LocalStorageProp('distance') distance: string = '4.8 km';
  @LocalStorageProp('energy') energy: string = '386 千卡';
  @LocalStorageProp('progress') progress: number = 72;

  build() {
    Column({ space: 12 }) {
      Row() {
        Text(this.title)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
        Blank()
        Text(`${this.progress}%`)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#A8CFC3')
      }
      .width('100%')

      Row({ space: 9 }) {
        this.Metric(this.steps, '步数', '#D9B4C8')
        this.Metric(this.distance, '距离', '#A8CFC3')
        this.Metric(this.energy, '能量', '#D9C6E4')
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding(18)
    .borderRadius(28)
    .linearGradient({ angle: 135, colors: [['#202B3A', 0.0], ['#303B50', 1.0]] })
    .onClick(() => {
      postCardAction(this, {
        action: 'router',
        abilityName: 'EntryAbility',
        params: { destination: 'health' }
      });
    })
  }

  @Builder
  private Metric(value: string, label: string, accent: string) {
    Column({ space: 6 }) {
      Circle().width(9).height(9).fill(accent)
      Blank()
      Text(value)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(label)
        .fontSize(11)
        .fontColor('#A8A4B4')
    }
    .layoutWeight(1)
    .height('100%')
    .padding(11)
    .borderRadius(16)
    .backgroundColor('#18FFFFFF')
  }
}
