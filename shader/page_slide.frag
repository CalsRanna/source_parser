#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform float uProgress;
uniform sampler2D uCurrentPage;
uniform sampler2D uNextPage;

out vec4 fragColor;

void main() {
  vec2 fragCoord = FlutterFragCoord().xy;
  vec2 uv = fragCoord / uResolution;

  // 当前页向左移出 progress * width，下一页从右侧移入
  float offset = uProgress;

  vec2 currentUV = uv + vec2(offset, 0.0);
  vec2 nextUV = uv - vec2(1.0 - offset, 0.0);

  if (currentUV.x >= 0.0 && currentUV.x <= 1.0) {
    fragColor = texture(uCurrentPage, currentUV);
  } else if (nextUV.x >= 0.0 && nextUV.x <= 1.0) {
    fragColor = texture(uNextPage, nextUV);
  } else {
    fragColor = vec4(0.0);
  }
}
