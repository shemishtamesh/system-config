const fs = require("fs");
const path = require("path");

const roots = process.argv[2]
  ? [process.argv[2]]
  : [
      path.join(process.env.HOME || "", ".pi", "agent", "npm"),
      path.join(process.env.HOME || "", ".pi", "npm"),
    ];

function findTargets(root) {
  if (!fs.existsSync(root)) return [];
  if (root.endsWith(`${path.sep}index.ts`)) return [root];
  const result = [];
  function walk(dir) {
    let entries;
    try {
      entries = fs.readdirSync(dir, { withFileTypes: true });
    } catch {
      return;
    }
    for (const entry of entries) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) walk(full);
      else if (
        entry.isFile() &&
        /pi-landstrip(?:@[^/]+)?\/dist\/index\.ts$/i.test(full.replace(/\\/g, "/"))
      ) {
        result.push(full);
      }
    }
  }
  walk(root);
  return result;
}

function applyOnce(text, needle, replacement, label) {
  const count = text.split(needle).length - 1;
  if (count !== 1) {
    throw new Error(`pi-landstrip patch ${label}: expected one match, found ${count}`);
  }
  return text.split(needle).join(replacement);
}

const READ_ALLOWED_OLD =
  "function readAllowed(path, allowRead, denyRead, cwd) { const deny = longestPrefixMatch(path, denyRead, cwd); if (deny < 0) return true; return longestPrefixMatch(path, allowRead, cwd) >= deny; }";
const READ_ALLOWED_NEW =
  "function readAllowed(path, allowRead, denyRead, cwd) { const deny = longestPrefixMatch(path, denyRead, cwd); const allow = longestPrefixMatch(path, allowRead, cwd); if (allow < 0) return false; return deny < 0 || allow >= deny; }";

const SELECT_OLD = "const selected = await ctx.ui.select(title, labels, { signal });";
const SELECT_NEW = "const selected = void 0;";

try {
  let patched = 0;
  for (const file of roots.flatMap(findTargets)) {
    let text = fs.readFileSync(file, "utf8");

    if (text.includes("const allow = longestPrefixMatch(path, allowRead")) {
      patched += 1;
      continue;
    }

    text = text.replaceAll("promptOnBlock: true", "promptOnBlock: false");
    text = applyOnce(text, READ_ALLOWED_OLD, READ_ALLOWED_NEW, "readAllowed");
    text = applyOnce(text, SELECT_OLD, SELECT_NEW, "showPermissionPrompt");
    fs.writeFileSync(file, text);
    patched += 1;
  }

} catch (err) {
  console.error(
    "pi-landstrip patch FAILED: " +
      (err && err.message ? err.message : String(err)),
  );
  process.exit(1);
}
