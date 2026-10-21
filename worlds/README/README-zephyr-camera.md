# Zephyr 機頭固定相機

此版本引用官方 `zephyr_with_ardupilot`，新增固定相機；world、模型與啟動腳本均放在 AESIL-Gazebo。
需要原本可運作的 ardupilot_gazebo（包含 ArduPilotPlugin、GstCameraPlugin）。

## 啟動

在本目錄執行：

```bash
bash sh/zephyr_camera_runway.sh
```

腳本預設官方專案位於隔壁的 `../ardupilot_gazebo`，也可透過
`ARDUPILOT_GAZEBO_DIR` 指定位置。官方 models 優先，以免本專案同名的 runway 遮蔽官方跑道。
已有的 resource / plugin paths 會保留。

另開終端，啟動 ArduPlane SITL（需已設定 sim_vehicle.py）：

```bash
sim_vehicle.py -v ArduPlane -f gazebo-zephyr --model JSON --map --console
```

使用既有 Zephyr 飛控參數即可；固定相機不需要雲台 servo 或額外 .param。
相機增加 20 g 模擬質量，因此並非完全不影響重心。world 沿用官方初始姿態
（roll -90°），所以地面初始影像不一定水平；相機會跟隨飛機姿態，沒有穩定功能。

## 觀看影像

Gazebo 的 Image Display 選擇 `/zephyr/camera/image`。
相機預設 1280×720、30 FPS；模擬必須處於播放狀態。

若需要與 Iris 相同的 H.264 UDP 串流，在模擬開始且相機載入後執行：

```bash
gz topic -t /zephyr/camera/image/enable_streaming -m gz.msgs.Boolean -p 'data: true'
```

接收端設為 UDP H.264、port 5600（例如 QGroundControl）。目的地預設是
`127.0.0.1`；外部接收端需修改模型的 `udp_host`。若同時執行 Iris，請分配不同 port。

## 調整位置與固定角度

修改 `models/zephyr_with_camera/model.sdf` 的 `nose_camera_link`：

```xml
<pose relative_to="zephyr_with_ardupilot::zephyr::wing" degrees="true">0 -0.425 0.00 0 15 -90</pose>
```

六個數值依序為 `x y z roll pitch yaw`，位置單位是公尺，角度是度。
Zephyr 機體座標為 +X 左、-Y 前、+Z 上；相機朝向自身 +X，故 yaw 使用 -90°。

- `0 -0.55 0.05`：相對機翼原點，向機頭 0.55 m、向上 0.05 m。
- `pitch=15`：相對機身向下 15°；改成 `0` 水平向前，`30` 向下 30°。
- 保留 `roll=0`、`yaw=-90`，即可只調整俯視角度。

影像位置在相機外殼前方 0.025 m，避免拍到自身外殼。修改後重啟 Gazebo。
解析度、更新率、視角與 UDP 設定也都在此檔案。

## 檢查 SDF

從 AESIL-Gazebo 執行：

```bash
SDF_PATH="$PWD/../ardupilot_gazebo/models:$PWD/models" gz sdf -k worlds/zephyr_camera_runway.sdf
```
