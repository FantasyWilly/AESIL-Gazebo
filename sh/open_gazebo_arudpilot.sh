#!/bin/bash

# 啟動 Gazebo
gnome-terminal --tab --title="Gazebo" -- bash -c "
gz sim -v4 -r aruco_runway.sdf;
exec bash
"

sleep 5

# 開啟影像串流
gnome-terminal --tab --title="Camera Stream" -- bash -c "
gz topic -t /world/aruco_runway_drone/model/copter-01/model/gimbal/link/pitch_link/sensor/camera/image/enable_streaming -m gz.msgs.Boolean -p 'data: 1';
exec bash
"

sleep 3

# 啟動 ArduCopter
gnome-terminal --tab --title="ArduCopter" -- bash -c "
cd ~/ardupilot;
sim_vehicle.py -v ArduCopter -I1 --console --model JSON \
  --add-param-file=\$HOME/gz_ws/src/AESIL-Gazebo/config/aruco-gimbal.parm \
  --mavproxy-args='--cmd=\"rc 6 1500; rc 7 1300; rc 8 1500\"';
exec bash
"

sleep 3

# 啟動 Rover
gnome-terminal --tab --title="Rover" -- bash -c "
cd ~/ardupilot;
sim_vehicle.py -v Rover -f rover-skid -I2 --console --map --model JSON \
  --add-param-file=\$HOME/gz_ws/src/AESIL-Gazebo/config/aruco-rover.param;
exec bash
"