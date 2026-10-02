import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
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
