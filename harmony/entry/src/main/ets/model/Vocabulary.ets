export interface VocabularyWord {
  word: string;
  meaning: string;
  example: string;
}

export interface VocabularyReview {
  word: string;
  level: number;
  due: number;
  attempts: number;
}

export function gradeReview(previous: VocabularyReview, known: boolean, now: number): VocabularyReview {
  const level: number = known ? Math.min(previous.level + 1, 5) : 0;
  const days: number[] = [0, 1, 3, 7, 14, 30];
  return { word: previous.word, level: level, due: now + (known ? days[level] * 86400000 : 60000), attempts: previous.attempts + 1 };
}

export function parseVocabulary(text: string): VocabularyWord[] {
  const result: VocabularyWord[] = [];
  text.split(/\r?\n/).slice(0, 500).forEach((line: string) => {
    const fields: string[] = line.split(line.includes('\t') ? '\t' : '|').map((value: string) => value.trim());
    if (fields.length < 2 || fields[0].length === 0 || fields[1].length === 0 || fields[0].length > 80 || fields[1].length > 300) return;
    const item: VocabularyWord = { word: fields[0], meaning: fields[1], example: fields.length > 2 ? fields[2].slice(0, 500) : '' };
    const old: number = result.findIndex((word: VocabularyWord) => word.word.toLowerCase() === item.word.toLowerCase());
    if (old >= 0) result.splice(old, 1);
    result.push(item);
  });
  return result;
}
