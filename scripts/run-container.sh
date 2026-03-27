#!/usr/bin/env bash
set -euxo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh

if [ "$#" -eq 1 ]; then
    preset="$1"
else
    preset="packages/nextcloud_test_presets/docker/presets/latest"
fi

./scripts/build-containers.sh "$preset"

echo "Running development instance on http://localhost. To access it in an Android Emulator use http://10.0.2.2"

tag="$(preset_image_tag "$preset")"
volume="nextcloud-neon-dev-$(echo "$tag" | cut -d ":" -f 2)"
container="$(docker run -d --rm -v "$volume":/usr/src/nextcloud -v "$volume":/var/www/html --network=host "$tag" php -S 0.0.0.0:8080)"
function cleanup() {
    docker kill "$container"
}
trap cleanup EXIT

docker logs -f "$container" &

sleep infinity
