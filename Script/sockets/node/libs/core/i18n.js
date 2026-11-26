/**
 * sockets -> nodejs -> libs -> core -> i18n
 *
 * @package Sngine
 * @author Zamblek
 */

const fs = require('fs');
const path = require('path');
const config = require('./config');

/* modules names */
let overrides = {};

/**
 * module_names_rename
 *
 * @param {string} text
 * @param {Object} replacements
 * @param {Array} skip
 * @return {string}
 */
function module_names_rename(text, replacements, skip) {
  const skipped = skip.map((word) => word.toLowerCase());
  const words = Object.keys(replacements).sort((a, b) => b.length - a.length);
  const pattern = new RegExp('\\b(?:(an?)(\\s+))?(' + words.join('|') + ')\\b', 'giu');
  return text.replace(pattern, (match, article, space, found) => {
    const word = found.toLowerCase();
    if (skipped.includes(word)) {
      return match;
    }
    let name = replacements[word];
    if (found === word) {
      name = name.toLowerCase();
    } else if (found === found.toUpperCase()) {
      name = name.toUpperCase();
    }
    if (!article) {
      return name;
    }
    /* article */
    let renamed = (/^[aeiou]/i.test(name)) ? 'an' : 'a';
    if (article === article.toUpperCase()) {
      renamed = (article === 'A') ? renamed.charAt(0).toUpperCase() + renamed.slice(1) : renamed.toUpperCase();
    } else if (article !== article.toLowerCase()) {
      renamed = renamed.charAt(0).toUpperCase() + renamed.slice(1);
    }
    return renamed + space + name;
  });
}

/**
 * init_i18n
 *
 * @param {Object} system
 * @return {void}
 */
function init_i18n(system) {
  overrides = {};
  if (!system.module_names) {
    return;
  }
  try {
    const catalogue = JSON.parse(fs.readFileSync(path.join(config.ABSPATH, 'includes', 'module-names.json'), 'utf8'));
    const names = JSON.parse(String(system.module_names).replace(/&quot;/g, '"'));
    const replacements = {};
    for (const [word, target] of Object.entries(catalogue.words)) {
      const name = names[target[0]] && names[target[0]][target[1]];
      if (typeof name === 'string' && name !== '') {
        replacements[word.toLowerCase()] = name;
      }
    }
    if (!Object.keys(replacements).length) {
      return;
    }
    for (const text of catalogue.strings) {
      const renamed = module_names_rename(text, replacements, catalogue.skip[text] || []);
      if (renamed !== text) {
        overrides[text] = renamed;
      }
    }
  } catch (e) {
    overrides = {};
  }
}

/**
 * __
 *
 * @param {string} text
 * @return {string}
 */
function __(text) {
  return overrides[text] ?? text;
}

module.exports = { __, init_i18n };
