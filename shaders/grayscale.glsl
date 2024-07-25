extern number screen_width;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 pixel = Texel(texture, texture_coords); // pixel color
    /*if (screen_coords.x < 210) {
                return pixel * color;
            }
            if (screen_coords.x < 420) {
                return pixel;
            }

            number avg = (pixel.r + pixel.g + pixel.b) / 3.0;
            pixel.r = avg;
            pixel.g = avg;
            pixel.b = avg;*/

    number avg = (pixel.r + pixel.g + pixel.b) / 3.0;
    number factor = screen_coords.x / screen_width;
    pixel.r = pixel.r + (avg - pixel.r) * factor;
    pixel.g = pixel.g + (avg - pixel.g) * factor;
    pixel.b = pixel.b + (avg - pixel.b) * factor;
    return pixel;
}
