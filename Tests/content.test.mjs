import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { stripTypeScriptTypes } from 'node:module';
const read = file => fs.readFileSync(new URL(`../${file}`, import.meta.url), 'utf8');
const additions = JSON.parse(read('content/expansion-150.json'));
const words = JSON.parse(read('content/words.json'));
const swift = read('Shared/Sources/WidgetTemplateCatalog.swift');
const cases = swift.split('enum WidgetTemplateKind:')[1].split('    var id:')[0].match(/case (\w+)/g).map(x => x.slice(5));

test('150 stable template identifiers, including 50 unique additions and 20 learning themes', () => {
  assert.equal(cases.length, 150);
  assert.equal(new Set(cases).size, 150);
  assert.equal(additions.length, 50);
  assert.equal(new Set(additions.map(x => x[1])).size, 50);
  assert.equal(additions.filter(x => x[3] === 'learning').length, 20);
  assert.deepEqual(cases.slice(100), additions.map(x => x[0]));
});

test('three catalogs contain the same 150 Chinese titles', () => {
  const baseTitles = [...swift.split('    var title: String {')[3].split('    var subtitle:')[0].matchAll(/case \.\w+: "([^"]+)"/g)].map(x => x[1]);
  const expansionTitles = [...read('Shared/Sources/ExpansionTemplateCatalog.swift').matchAll(/item\("([^"]+)"/g)].map(x => x[1]);
  const expected = [...baseTitles, ...expansionTitles, ...additions.map(x => x[1])];
  assert.equal(expected.length, 150);
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
  assert.equal([...collection.matchAll(/    case /g)].length, 85);
});

test('word content has unique keys, meanings and original examples', () => {
  assert.equal(words.length, 40);
  assert.equal(new Set(words.map(x => x[0].toLowerCase())).size, 40);
  for (const word of words) assert.ok(word.every(x => typeof x === 'string' && x.trim().length > 0));
});

test('generated source files match shared content', () => {
  execFileSync(process.execPath, [fileURLToPath(new URL('../Scripts/sync-content.mjs', import.meta.url)), '--check'], { stdio: 'pipe' });
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
