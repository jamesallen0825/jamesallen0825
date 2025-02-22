#!/bin/sh
set -e

cd "$(dirname $0)"

TARGET="${CARGO_TARGET_DIR:-../../../target}"

rustup target add wasm32-unknown-unknown

if [ "$1" = "--migration" ]; then
  selected_migration=$2
  extra_args="--features migrations,$selected_migration"
fi

cargo build --target wasm32-unknown-unknown --profile app-release $extra_args

mkdir -p res

cp $TARGET/wasm32-unknown-unknown/app-release/calimero_context_config_near.wasm ./res/

if command -v wasm-opt > /dev/null; then
  wasm-opt -Oz ./res/calimero_context_config_near.wasm -o ./res/calimero_context_config_near.wasm
fi
