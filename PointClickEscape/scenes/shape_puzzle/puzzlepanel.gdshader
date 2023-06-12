shader_type canvas_item;

// Helper function to convert RGB to HSV
vec3 rgb2hsv(vec3 rgb) {
    float max_value = max(max(rgb.r, rgb.g), rgb.b);
    float min_value = min(min(rgb.r, rgb.g), rgb.b);
    float chroma = max_value - min_value;

    vec3 hsv;
    if (chroma == 0.0) {
        hsv = vec3(0.0, 0.0, max_value);
    } else {
        if (max_value == rgb.r) {
            hsv.x = mod(((rgb.g - rgb.b) / chroma), 6.0);
        } else if (max_value == rgb.g) {
            hsv.x = ((rgb.b - rgb.r) / chroma) + 2.0;
        } else {
            hsv.x = ((rgb.r - rgb.g) / chroma) + 4.0;
        }
        hsv.x /= 6.0;

        hsv.y = chroma / max_value;
        hsv.z = max_value;
    }
    return hsv;
}

// Helper function to convert HSV to RGB
vec3 hsv2rgb(vec3 hsv) {
    float chroma = hsv.y * hsv.z;
    float x = chroma * (1.0 - abs(mod(hsv.x * 6.0, 2.0) - 1.0));
    vec3 rgb1 = vec3(chroma, x, 0.0);

    float m = hsv.z - chroma;
    rgb1.r += m;
    rgb1.g += m;
    rgb1.b += m;

    return rgb1;
}

// Define orange and red hues and threshold
const float orange_hue = 1.0 / 6.0;  // Orange hue (30 deg) in a scale of 0.0 - 1.0
const float red_hue = 0.0;           // Red hue (0 deg) in a scale of 0.0 - 1.0
const float hue_threshold = 0.15;   // Tolerance for hue difference

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    vec3 hsv_color = rgb2hsv(color.rgb);

    // Check for orange hue and change it to red while preserving brightness
    if (abs(hsv_color.x - orange_hue) <= hue_threshold) {
        hsv_color.x = red_hue;
        color.rgb = hsv2rgb(hsv_color);
    }

    COLOR = color;
}