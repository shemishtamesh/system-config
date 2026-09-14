import * as fs from "node:fs";
import * as path from "node:path";

/**
 * Per-session temp dir for the pi sandbox.
 *
 * macOS `os.tmpdir()` resolves to `/var/folders/...` (== `/private/var`), which
 * the sandbox denies reading (see `macosDenyDirectories`). Pasted images are
 * written by the pi TUI to `os.tmpdir()/pi-clipboard-<uuid>.<ext>`, so they used
 * to land somewhere the agent could not re-read and never "see" the image.
 *
 * Instead of widening read access to `/private/var` (which holds unrelated temp
 * data), we re-root temp under the *current working directory* — the one path the
 * sandbox allows for both read and write (`"."`). We deliberately avoid a `.pi/`
 * inner folder because the landstrip deny-write list includes `.pi/`.
 */
export default function sessionTmp(pi: any) {
  pi.on("session_start", () => {
    const base =
      process.env.PI_SESSION_TMP_BASE ?? path.join(process.cwd(), ".pi-tmp");
    const sessionDir = path.join(base, `${Date.now()}`);
    fs.mkdirSync(sessionDir, { recursive: true });
    process.env.TMPDIR = sessionDir;
    process.env.TEMP = sessionDir;
    process.env.TMP = sessionDir;
  });
}