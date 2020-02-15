#!/bin/sh

INFO_PLISTS=("$(pwd)/FreeTimePicker/Info.plist" "$(pwd)/Siri/Info.plist")
BUILD_NUMBER=$(git log --oneline | wc -l | tr -cd '0123456789')

for ((i = 0; i < ${#INFO_PLISTS[@]}; i++)); do
	plist=${INFO_PLISTS[$i]}
	/usr/libexec/PlistBuddy $plist -c "set CFBundleVersion $BUILD_NUMBER"
done

