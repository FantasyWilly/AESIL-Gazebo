# 立方體標記模型

3×3×3 公尺的靜態立方體，具有碰撞幾何，六個面均使用 `materials/textures/error.png` 圖片。
模型原點在立方體中心；放在平地上時，pose 的 z 設為 1.5。

在任意 world 的 `<world>` 內加入：

```xml
<include>
  <uri>model://cube_target</uri>
  <name>target_01</name>
  <pose>0 200 1.5 0 0 0</pose>
</include>
```

`pose` 依序為 `x y z roll pitch yaw`，單位為公尺與弧度。
加入多個立方體時，使用不同的 `<name>` 和位置。
確保 `GZ_SIM_RESOURCE_PATH` 包含 `AESIL-Gazebo/models` 的絕對路徑。
複製此模型資料夾至其他專案的模型搜尋目錄即可重用。

## 替換六面圖片

圖片材質直接套用到 `cube_body` 的 box，六個面各顯示同一張完整圖片。
原本的頂面覆蓋平面與黑色 X 長條已移除。

直接替換 `materials/textures/error.png` 後重啟 Gazebo 即可。
若更換檔名，請同步修改 `model.sdf` 的 `albedo_map`。
建議使用正方形圖片，避免被拉伸。底面也有貼圖，但貼地時不可見。

修改模型會套用到所有引用它的 world；只改擺放位置則修改 world 中的 include pose。
