#!/bin/bash

export DRTRANSCODE_UID=1234
export DRTRANSCODE_INPUT_BUCKET=bucky
export DRTRANSCODE_INPUT_KEY=keynan
local_input_filepath="barcode315893.mkv"
local_output_filepath="barcode315893.mp4"

function duration {
  out=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $1)
  if [ -z "$out" ];
    then
      echo 0
      # otherwise default 0
    else
      # if output present then send it
      echo "${out}"
  fi
}

function check_durations_to_file {
  echo "${DRTRANSCODE_UID},${DRTRANSCODE_INPUT_BUCKET},${DRTRANSCODE_INPUT_KEY},$(duration $local_input_filepath ),$(duration $local_output_filepath)" > "${DRTRANSCODE_UID}-durations.txt"
}

check_durations_to_file
