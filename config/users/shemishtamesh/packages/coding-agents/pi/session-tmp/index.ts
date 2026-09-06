import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";

export default function sessionTmp(pi: any) {
  pi.on("session_start", () => {
    const sessionDir = path.join(os.tmpdir(), "pi-agent", `${Date.now()}`);
    fs.mkdirSync(sessionDir, { recursive: true });
    process.env.TMPDIR = sessionDir;
    process.env.TEMP = sessionDir;
    process.env.TMP = sessionDir;
  });
}
