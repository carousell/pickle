#!/bin/sh

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 VERSION_NUMBER"
  exit 1
fi

VERSION=$(carthage version)

if [[ $1 = "$VERSION" ]]; then
	echo "Using carthage $1"
	exit 0
fi

echo "$VERSION"
curl -OL "https://github.com/Carthage/Carthage/releases/download/$1/Carthage.pkg"
sudo installer -pkg Carthage.pkg -target /
rm Carthage.pkg
carthage version
