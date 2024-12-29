#!/bin/bash

# Color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
END='\033[0m'

# Check if debug mode is enabled
DEBUG=false
if [ "$1" == "-d" ]; then
  DEBUG=true
  shift
fi

# Check if build mode is enabled with the -b flag
BUILD_MODE=false
PARAM_FOLDER=""

if [ "$1" == "-b" ]; then
  BUILD_MODE=true
  shift
  PARAM_FOLDER=$1
  shift
fi

# Check if the firmware file path or folder is provided
if [ -z "$1" ] && [ "$BUILD_MODE" = false ]; then
  echo -e "${RED}[-]${END} Please provide the firmware file path or use the -b flag with a folder path."
  echo -e "${YELLOW}[*]${END} Usage:  $0 [-d] <firmware_file_path> | -b <folder_path>"
  docker rm -f $CONTAINER_NAME && exit 0
fi

# CONTAINER_NAME="firmware_mod_kit_container"
randc=$(head /dev/urandom | tr -dc a-f0-9 | head -c 8)
CONTAINER_NAME="fmkfast_$randc"
LOCAL_FOLDER=$(pwd)
TO_ANA_BIN="to_ana_bin_$randc"

# Start Docker container
echo -e "${YELLOW}[*]${END} Starting Docker container..."
if $DEBUG; then
  docker run -itd --name $CONTAINER_NAME --rm n1neman/fmk
else
  docker run -itd --name $CONTAINER_NAME --rm n1neman/fmk >/dev/null
fi

if [ $? -ne 0 ]; then
  echo -e "${RED}[-]${END} Failed to start Docker container."
  docker rm -f $CONTAINER_NAME && exit 1
fi

# If BUILD_MODE is enabled, copy the specified folder and build the new firmware
if $BUILD_MODE; then
  if [ -d "$PARAM_FOLDER" ]; then
    echo -e "${YELLOW}[*]${END} Copying folder '$PARAM_FOLDER' to Docker container..."
    docker cp "$PARAM_FOLDER" "$CONTAINER_NAME:/firmware-mod-kit/fmk"

    echo -e "${YELLOW}[*]${END} Building new firmware from '$PARAM_FOLDER'..."
    docker exec -it $CONTAINER_NAME bash -c "cd /firmware-mod-kit && ./build-firmware.sh"

    if [ $? -eq 0 ]; then
      echo -e "${GREEN}[+]${END} Firmware built successfully."
      docker cp "$CONTAINER_NAME:/firmware-mod-kit/fmk/new-firmware.bin" "$LOCAL_FOLDER"
      echo -e "${GREEN}[+]${END} New firmware copied to the host machine."
    else
      echo -e "${RED}[-]${END} Firmware build failed."
    fi

    docker stop $CONTAINER_NAME
    docker rm -f $CONTAINER_NAME && exit 0
  else
    echo -e "${RED}[-]${END} Provided folder '$PARAM_FOLDER' does not exist."
    docker stop $CONTAINER_NAME
    docker rm -f $CONTAINER_NAME && exit 1
  fi
fi

# Normal extraction mode
FIRMWARE_FILE=$1
FIRMWARE_FILE=${FIRMWARE_FILE#./}
echo -e "${YELLOW}[*]${END} Extracting firmware from '$FIRMWARE_FILE'..."

# Copy firmware file to temporary file
cp "$FIRMWARE_FILE" "$TO_ANA_BIN"

# Copy firmware file to Docker container
if $DEBUG; then
  docker cp "$TO_ANA_BIN" "$CONTAINER_NAME:/firmware-mod-kit/"
else
  docker cp "$TO_ANA_BIN" "$CONTAINER_NAME:/firmware-mod-kit/" >/dev/null
fi

if [ $? -ne 0 ]; then
  echo -e "${RED}[-]${END} Failed to copy firmware file to Docker container."
  docker rm -f $CONTAINER_NAME
  rm "$TO_ANA_BIN"
  docker rm -f $CONTAINER_NAME && exit 1
fi

# Extract firmware file in Docker container
if $DEBUG; then
  docker exec -it $CONTAINER_NAME bash -c "cd /firmware-mod-kit && ./extract-firmware.sh $TO_ANA_BIN"
else
  docker exec -it $CONTAINER_NAME bash -c "cd /firmware-mod-kit && ./extract-firmware.sh $TO_ANA_BIN" >/dev/null
fi

if [ $? -eq 0 ]; then
  echo -e "${GREEN}[+]${END} Firmware extracted successfully."
  docker cp "$CONTAINER_NAME:/firmware-mod-kit/fmk" "$LOCAL_FOLDER/fmk_$FIRMWARE_FILE" >>/dev/null
  echo -e "${GREEN}[+]${END} '${YELLOW}fmk_$FIRMWARE_FILE${END}' folder copied to the host machine."
else
  echo -e "${RED}[-]${END} Firmware extraction failed."
fi

# Clean up
docker rm -f $CONTAINER_NAME >>/dev/null
rm "$TO_ANA_BIN"
