#define MAX_VERTICES 100 // Adjust as needed

uniform vec2 point;
uniform int vertexCount;
uniform vec2 vertices[MAX_VERTICES];

bool pointInPolygon(vec2 p, vec2 vs[MAX_VERTICES], int vc) {
    bool inside = false;
    for (int i = 0, j = vc - 1; i < vc; j = i++) {
        vec2 vi = vertices[i];
        vec2 vj = vertices[j];

        bool intersect = ((vi.y > p.y) != (vj.y > p.y)) &&
                (p.x < (vj.x - vi.x) * (p.y - vi.y) / (vj.y - vi.y) + vi.x);

        if (intersect) inside = !inside;
    }
    return inside;
}

vec2 getLeftMostVertex(int y, vec2 vs[MAX_VERTICES], int vc) {
    vec2 result = vs[0];
    for (int i = 1; i < vc; i++) {
        vec2 v = vs[i];
        if (v.x < result.x)
            result = v;
        if (y != 0 && v.x == result.x) {
            if (y == -1 && v.y < result.y) {
                result = v;
            } else if (y == 1 && v.y > result.y) {
                result = v;
            }
        }
    }

    return result;
}

vec2 getRightMostVertex(int y, vec2 vs[MAX_VERTICES], int vc) {
    vec2 result = vs[0];
    for (int i = 1; i < vc; i++) {
        vec2 v = vs[i];
        if (v.x > result.x)
            result = v;
        if (y != 0 && v.x == result.x) {
            if (y == -1 && v.y < result.y) {
                result = v;
            } else if (y == 1 && v.y > result.y) {
                result = v;
            }
        }
    }

    return result;
}

vec2 getTopMostVertex(int x, vec2 vs[MAX_VERTICES], int vc) {
    vec2 result = vs[0];
    for (int i = 1; i < vc; i++) {
        vec2 v = vs[i];
        if (v.y < result.y)
            result = v;

        if (x != 0 && v.y == result.y) {
            if (x == -1 && v.x < result.x) {
                result = v;
            } else if (x == 1 && v.x > result.x) {
                result = v;
            }
        }
    }

    return result;
}

vec2 getBottomMostVertex(int x, vec2 vs[MAX_VERTICES], int vc) {
    vec2 result = vs[0];
    for (int i = 1; i < vc; i++) {
        vec2 v = vs[i];
        if (v.y > result.y)
            result = v;
        if (x != 0 && v.y == result.y) {
            if (x == -1 && v.x < result.x) {
                result = v;
            } else if (x == 1 && v.x > result.x) {
                result = v;
            }
        }
    }

    return result;
}

float getPosIndex(float value, float min_v, float max_v) {
    if (value > max_v)
        return 1.0;
    if (value < min_v)
        return -1.0;

    return 0.0;
}

float len(vec2 p1, vec2 p2) {
    vec2 diff = p2 - p1;
    return sqrt(diff.x * diff.x + diff.y * diff.y);
}

float getAngleBetween(vec2 p1, vec2 p2) {
    float hyp = len(p1, p2);
    float adj = len(p1, vec2(p2.x, p1.y));

    float n = adj / hyp;

    // Clampi n  to [-1, 1] to avoid domain errors
    n = clamp(n, -1.0, 1.0);

    return acos(n);
}

bool isPointWithinShadow(vec2 l, vec2 p, vec2 vs[MAX_VERTICES], int vc) {
    vec2 leftMostV = getLeftMostVertex(0, vs, vc);
    vec2 rightMostV = getRightMostVertex(0, vs, vc);
    vec2 topMostV = getTopMostVertex(0, vs, vc);
    vec2 bottomMostV = getBottomMostVertex(0, vs, vc);

    vec2 posIndex = vec2(
            getPosIndex(l.x, leftMostV.x, rightMostV.x),
            getPosIndex(l.y, topMostV.y, bottomMostV.y)
        );

    // light is in top center above object
    if (posIndex.x == 0 && posIndex.y == -1) {
        leftMostV = getLeftMostVertex(-1, vs, vc);
        rightMostV = getRightMostVertex(-1, vs, vc);
        topMostV = getTopMostVertex(0, vs, vc);

        if (p.y < l.y || p.y < topMostV.y) return false;
        vec2 v = rightMostV;

        // p is on the left side of light
        if (p.x < l.x) v = leftMostV;

        float min_theta = getAngleBetween(l, v);

        // calculate angle between l and p
        float theta = getAngleBetween(l, p);

        return theta > min_theta;
    }
    // light is in top center above object
    else if (posIndex.x == 0 && posIndex.y == 1) {
        leftMostV = getLeftMostVertex(1, vs, vc);
        rightMostV = getRightMostVertex(1, vs, vc);
        bottomMostV = getBottomMostVertex(0, vs, vc);
        if (p.y > l.y || p.y > bottomMostV.y) return false;
        vec2 v = rightMostV;

        // p is on the left side of light
        if (p.x < l.x) v = leftMostV;

        float min_theta = getAngleBetween(l, v);

        // calculate angle between l and p
        float theta = getAngleBetween(l, p);

        return theta > min_theta;
    }

    return false;
}

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 xy) {
    vec4 pixel = Texel(texture, uv) * color; // pixel color

    float thresh = 0.5;

    vec4 darkPixel = pixel;
    darkPixel.r = max(pixel.r - thresh, 0);
    darkPixel.g = max(pixel.g - thresh, 0);
    darkPixel.b = max(pixel.b - thresh, 0);

    if (pointInPolygon(point, vertices, vertexCount)) {
        return darkPixel;
    }
    // don't do anything if point is in polygon
    if (pointInPolygon(xy, vertices, vertexCount)) {
        return pixel;
    }

    if (isPointWithinShadow(point, xy, vertices, vertexCount)) {
        return darkPixel;
    }

    return pixel;
}
