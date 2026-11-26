import { readFile, writeFile, readdir, mkdir } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import { resolve } from 'node:path';
import { createHash } from 'node:crypto';
import { gunzipSync } from 'node:zlib';

const catalogueVersion = '17.0.0';

const root = fileURLToPath(new URL('./', import.meta.url));
const dataRoot = resolve(root, 'node_modules/emojibase-data');
const output = resolve(root, 'includes/assets/js/emoji-data');
const read = async path => JSON.parse(await readFile(path, 'utf8'));
const dataPackage = await read(resolve(dataRoot, 'package.json'));
if (dataPackage.version !== catalogueVersion) throw new Error('Emoji catalogue version does not match the build.');
const meta = await read(resolve(dataRoot, 'meta/groups.json'));
const languageRoot = resolve(root, 'content/languages/locale');
const supported = new Set(['en', ...(await readdir(languageRoot, { withFileTypes: true }))
  .filter(directory => directory.isDirectory()).map(directory => directory.name.split('_')[0])]);
const packageLocales = new Set((await readdir(dataRoot, { withFileTypes: true }))
  .filter(directory => directory.isDirectory()).map(directory => directory.name));
const english = await read(resolve(dataRoot, 'en/data.json'));
const englishMessages = await read(resolve(dataRoot, 'en/messages.json'));
const locales = [];
await mkdir(output, { recursive: true });
for (const locale of [...supported].sort()) {
  const inPackage = packageLocales.has(locale);
  const data = inPackage ? await read(resolve(dataRoot, locale, 'data.json')) : english;
  const messages = inPackage ? await read(resolve(dataRoot, locale, 'messages.json')) : englishMessages;
  const cldr = inPackage ? null : JSON.parse(gunzipSync(await readFile(resolve(output, 'source', `${locale}.cldr.json.gz`))).toString('utf8'));
  const annotation = item => {
    if (!cldr) return null;
    const value = cldr.annotations[item.emoji];
    if (!value?.[0]) throw new Error(`Missing ${locale} annotation for ${item.emoji}`);
    return value;
  };
  const variant = item => ({ u: item.emoji, n: annotation(item)?.[0] || item.label, t: item.tone || 0 });
  const entries = data.filter(item => item.group !== undefined && item.group !== 2).sort((a, b) => a.order - b.order).map(item => ({
    u: item.emoji, n: annotation(item)?.[0] || item.label, g: item.group,
    k: cldr ? [...new Set([...(annotation(item)?.[1] || []), ...(item.tags || [])])] : item.tags || [],
    s: (item.skins || []).map(variant)
  }));
  const groups = Object.entries(meta.groups).filter(([id]) => id !== '2').map(([id, key], index) => ({
    id, name: cldr?.groups[index] || messages.groups.find(group => group.key === key)?.message || key
  }));
  if (cldr && cldr.groups.length !== groups.length) throw new Error(`${locale} category count does not match.`);
  const json = JSON.stringify({ groups, entries });
  const hash = createHash('sha256').update(json).digest('hex').slice(0, 12);
  const file = `${locale}.${hash}.json`;
  await writeFile(resolve(output, file), json + '\n');
  locales.push([locale, file]);
}
await writeFile(resolve(output, 'manifest.json'), JSON.stringify({ locales: Object.fromEntries(locales) }) + '\n');
console.log(`Emoji catalogue: ${locales.length} locales for native Unicode picker.`);
