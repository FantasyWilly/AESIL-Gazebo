#!/bin/bash

# 啟動 Gazebo
gnome-terminal --tab --title="Gazebo" -- bash -c "
gz sim -v4 -r cube_target_runway.sdf;
exec bash
"

sleep 3

# 開啟影像串流
gnome-terminal --tab --title="Camera Stream" -- bash -c "
gz topic -t /iris_fixed/camera/image/enable_streaming -m gz.msgs.Boolean -p 'data: 1';
exec bash
"

sleep 3

# 啟動 ArduCopter
# RC6 - Gimbal Roll, RC7 - Gimbal Pitch, RC8 - Gimbal Yaw
gnome-terminal --tab --title="ArduCopter" -- bash -c "
cd ~/ardupilot;
sim_vehicle.py -v ArduCopter --console --map --model JSON \
  --add-param-file=$HOME/gz_ws/src/AESIL-Gazebo/config/cube_iris.param -w ;
exec bash
"
