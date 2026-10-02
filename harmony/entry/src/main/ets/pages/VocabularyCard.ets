let vocabularyStorage: LocalStorage = new LocalStorage({ word: 'curious', meaning: '好奇的', example: 'Stay curious about the world.' });

@Entry(vocabularyStorage)
@Component
struct VocabularyCard {
  @LocalStorageProp('word') word: string = 'curious';
  @LocalStorageProp('meaning') meaning: string = '好奇的';
  @LocalStorageProp('example') example: string = '';

  build() {
    Column({ space: 10 }) {
      Text('每日单词').fontSize(14).fontColor('#176D61').width('100%')
      Blank()
      Text(this.word).fontSize(26).fontWeight(FontWeight.Bold).fontColor('#1D1C27').maxLines(2)
      Text(this.meaning).fontSize(16).fontColor('#176D61').maxLines(2)
      Text(this.example).fontSize(12).fontColor('#625F6C').maxLines(2)
      Blank()
      Text('打开学习 →').fontSize(12).fontColor('#176D61')
    }
    .width('100%').height('100%').padding(18).borderRadius(28)
    .linearGradient({ angle: 135, colors: [['#F0FAF7', 0], ['#E4E9FA', 1]] })
    .border({ width: 1, color: '#CCFFFFFF' })
    .onClick(() => {
      postCardAction(this, { action: 'router', abilityName: 'EntryAbility', params: { destination: 'learning' } });
    })
  }
}
