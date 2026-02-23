#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform float uProgress;
uniform float uCurlRadius;
uniform float uShadowWidth;
uniform sampler2D uCurrentPage;
uniform sampler2D uNextPage;

out vec4 fragColor;

const float PI = 3.14159265359;

void main() {
  vec2 fragCoord = FlutterFragCoord().xy;
  vec2 uv = fragCoord / uResolution;

  float radius = uCurlRadius / uResolution.x;
  float shadow = uShadowWidth / uResolution.x;

  // 卷曲圆柱轴线位置：从右侧 (1.0) 移到左侧 (-radius)
  float cylinderX = 1.0 - uProgress * (1.0 + radius * 2.0);

  // 三个区域：
  // 1. cylinderX 左侧：已翻区域（下一页）
  // 2. cylinderX 到 cylinderX + PI * radius：卷曲区域
  // 3. cylinderX + PI * radius 右侧：未翻区域（当前页）

  float curlEnd = cylinderX + PI * radius;

  if (uv.x > curlEnd) {
    // 未翻区域：显示当前页
    fragColor = texture(uCurrentPage, uv);
  } else if (uv.x < cylinderX) {
    // 已翻区域：显示下一页
    vec4 nextColor = texture(uNextPage, uv);

    // 在卷曲边缘左侧添加阴影
    float dist = cylinderX - uv.x;
    if (dist < shadow) {
      float shadowAlpha = (1.0 - dist / shadow) * 0.4;
      nextColor.rgb *= (1.0 - shadowAlpha);
    }

    fragColor = nextColor;
  } else {
    // 卷曲区域
    float angle = (uv.x - cylinderX) / radius;

    if (angle <= PI) {
      // 卷曲的正面（当前页弯曲部分）
      float mappedX = cylinderX + radius * sin(angle);
      // 确保 mappedX 在有效范围内
      mappedX = clamp(mappedX, 0.0, 1.0);
      vec4 curlColor = texture(uCurrentPage, vec2(mappedX, uv.y));

      // 光照效果：卷曲顶部更亮，侧面更暗
      float lighting = 0.7 + 0.3 * sin(angle);
      curlColor.rgb *= lighting;

      // 在卷曲背面区域（angle > PI/2）混合阴影
      if (angle > PI * 0.5) {
        float backShadow = (angle - PI * 0.5) / (PI * 0.5) * 0.2;
        curlColor.rgb *= (1.0 - backShadow);
      }

      fragColor = curlColor;
    } else {
      // 不应该到这里，但作为安全保障
      fragColor = texture(uNextPage, uv);
    }
  }
}
