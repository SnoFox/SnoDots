#!/usr/bin/env bash
ZELLIJ_VERSION=0.35.2
set -euo pipefail
tempdir=$(mktemp -d)
pushd $tempdir
case `uname -s` in
	Linux)
		KERNEL=unknown-linux-musl
		;;
	Darwin)
		KERNEL=apple-darwin
		;;
	*)
		echo "Unsupported kernel for Zellij"
		exit 1
		;;
esac
case `uname -m` in
	arm64)
		ARCH=aarch64
		;;
	x86_64)
		ARCH=x86_64
		;;
	*)
		echo "Unsupported architecture for Zellij"
		exit 1
		;;
esac

curl -sL --output zellij.tar.gz https://github.com/zellij-org/zellij/releases/download/v${ZELLIJ_VERSION}/zellij-${ARCH}-${KERNEL}.tar.gz
curl -sL --output zellij.sha256 https://github.com/zellij-org/zellij/releases/download/v${ZELLIJ_VERSION}/zellij-${ARCH}-${KERNEL}.sha256sum
tar -xf zellij.tar.gz
echo "$(<zellij.sha256)" | sha256sum --check --status
mv zellij ${HOME}/.local/bin
