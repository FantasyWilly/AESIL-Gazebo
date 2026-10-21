#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
ardupilot_gazebo_dir="${ARDUPILOT_GAZEBO_DIR:-$(dirname -- "$project_dir")/ardupilot_gazebo}"
export GZ_SIM_RESOURCE_PATH="$ardupilot_gazebo_dir/models:$project_dir/models:$project_dir/worlds${GZ_SIM_RESOURCE_PATH:+:$GZ_SIM_RESOURCE_PATH}"
export GZ_SIM_SYSTEM_PLUGIN_PATH="$ardupilot_gazebo_dir/build${GZ_SIM_SYSTEM_PLUGIN_PATH:+:$GZ_SIM_SYSTEM_PLUGIN_PATH}"
exec gz sim -v4 -r "$project_dir/worlds/zephyr_camera_runway.sdf" "$@"
