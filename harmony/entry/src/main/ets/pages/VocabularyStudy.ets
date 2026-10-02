import { VocabularyWord, VocabularyReview, gradeReview, parseVocabulary } from '../model/Vocabulary';
import { vocabularySeed } from '../model/VocabularySeed';

PersistentStorage.persistProp('vocabularyWords', JSON.stringify(vocabularySeed));
PersistentStorage.persistProp('vocabularyReviews', '[]');

@Component
export struct VocabularyStudy {
  @StorageLink('vocabularyWords') private wordsJSON: string = JSON.stringify(vocabularySeed);
  @StorageLink('vocabularyReviews') private reviewsJSON: string = '[]';
  @StorageLink('glassOpaque') private opaque: boolean = false;
  @StorageLink('glassMotion') private motion: boolean = true;
  @State private revealed: boolean = false;
  @State private importText: string = '';
  @State private feedback: string = '';
  @State private now: number = Date.now();
  private timer: number = -1;

  aboutToAppear(): void { this.timer = setInterval(() => { this.now = Date.now(); }, 15000); }
  aboutToDisappear(): void { if (this.timer >= 0) clearInterval(this.timer); }

  private get words(): VocabularyWord[] { return JSON.parse(this.wordsJSON) as VocabularyWord[]; }
  private get reviews(): VocabularyReview[] { return JSON.parse(this.reviewsJSON) as VocabularyReview[]; }
  private review(word: VocabularyWord): VocabularyReview {
    const found: VocabularyReview | undefined = this.reviews.find((item: VocabularyReview) => item.word === word.word.toLowerCase());
    return found ? found : { word: word.word.toLowerCase(), level: 0, due: 0, attempts: 0 };
  }
  private get current(): VocabularyWord | undefined {
    return this.words.filter((word: VocabularyWord) => this.review(word).due <= this.now)
      .sort((a: VocabularyWord, b: VocabularyWord) => this.review(a).due - this.review(b).due || a.word.localeCompare(b.word))[0];
  }
  private grade(known: boolean): void {
    const word: VocabularyWord | undefined = this.current;
    if (!word) return;
    const reviews: VocabularyReview[] = this.reviews.filter((item: VocabularyReview) => item.word !== word.word.toLowerCase());
    reviews.push(gradeReview(this.review(word), known, Date.now()));
    this.revealed = false;
    this.reviewsJSON = JSON.stringify(reviews);
    this.now = Date.now();
  }
  private importWords(): void {
    const incoming: VocabularyWord[] = parseVocabulary(this.importText);
    if (incoming.length === 0) { this.feedback = '未找到有效行，请检查格式。'; return; }
    const ids: string[] = incoming.map((word: VocabularyWord) => word.word.toLowerCase());
    this.wordsJSON = JSON.stringify(this.words.filter((word: VocabularyWord) => !ids.includes(word.word.toLowerCase())).concat(incoming));
    this.reviewsJSON = JSON.stringify(this.reviews.filter((item: VocabularyReview) => !ids.includes(item.word)));
    this.revealed = false;
    this.feedback = `已导入 ${incoming.length} 词`;
    this.importText = '';
  }

  build() {
    Column({ space: 18 }) {
      Text('词汇学习').fontSize(32).fontWeight(FontWeight.Bold).fontColor('#1D1C27')
      Text(`词库 ${this.words.length} 词 · 已学习 ${this.reviews.filter((item: VocabularyReview) => item.level > 0).length} 词`)
        .fontSize(14).fontColor('#625F6C')
      Column({ space: 18 }) {
        if (this.current) {
          Text(this.revealed ? this.current!.meaning : this.current!.word)
            .fontSize(30).fontWeight(FontWeight.Bold).fontColor('#1D1C27')
          if (this.revealed) {
            Text(this.current!.word).fontColor('#176D61')
            Text(this.current!.example).fontColor('#625F6C')
          }
          Button(this.revealed ? '查看英文' : '翻面 · 查看词义')
            .height(48).backgroundColor('#176D61')
            .onClick(() => { animateTo({ duration: this.motion ? 220 : 0, curve: Curve.EaseInOut }, () => { this.revealed = !this.revealed; }); })
          Row({ space: 12 }) {
            Button('再想一想').height(48).enabled(this.revealed).onClick(() => { this.grade(false); })
            Button('记住了').height(48).enabled(this.revealed).onClick(() => { this.grade(true); })
          }
        } else {
          Text('本轮完成，稍后再来复习 ✓').fontSize(22).fontColor('#176D61')
        }
      }
      .width('100%').padding(24).borderRadius(30)
      .backgroundColor(this.opaque ? '#FFFFFF' : '#BFFFFFFF')
      .backgroundBlurStyle(this.opaque ? BlurStyle.NONE : BlurStyle.Thick)
      .border({ width: 1, color: '#CCFFFFFF' })
      .shadow({ radius: 16, color: '#120F2440', offsetY: 6 })
      Text('忘记后 1 分钟再练；记住后按 1、3、7、14、30 天复习。').fontSize(12).fontColor('#625F6C')
      Text('内置 40 个入门词，主题卡可导入对应内容，不包含完整考试题库。').fontSize(12).fontColor('#625F6C')
      TextArea({ placeholder: '每行：英文 | 中文 | 例句（可选）', text: this.importText })
        .height(160).onChange((value: string) => { this.importText = value; })
      Button('导入并保存').height(48).onClick(() => { this.importWords(); })
      Text(this.feedback).fontSize(12).fontColor('#176D61')
    }.width('100%')
  }
}
