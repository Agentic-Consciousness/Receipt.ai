#!/usr/bin/env bash
# Backend checks on GitHub. There was no earlier pipeline, so this runs the documented pytest suite (README) in
# the Python 3.11 runtime the backend Dockerfile uses. The tests use in-memory SQLite and their own test keys;
# no real credentials or services are used.
set -euo pipefail
test "${GITHUB_SERVER_URL:?}" = 'https://github.com'
case "${GITHUB_REPOSITORY:?}" in
  HallyAus/Receipt.ai|Agentic-Consciousness/Receipt.ai) ;;
  *) echo "Unexpected repository: $GITHUB_REPOSITORY" >&2; exit 1 ;;
esac
test "$(git rev-parse HEAD)" = "${GITHUB_SHA:?}"
python -c 'import sys; assert sys.version_info[:2] == (3, 11), "Use the Python 3.11 runtime the backend Dockerfile uses"'
export PIP_DISABLE_PIP_VERSION_CHECK=1
cd backend
python -m pip install --no-cache-dir -r requirements.txt
python -m pytest -v
