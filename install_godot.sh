#!/bin/bash

# Exit on error
set -e

BASE_URL="https://downloads.tuxfamily.org/godotengine"
VERSION="3.2.3"
CHANNEL="stable"
OS="linux_headless"
ARCHITECTURE="64"

GODOT_FILENAME="Godot_v${VERSION}-${CHANNEL}_${OS}.${ARCHITECTURE}"
GODOT_URL="${BASE_URL}/${VERSION}/${GODOT_FILENAME}.zip"
TEMPLATES_FILENAME="Godot_v${VERSION}-${CHANNEL}_export_templates.tpz"
TEMPLATES_URL="${BASE_URL}/${VERSION}/${TEMPLATES_FILENAME}"

INSTALL_PATH="${HOME}/.local/bin/godot"
TEMPLATES_PATH="${HOME}/.local/share/godot/templates"

if [[ ! $(type -P godot) ]]; then
	if [ ! -f ${GODOT_FILENAME} ]; then
		echo "Downloading ${GODOT_FILENAME}..."
		wget -q "${GODOT_URL}"
		unzip -q "${GODOT_FILENAME}.zip"
		rm "${GODOT_FILENAME}.zip"
	fi

	echo "Installing godot to '${INSTALL_PATH}'..."
	install -D "${GODOT_FILENAME}" "${INSTALL_PATH}"
fi


if [ ! -f "${TEMPLATES_PATH}/${VERSION}.${CHANNEL}/web_assembly_release.zip" ]; then
	if [ ! -f ${TEMPLATES_FILENAME} ]; then
		echo "Downloading templates..."
		wget -q "${TEMPLATES_URL}"
	fi
	
	echo "Installing templates to '${TEMPLATES_PATH}'..."
	mkdir -p "templates"
	cp "${TEMPLATES_FILENAME}" "templates.zip"
	unzip -q "templates.zip" 
	rm "templates.zip"
	mkdir -p "${TEMPLATES_PATH}"
	TEMPLATES_DESTINATION="${TEMPLATES_PATH}/$(cat 'templates/version.txt')"
	mv "templates"/* "${TEMPLATES_DESTINATION}"
	rmdir "templates"
fi

echo "Done!"

