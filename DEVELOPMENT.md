# Development

Except for WebDAV all client code is generated using OpenAPI specifications which can be found in the `lib/src/api/` folder.  
These OpenAPI specifications are [generated](https://github.com/nextcloud/openapi-extractor) from the PHP source code.

## Dependencies

Besides Dart, you need to have the following dependencies installed on your system:
- [yq](https://github.com/kislyuk/yq)
- [jsonpatch](https://pypi.org/project/jsonpatch)
- [PHP](https://www.php.net)
- [composer](https://getcomposer.org)

Make sure to initialize the git submodules by running `git submodule update --init --recursive`.
This will add our external dependencies to `external/` so scripts can use them for generation.

## Checking test do not interfere with each other

All tests should be standalone and never affect any other tests.
With enough caution this is feasible to implement, but to verify the tests do not depend on the order of execution they should be run multiple times with different seeds:

```sh
for i in {0..4}; do flutter test --test-randomize-ordering-seed $i; done
```

## Run a test instance

For running a development Nextcloud instance:
- Install [docker](https://www.docker.com/get-started)
- Run the `./scripts/run-container.sh` script to start the server
- Development instance runs on http://localhost. To access it in an Android Emulator use http://10.0.2.2

## Testing against development versions

Make sure to have the following apps in your server development setup and the appropriate versions you want to test checked out:

- https://codeberg.org/NextPush/uppush
- https://framagit.org/framasoft/nextcloud/drop_account
- https://github.com/nextcloud/cookbook
- https://github.com/nextcloud/news
- https://github.com/nextcloud/notes
- https://github.com/nextcloud/notifications
- https://github.com/nextcloud/password_policy
- https://github.com/nextcloud/spreed
- https://github.com/nextcloud/tables
- https://github.com/nextcloud/text

To run the tests against development versions follow these steps:

```sh
cd /path/to/server
/path/to/nextcloud/packages/nextcloud_test_presets/docker/local.sh

# Open a second terminal
cd /path/to/nextcloud
URL="http://localhost:8080" DIR="/path/to/server" dart test --concurrency=1
```

Forcing the serial execution of all tests is necessary because the used SQLite database can be locked which results in tests blocking and failing other concurrent tests.
