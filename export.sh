#!/usr/bin/env bash

set -euxo pipefail

rm -rfv export/
mkdir -p export/{linux,windows}

godot -v --headless --export-release "Linux" ./export/linux/elektrisches_maskenspiel.x86_64
godot -v --headless --export-release "Windows Desktop" ./export/windows/elektrisches_maskenspiel.exe

cd export
zip -9 -r linux.zip linux
zip -9 -r windows.zip windows
