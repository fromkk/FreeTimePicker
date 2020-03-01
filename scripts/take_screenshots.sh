#!/bin/sh

cd `dirname $0`
cd ../

resultDirectory=$(pwd)/Results
if [ -d $resultDirectory ]; then
    rm -rf $resultDirectory
fi
mkdir -p $resultDirectory

xcrun simctl shutdown
xcrun simctl erase all

devices=("iPhone 8 Plus" "iPhone 11 Pro Max" "iPad Pro (12.9-inch) (3rd generation)" "iPad Air (3rd generation)")

xcodebuild build-for-testing -workspace FreeTimePicker.xcworkspace -scheme FreeTimePicker -configuration Debug -sdk iphonesimulator

for ((i = 0; i < ${#devices[@]}; i++)); do
  device="${devices[$i]}"
  echo $device
  resultPath="$resultDirectory/$device.xcresult"
  echo $resultPath
  xcodebuild test-without-building -workspace FreeTimePicker.xcworkspace -scheme FreeTimePicker -configuration Debug -sdk iphonesimulator -destination "name=${device}" -testPlan FreeTimePickerUITest -resultBundlePath "$resultPath"
done
