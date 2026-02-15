import test from 'node:test';
import assert from 'node:assert';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const skillPath = path.join(__dirname, '../SKILL.md');

test('test-merhaba skill content', async (t) => {
  await t.test('SKILL.md exists', () => {
    assert.strictEqual(fs.existsSync(skillPath), true, 'SKILL.md should exist');
  });

  await t.test('SKILL.md contains expected metadata', () => {
    const content = fs.readFileSync(skillPath, 'utf8');
    assert.match(content, /name:\s*test-merhaba/, 'Should contain skill name');
    assert.match(content, /description:\s*A test skill that says merhaba dunya/, 'Should contain skill description');
  });

  await t.test('SKILL.md contains merhaba instruction', () => {
    const content = fs.readFileSync(skillPath, 'utf8');
    assert.match(content, /Echo 'Merhaba Dunya!'/i, 'Should contain instruction to say merhaba dunya');
  });
});
