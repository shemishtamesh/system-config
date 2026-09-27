import * as os from "node:os";
import * as fs from "node:fs";
import * as path from "node:path";

export default function sessionTmp(pi: any) {
  pi.on("session_start", () => {
    const base = process.env.PI_SESSION_TMP_BASE ?? path.join(os.tmpdir(), "pi-agent");
    const sessionsBase = path.join(base, "sessions");
    fs.mkdirSync(sessionsBase, { recursive: true });
    const sessionDir = fs.mkdtempSync(path.join(sessionsBase, "session-"));
    process.env.PI_SESSION_TMP_BASE = base;
    process.env.TMPDIR = sessionDir;
    process.env.TEMP = sessionDir;
    process.env.TMP = sessionDir;
  });
}
