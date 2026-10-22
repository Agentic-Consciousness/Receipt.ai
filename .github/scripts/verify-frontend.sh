#!/usr/bin/env bash
# Frontend checks on GitHub: the production build (type check and Vite bundle) exactly as the frontend
# Dockerfile builds it. The frontend has no lockfile, so it installs the way that Dockerfile does.
# Nothing deploys and no real credentials are used.
set -euo pipefail
test "${GITHUB_SERVER_URL:?}" = 'https://github.com'
case "${GITHUB_REPOSITORY:?}" in
  HallyAus/Receipt.ai|Agentic-Consciousness/Receipt.ai) ;;
  *) echo "Unexpected repository: $GITHUB_REPOSITORY" >&2; exit 1 ;;
esac
test "$(git rev-parse HEAD)" = "${GITHUB_SHA:?}"
node -e 'if (process.versions.node.split(".")[0] !== "24") throw Error("Use the Node 24 runtime the frontend Dockerfile uses")'
export CI=1
cd frontend
npm install --no-audit --no-fund
npm run build
