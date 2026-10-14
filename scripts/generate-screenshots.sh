#!/usr/bin/env bash
# Renders the README screenshots on an iOS simulator.
#
# The images come from Tests/SwiftUIComponentsTests/RenderTests.swift, which draws the
# gallery pages in Tests/SwiftUIComponentsTests/Gallery.swift with ImageRenderer.
#
# Usage: scripts/generate-screenshots.sh ["iPhone 17 Pro"]
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
simulator="${1:-}"

if [[ -z "$simulator" ]]; then
  simulator="$(xcrun simctl list devices available | grep -m1 -oE 'iPhone [^(]+' | sed 's/ *$//')"
fi
if [[ -z "$simulator" ]]; then
  echo "No available iPhone simulator found." >&2
  exit 1
fi

output_dir="$repo_root/docs/images"
mkdir -p "$output_dir"
echo "Rendering on '$simulator' into $output_dir"

cd "$repo_root"
# Variables prefixed with TEST_RUNNER_ are forwarded to the test process without the prefix.
TEST_RUNNER_SCREENSHOT_DIR="$output_dir" xcodebuild test \
  -scheme SwiftUIComponents \
  -destination "platform=iOS Simulator,name=$simulator" \
  -only-testing:SwiftUIComponentsTests/RenderTests \
  -quiet

ls -1 "$output_dir"
