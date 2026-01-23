#version 300 es

precision mediump float;

in vec2 v_texcoord;
out vec4 fragColor;

uniform sampler2D tex;

void main() {
    vec4 color = texture(tex, v_texcoord);

    // 🔹 Saturation
    float saturation = 1.10; // 1.1–1.5 recommended
    float luma = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
    vec3 gray = vec3(luma);
    color.rgb = mix(gray, color.rgb, saturation);

    // 🔹 Contrast
    float contrast = 1.1; // >1 increase, <1 decrease
    color.rgb = (color.rgb - 0.5) * contrast + 0.5;

    fragColor = color;
}

