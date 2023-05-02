#!/bin/bash

echo "Checking if snap is installed"
if command -v snap >/dev/null 2>&1; then
	echo "Snap is already installed"
else
	echo "Installing snap"
	sudo apt install snapd
fi

echo "Checking if yq (a yaml parser) is installed"
if command -v yq >/dev/null 2>&1; then
	echo "Installing yq"
	pip install yq
else
	echo "Yq is already installed"
fi

# Yaml file with packages to install
yaml_file="packages.yml"

# Make sure everything is up to date
sudo apt update

# Loop through and install each package
for package in $(yq e '.packages[]' "$yaml_file"); do
	echo "Checking if $package is installed"
	if dpkg -s "$package" >/dev/null 2>&1; then
		echo "$package is already installed"
	else
		echo "Installing $package..."
		sudo apt install -y "$package"
	fi
done

echo "All packages have been installed successfully."
