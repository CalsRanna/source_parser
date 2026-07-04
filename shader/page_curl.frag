#include <flutter/runtime_effect.glsl>

uniform vec2   uResolution;       // (width, height)
uniform vec4   iMouse;            // (curX, curY, downX, downY)
uniform sampler2D uCurrentPage;   // current page texture
uniform sampler2D uNextPage;      // next page texture (revealed behind curl)

#define pi     3.14159265359
#define radius 0.05

out vec4 fragColor;

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    float aspect = uResolution.x / uResolution.y;

    // Normalize coordinates to [0, aspect] × [0, 1] for correct geometry
    vec2 uv    = fragCoord * vec2(aspect, 1.0) / uResolution.xy;
    vec2 mouse = iMouse.xy  * vec2(aspect, 1.0) / uResolution.xy;

    // Determine which corner the curl originates from.
    // iMouse.z (downX) > resolution.x/2 → right-side curl (forward)
    // iMouse.z (downX) < resolution.x/2 → left-side curl (backward)
    float cornerX = (iMouse.z > uResolution.x / 2.0) ? uResolution.x : 0.0;
    vec2 cornerFrom = (iMouse.w < uResolution.y / 2.0)
        ? vec2(cornerX, 0.0)
        : vec2(cornerX, uResolution.y);

    vec2 mouseDir = normalize(cornerFrom - iMouse.xy);

    // origin: where the curl axis meets the x-axis.
    float ratio = abs(mouse.x / mouseDir.x);
    vec2 origin = mouse - mouseDir * ratio;
    origin.y = clamp(origin.y, 0.0, 1.0);
    origin.x = clamp(origin.x, 0.0, aspect);

    // Prevent division by zero / extreme values near vertical drag
    if (abs(mouseDir.x) < 0.001) {
        origin = mouse;
    }

    float mouseDist = abs(mouse.x - origin.x);
    float proj = dot(uv - origin, mouseDir);
    float dist = proj - mouseDist;
    vec2 curlAxisLinePoint = uv - dist * mouseDir;

    // Corner attachment: push curl axis back toward the corner
    // so the page appears to curl naturally from the corner
    if (!(distance(mouse, cornerFrom * vec2(aspect, 1.0) / uResolution.xy) < pi * radius)) {
        float extra = (distance(mouse, cornerFrom * vec2(aspect, 1.0) / uResolution.xy) - pi * radius) / 2.0;
        curlAxisLinePoint = uv - dist * mouseDir + extra * mouseDir;
        dist -= extra;
    }

    // Sample UVs for both textures (revert aspect ratio for sampling)
    vec2 sampleUV = uv * vec2(1.0 / aspect, 1.0);

    if (dist > radius) {
        // Zone 1: Outside curl range → reveal next page
        fragColor = texture(uNextPage, sampleUV);
        // Subtle shadow near the curl edge
        float edgeDist = clamp(dist - radius, 0.0, 1.0);
        float shadow = pow(1.0 - edgeDist, 2.0) * 0.3;
        fragColor.rgb *= (1.0 - shadow);
    } else if (dist >= 0.0) {
        // Zone 2: On the cylinder surface (curling region)
        float theta = asin(dist / radius);
        vec2 p2 = curlAxisLinePoint + mouseDir * (pi - theta) * radius;
        vec2 p1 = curlAxisLinePoint + mouseDir * theta * radius;

        if (p2.x <= aspect && p2.y <= 1.0 && p2.x > 0.0 && p2.y > 0.0) {
            uv = p2;   // Show back of the page if within bounds
        } else {
            uv = p1;   // Otherwise show front
        }

        fragColor = texture(uCurrentPage, uv * vec2(1.0 / aspect, 1.0));
        // Pseudo-shadow: darker near the cylinder peak
        fragColor.rgb *= pow(clamp((radius - dist) / radius, 0.0, 1.0), 0.2);
    } else {
        // Zone 3: Behind the curl axis (already flipped region)
        vec2 p = curlAxisLinePoint + mouseDir * (abs(dist) + pi * radius);
        if (p.x <= aspect && p.y <= 1.0 && p.x > 0.0 && p.y > 0.0) {
            uv = p;
        }
        fragColor = texture(uCurrentPage, uv * vec2(1.0 / aspect, 1.0));
    }
}
