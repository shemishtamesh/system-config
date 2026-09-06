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
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) walk(full);
      else if (entry.isFile() && full.endsWith(`${path.sep}pi-landstrip${path.sep}dist${path.sep}index.ts`)) result.push(full);
    }
  }
  walk(root);
  return result;
}

function replaceOne(text, re, replacement, label) {
  const matches = [...text.matchAll(re)];
  if (matches.length !== 1) {
    throw new Error(`pi-landstrip patch ${label}: expected one match, found ${matches.length}`);
  }
  return text.replace(re, replacement);
}

for (const file of roots.flatMap(findTargets)) {
  let text = fs.readFileSync(file, "utf8");
  if (text.includes("Filesystem access is not allowed by sandbox policy")) continue;

  text = text.replaceAll("promptOnBlock: true", "promptOnBlock: false");
  text = replaceOne(
    text,
    /^function readAllowed\(path, allowRead, denyRead, cwd\) \{\n  const deny = longestPrefixMatch\(path, denyRead, cwd\);\n  if \(deny < 0\)\n    return true;\n  return longestPrefixMatch\(path, allowRead, cwd\) >= deny;\n\}$/gm,
    "function readAllowed(path, allowRead, denyRead, cwd) {\n  const deny = longestPrefixMatch(path, denyRead, cwd);\n  const allow = longestPrefixMatch(path, allowRead, cwd);\n  if (allow < 0)\n    return false;\n  return deny < 0 || allow >= deny;\n}",
    "read allowlist",
  );
  text = replaceOne(
    text,
    /(\n {4}const existing = current\(\);\n {4}if \(existing\)\n {6}return existing;\n)(?: {4}if \(!ctx\.hasUI\) \{\n {6}return \{ allowed: false, prompted: false, reason: "Filesystem access requires approval" \};\n {4}\}\n)? {4}return permissionPrompts\.resolve\(current,[\s\S]*?\n {4}\}, options2\.signal\);\n {2}\}\n(?= {2}async function ensureDomainAllowed\()/g,
    "$1    return {\n      allowed: false,\n      prompted: false,\n      reason: \"Filesystem access is not allowed by sandbox policy\"\n    };\n  }\n",
    "native filesystem fallback",
  );
  text = replaceOne(
    text,
    /(\n {4}const existing = current\(\);\n {4}if \(existing\)\n {6}return existing;\n)(?: {4}if \(!ctx\.hasUI \|\| !promptOnBlock\)\n {6}return \{ action: "deny", reason: "unprompted" \};\n)? {4}return permissionPrompts\.resolve\(current,[\s\S]*?\n {4}\}, signal\);\n {2}\}\n(?= {2}function attachWorkerTrap\()/g,
    "$1    return { action: \"deny\", reason: \"unprompted\" };\n  }\n",
    "filesystem trap fallback",
  );
  text = replaceOne(
    text,
    / {4}const retryWithAccess = async \(operation, blockedPath\) => \{[\s\S]*?\n {4}\};\n(?= {4}let result;)/g,
    "    const retryWithAccess = async (_operation, _blockedPath) => null;\n",
    "bash retry fallback",
  );
  text = replaceOne(
    text,
    /( {6}if \(domainMatchesAny\(domain, allowedDomains\)\)\n {8}return true;\n {6})return;/g,
    "$1return false;",
    "domain allowlist default-deny",
  );
  fs.writeFileSync(file, text);
}
