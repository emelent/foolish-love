//uniform vec2 screen;
uniform vec2 point;
uniform vec4 obstacle;

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 xy) {
    vec4 pixel = Texel(texture, uv) * color; // pixel color

    bool darken = false;
    // right side
    if (point.x < obstacle.x) {
        if (obstacle.x < xy.x) {

            // middle
            if (obstacle.x + obstacle.z < xy.x && (xy.y >= obstacle.y && xy.y <= obstacle.y + obstacle.w)) {
                darken = true;
            }
            // top triangle
            else if (point.y > obstacle.y && xy.y <= obstacle.y) {
                float m = (obstacle.y - point.y) / (obstacle.x - point.x);
                float c = point.y - (m * point.x);
                float y = m * xy.x + c;
                darken = xy.y > y;
            }

            // bottom right triangle
            else if (point.y < obstacle.y + obstacle.w && xy.y > obstacle.y + obstacle.w) {
                float m = (obstacle.y + obstacle.w - point.y) / (obstacle.x - point.x);
                float c = point.y - (m * point.x);
                float y = m * xy.x + c;
                darken = xy.y < y;
            }
        }
    }

    // left side
    else if (point.x > obstacle.x + obstacle.z) {
        if (obstacle.x + obstacle.z > xy.x) {

            // middle
            if (obstacle.x > xy.x && (xy.y >= obstacle.y && xy.y <= obstacle.y + obstacle.w)) {
                darken = true;
            }
            // top triangle
            else if (point.y > obstacle.y && xy.y <= obstacle.y) {
                float m = (obstacle.y - point.y) / (obstacle.x + obstacle.z - point.x);
                float c = point.y - (m * point.x);
                float y = m * xy.x + c;
                darken = xy.y > y;
            }
            // bottom triangle
            else if (point.y < obstacle.y + obstacle.w && xy.y > obstacle.y + obstacle.w) {
                float m = (obstacle.y + obstacle.w - point.y) / (obstacle.x + obstacle.z - point.x);
                float c = point.y - (m * point.x);
                float y = m * xy.x + c;
                darken = xy.y < y;
            }
        }
    }

    else if (point.y < obstacle.y) {
        // middle
        if (obstacle.y + obstacle.w < xy.y && (xy.x >= obstacle.x && xy.x <= obstacle.x + obstacle.z)) {
            darken = true;
        }
        // left triangle
        /*
                else if (point.y > obstacle.y && xy.y <= obstacle.y) {
                    float m = (obstacle.x - point.x) / (obstacle.y - point.y);
                    float c = point.x - (m * point.y);
                    float y = m * xy.x + c;
                    darken = xy.x < y;
                }
                */
    }
    else if (point.y > obstacle.y + obstacle.w) {
        // middle
        if (obstacle.y > xy.y && (xy.x >= obstacle.x && xy.x <= obstacle.x + obstacle.z)) {
            darken = true;
        }
    }

    if (darken) {
        pixel.r = max(pixel.r - 0.5, 0);
        pixel.g = max(pixel.g - 0.5, 0);
        pixel.b = max(pixel.b - 0.5, 0);
    }
    return pixel;
}
