#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform float uProgress;
uniform sampler2D uCurrentPage;
uniform sampler2D uNextPage;

out vec4 fragColor;

void main() {
  vec2 fragCoord = FlutterFragCoord().xy;
  vec2 uv = fragCoord / uResolution;

  // 覆盖效果：前进时当前页向左滑出，下一页静止在底层
  // uProgress 0.0 = 未翻，1.0 = 完全翻过

  float slidePos = uProgress; // 当前页左移的比例

  // 当前页的偏移后 UV
  vec2 currentUV = vec2(uv.x + slidePos, uv.y);

  if (currentUV.x >= 0.0 && currentUV.x <= 1.0) {
    // 当前页仍然可见
    vec4 currentColor = texture(uCurrentPage, currentUV);

    // 在当前页右边缘添加阴影
    float edgeDist = currentUV.x; // 距离左边缘
    float shadowWidth = 0.05;
    float rightEdgeDist = 1.0 - currentUV.x; // 距离右边缘

    // 当前页右边缘的阴影（投射到下一页上）
    fragColor = currentColor;
  } else {
    // 当前页已滑走，显示下一页
    vec4 nextColor = texture(uNextPage, uv);

    // 在翻页边缘添加阴影
    float edgeX = 1.0 - slidePos; // 当前页左边缘在屏幕上的位置
    float dist = uv.x - edgeX;
    float shadowWidth = 0.08;

    if (dist >= 0.0 && dist < shadowWidth) {
      float shadowAlpha = (1.0 - dist / shadowWidth) * 0.3;
      nextColor.rgb *= (1.0 - shadowAlpha);
    }

    fragColor = nextColor;
  }
}
