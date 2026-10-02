import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { stripTypeScriptTypes } from 'node:module';
const read = file => fs.readFileSync(new URL(`../${file}`, import.meta.url), 'utf8');
const additions = JSON.parse(read('content/expansion-200.json'));
const words = JSON.parse(read('content/words.json'));
const designs = JSON.parse(read('content/designs.json'));
const swift = read('Shared/Sources/WidgetTemplateCatalog.swift');
const cases = swift.split('enum WidgetTemplateKind:')[1].split('    var id:')[0].match(/case (\w+)/g).map(x => x.slice(5));

test('200 stable template identifiers, including 100 unique additions and 22 learning themes', () => {
  assert.equal(cases.length, 200);
  assert.equal(new Set(cases).size, 200);
  assert.equal(additions.length, 100);
  assert.equal(new Set(additions.map(x => x[1])).size, 100);
  assert.equal(additions.filter(x => x[3] === 'learning').length, 22);
  assert.deepEqual(cases.slice(100), additions.map(x => x[0]));
});

test('three catalogs contain the same 200 Chinese titles', () => {
  const baseTitles = [...swift.split('    var title: String {')[3].split('    var subtitle:')[0].matchAll(/case \.\w+: "([^"]+)"/g)].map(x => x[1]);
  const expansionTitles = [...read('Shared/Sources/ExpansionTemplateCatalog.swift').matchAll(/item\("([^"]+)"/g)].map(x => x[1]);
  const expected = [...baseTitles, ...expansionTitles, ...additions.map(x => x[1])];
  assert.equal(expected.length, 200);
  for (const [file, pattern] of [
    ['android/app/src/main/java/com/workdayglow/android/data/WidgetCatalog.kt', /addGroup\(WidgetCategory\.\w+, "[^"]+", ([^\n]+)\)/g],
    ['harmony/entry/src/main/ets/model/WidgetCatalog.ets', /addGroup\(result, WidgetCategory\.\w+, '[^']+', \[([^\n]+)\]\)/g]
  ]) {
    const titles = [...read(file).matchAll(pattern)].flatMap(x => [...x[1].matchAll(/["']([^"']+)["']/g)].map(m => m[1]));
    assert.equal(titles.length, 100, file);
    assert.deepEqual(new Set([...titles, ...additions.map(x => x[1])]), new Set(expected), file);
  }
});

test('all additions are installable via the iOS collection or vocabulary intent', () => {
  const collection = read('WorkdayGlowWidget/Sources/CollectionWidget.swift').split('    static var')[0];
  const vocabulary = read('WorkdayGlowWidget/Sources/VocabularyWidgetStyle.swift').split('    static var')[0];
  for (const item of additions) assert.ok((item[3] === 'learning' ? vocabulary : collection).includes(`case ${item[0]}\n`), item[0]);
  assert.equal([...collection.matchAll(/    case /g)].length, 133);
});

test('word content has unique keys, meanings and original examples', () => {
  assert.equal(words.length, 40);
  assert.equal(new Set(words.map(x => x[0].toLowerCase())).size, 40);
  for (const word of words) assert.ok(word.every(x => typeof x === 'string' && x.trim().length > 0));
});

test('generated source files match shared content', () => {
  execFileSync(process.execPath, [fileURLToPath(new URL('../Scripts/sync-content.mjs', import.meta.url)), '--check'], { stdio: 'pipe' });
});

test('every design has valid content, safe progress and readable palette endpoints', () => {
  const luminance = hex => {
    const rgb = [1,3,5].map(i => parseInt(hex.slice(i,i+2),16)/255).map(x => x <= 0.04045 ? x/12.92 : ((x+0.055)/1.055)**2.4);
    return rgb[0]*0.2126 + rgb[1]*0.7152 + rgb[2]*0.0722;
  };
  const contrast = (a,b) => (Math.max(luminance(a),luminance(b))+.05)/(Math.min(luminance(a),luminance(b))+.05);
  assert.equal(designs.length,200);
  assert.deepEqual(designs.map(d=>d.id),cases);
  assert.equal(new Set(designs.map(d=>d.layout)).size,12);
  assert.equal(new Set(designs.map(d=>d.category)).size,14);
  for(const d of designs) {
    assert.equal(d.metrics.length,3,d.id);
    assert.equal(d.rows.length,3,d.id);
    assert.ok(d.progress>=0 && d.progress<=1,d.id);
    assert.ok(d.series.length===7 && d.series.every(v=>v>=0 && v<=1),d.id);
    assert.ok(d.caption && d.value && d.reviewNote.includes(d.title),d.id);
    for(const bg of d.palette.slice(0,2)) for(const text of [d.palette[2],d.palette[4]]) assert.ok(contrast(bg,text)>=4.5, `${d.id}: ${bg}/${text} contrast ${contrast(bg,text)}`);
  }
  assert.equal(designs.find(d=>d.id==='hydrationBloom').progress,1250/2000);
  assert.equal(designs.find(d=>d.id==='batteryDial').progress,.82);
  assert.equal(designs.find(d=>d.id==='savingsGoal').progress,12800/20000);
  assert.ok(designs.find(d=>d.id==='goldSpot').rows.some(r=>r.label==='黄金'||r.value==='黄金'));
});

test('README documents all categories and all 200 names', () => {
  const readme=read('README.md');
  for(const d of designs) assert.ok(readme.includes(d.title),d.title);
  assert.equal([...read('docs/CATALOG.md').matchAll(/\| `\w+` \|/g)].length,200);
  assert.equal([...read('harmony/entry/src/main/ets/pages/Index.ets').matchAll(/struct WidgetGalleryCard/g)].length,1);
});

test('HarmonyOS review logic follows the same intervals and import rules', async () => {
  const js = stripTypeScriptTypes(read('harmony/entry/src/main/ets/model/Vocabulary.ets'));
  const { gradeReview, parseVocabulary } = await import(`data:text/javascript;base64,${Buffer.from(js).toString('base64')}`);
  const now = 1_000_000;
  let review = { word: 'test', level: 0, due: 0, attempts: 0 };
  for (const [index, days] of [1, 3, 7, 14, 30, 30].entries()) {
    review = gradeReview(review, true, now);
    assert.equal(review.level, Math.min(index + 1, 5));
    assert.equal(review.due, now + days * 86_400_000);
  }
  review = gradeReview(review, false, now);
  assert.equal(review.level, 0);
  assert.equal(review.due, now + 60_000);
  assert.equal(review.attempts, 7);
  const words = parseVocabulary('Test|测试|Example\ninvalid\ntest\t更新\tNew example\nempty|\n');
  assert.equal(words.length, 1);
  assert.equal(words[0].meaning, '更新');
  assert.equal(parseVocabulary('x'.repeat(81) + '|too long').length, 0);
});
