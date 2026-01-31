#!/usr/bin/env bash

set -euxo pipefail

DEST_FILE="elektrisches_maskenspiel.zip"

rm -rfv export/ ${DEST_FILE}
mkdir -p export/{linux,windows}

godot -v --headless --export-release "Linux" ./export/linux/elektrisches_maskenspiel.x86_64
godot -v --headless --export-release "Windows Desktop" ./export/windows/elektrisches_maskenspiel.exe

cd export
zip -4 -r ../${DEST_FILE} .
