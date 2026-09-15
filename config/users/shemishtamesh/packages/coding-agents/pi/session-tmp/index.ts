import * as os from "node:os";
import * as fs from "node:fs";
import * as path from "node:path";

export default function sessionTmp(pi: any) {
  pi.on("session_start", () => {
    const base =
      process.env.PI_SESSION_TMP_BASE ?? path.join(os.tmpdir(), "pi-agent", `${Date.now()}`);
    const sessionDir = path.join(base, `${Date.now()}`);
    fs.mkdirSync(sessionDir, { recursive: true });
    process.env.TMPDIR = sessionDir;
    process.env.TEMP = sessionDir;
    process.env.TMP = sessionDir;
  });
}
