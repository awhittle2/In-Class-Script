#!/bin/bash

if command -v snap >/dev/null 2>&1; then
	echo "Snap is installed"
else
	sudo apt install snapd
fi

pip install yq


if ! command -v yq >/dev/null 2>&1; then
	echo "yq did not install properly"
	exit 1
fi

yaml_file="packages.yml"

sudo apt update

for package in $(yq e '.packages[]' "$yaml_file"); do
	echo "Installing $package..."
	sudo apt install -y "$package"
done

echo "All packages have been installed successfully."
