#! /bin/bash

set -e

source dev-container-features-test-lib

check "nix exists" nix --version

reportResults
