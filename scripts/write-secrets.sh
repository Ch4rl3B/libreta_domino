#!/usr/bin/env bash

set -euo pipefail

SOURCE="

class Secrets {
  static const b4aApplicationId = '${B4A_APPLICATION_ID:-null}';
  static const b4aClientKey = '${B4A_CLIENT_KEY:-null}';
  static const b4aParseServerUrl = '${B4A_SERVER_URL:-https://truefreetour.b4a.io}';
}

"

mkdir -p lib/generated
echo "${SOURCE}" > lib/generated/secrets.dart
fvm dart format lib/generated/secrets.dart

exit 0