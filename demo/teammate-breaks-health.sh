#!/usr/bin/env bash
# A staged scenario, declared as such: a teammate ships a release whose health check fails.
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
from pathlib import Path
path = Path("backend/app/api/routes/utils.py")
marker = "async def health_check() -> bool:\n"
text = path.read_text()
assert marker in text
path.write_text(text.replace(marker, marker + '    raise RuntimeError("release 1.6 broke the database pool")\n', 1))
PY
git -c user.name="A teammate (staged)" -c user.email=team@example.com commit -qam "release 1.6"
git push -q origin HEAD:main
bash scripts/deploy-via-github.sh || echo "the team's deploy failed its health check"
