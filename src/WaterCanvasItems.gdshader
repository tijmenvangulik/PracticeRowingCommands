shader_type canvas_item;

uniform sampler2D screen_texture ;

uniform vec4 color = vec4(0.2, 0.3, .5, 0.5);

uniform float frequency = 6.0;
uniform float compress = 1.0;
uniform float add_light = 0.0;

uniform float scale = 0.6;
uniform float speed = 0.08;
uniform float x_angle = 1.57;
uniform float y_angle = 1.57;
uniform float base_alpha = 0.2;
uniform float refraction_ratio = 1.0;
uniform float clear = 0.0;

uniform float surf_sinpowder = 8.0;
uniform float surf_speed = 1.0;
uniform float surf_angle = 1.57;
uniform float surf_magnitude = 0.0;

uniform float s11 = 2.221;
uniform float sinpowder = 8.0;

vec2 UVtoScreenUV(vec2 uv, bool is_camera_center, vec2 texture_pixel_size, vec2 screen_pixel_size, vec4 fragcoord) {
    vec2 suv = (uv - 0.5) * 2.0;
    if (is_camera_center) {
        return (fragcoord.xy + suv * 0.01 / texture_pixel_size) * screen_pixel_size * 0.5;
    } else {
        return (fragcoord.xy + suv * 0.01 / texture_pixel_size) * screen_pixel_size;
    }
}

vec2 shiftuv2(vec2 uv, float shiftratio) {
    vec2 suv = (uv - 0.5) * 2.0;
    return (suv + suv * -1.0 * shiftratio) * 0.5 + 0.5;
}

float yget(float x,float fc1,float fc2,float fc3,float fc4,
           float tc1,float tc2,float tc3,float tc4,
           float amc1,float amc2,float amc3,float amc4,
           float way,float addt) {
    float t = speed * TIME * way + addt;
    float y = sin(x * frequency);

    y += pow(abs(sin(x*frequency*fc1 + t*tc1)), sinpowder) * amc1;
    y += pow(abs(sin(x*frequency*fc2 + t*tc2)), sinpowder) * amc2;
    y += pow(abs(sin(x*frequency*fc3 + t*tc3)), sinpowder) * amc3;
    y += pow(abs(sin(x*frequency*fc4 + t*tc4)), sinpowder) * amc4;
    y /= (amc1+amc2+amc3+amc4);

    return y;
}

void fragment() {
    vec2 st = (UV - 0.5) * 2.0 * scale;

    // Approximate derivative length using neighbor sampling
    float dx = SCREEN_PIXEL_SIZE.x;
    float dy = SCREEN_PIXEL_SIZE.y;

    vec2 offset_x = st + vec2(dx, 0.0);
    vec2 offset_y = st + vec2(0.0, dy);

    float dl = distance(st, offset_x) + distance(st, offset_y);

    vec2 st2 = ((UV - 0.5) * 2.0 + dl) * scale;

    float x = st.x;
    float y = st.y;

    float adda = pow(abs(sin(surf_speed * TIME * scale + x*sin(surf_angle) + y*cos(surf_angle))), surf_sinpowder) * surf_magnitude;
    st.x += adda * cos(surf_angle);
    st.y += adda * sin(surf_angle);

    COLOR = color;

    float a1 = (
        yget(distance(vec2(0.0), st),1.30,1.72,s11,3.1122,1.0,1.121,0.437,4.0,4.5,4.0,5.0,2.5,1.0,0.0) +
        yget(distance(vec2(0.5,3.5), st),1.32,1.72,s11,3.1122,1.0,1.121,0.437,4.269,4.5,4.0,5.0,2.5,-1.0,0.0) +
        yget(distance(vec2(4.5,-4.5), st),1.31,1.72,s11,3.1122,1.0,1.121,0.437,4.269,4.5,4.0,5.0,2.5,1.0,0.0) +
        yget(distance(vec2(-5.5,-2.5), st),1.27,1.72,s11,3.1122,1.0,1.121,0.437,5.0,4.5,4.0,5.0,2.5,-1.0,0.0) +
        yget(distance(vec2(-7.5,3.5), st),1.25,1.72,s11,3.1122,1.0,1.121,0.437,5.0,4.5,4.0,5.0,2.5,1.0,0.0) +
        yget(distance(vec2(3.25,3.25), st),1.34,1.72,s11,3.1122,1.0,1.121,0.437,4.269,4.5,4.0,5.0,2.5,1.0,0.0) +
        yget(distance(vec2(6.25,-4.25), st),1.36,1.72,s11,3.1122,1.0,1.121,0.437,4.269,4.5,4.0,5.0,2.5,-1.0,0.0) +
        yget(distance(vec2(-7.25,-1.25), st),1.27,1.72,s11,3.1122,1.0,1.121,0.437,5.0,4.5,4.0,5.0,2.5,1.0,0.0) +
        yget(distance(vec2(-0.25,5.25), st),1.59,1.72,s11,3.1122,1.0,1.121,0.437,5.0,4.5,4.0,5.0,2.5,-1.0,0.0)
    ) / 9.0;

    float a2 = (
        yget(distance(vec2(0.0), st2),1.30,1.72,s11,3.1122,1.0,1.121,0.437,4.0,4.5,4.0,5.0,2.5,1.0,0.0) +
        yget(distance(vec2(0.5,3.5), st2),1.32,1.72,s11,3.1122,1.0,1.121,0.437,4.269,4.5,4.0,5.0,2.5,-1.0,0.0) +
        yget(distance(vec2(4.5,-4.5), st2),1.31,1.72,s11,3.1122,1.0,1.121,0.437,4.269,4.5,4.0,5.0,2.5,1.0,0.0) +
        yget(distance(vec2(-5.5,-2.5), st2),1.27,1.72,s11,3.1122,1.0,1.121,0.437,5.0,4.5,4.0,5.0,2.5,-1.0,0.0) +
        yget(distance(vec2(-7.5,3.5), st2),1.25,1.72,s11,3.1122,1.0,1.121,0.437,5.0,4.5,4.0,5.0,2.5,1.0,0.0) +
        yget(distance(vec2(3.25,3.25), st2),1.34,1.72,s11,3.1122,1.0,1.121,0.437,4.269,4.5,4.0,5.0,2.5,1.0,0.0) +
        yget(distance(vec2(6.25,-4.25), st2),1.36,1.72,s11,3.1122,1.0,1.121,0.437,4.269,4.5,4.0,5.0,2.5,-1.0,0.0) +
        yget(distance(vec2(-7.25,-1.25), st2),1.27,1.72,s11,3.1122,1.0,1.121,0.437,5.0,4.5,4.0,5.0,2.5,1.0,0.0) +
        yget(distance(vec2(-0.25,5.25), st2),1.59,1.72,s11,3.1122,1.0,1.121,0.437,5.0,4.5,4.0,5.0,2.5,-1.0,0.0)
    ) / 9.0;

    float da = clamp((a2 - a1) * compress, 0.0, 1.0);
    float ang = atan(da / (dl + 0.0001)); // prevent divide by zero

    vec2 rUV = UV;
    rUV.y = (1.0 - rUV.y) + FRAGCOORD.y * SCREEN_PIXEL_SIZE.y;

    vec4 bC = texture(screen_texture, UVtoScreenUV(shiftuv2(UV, ang * refraction_ratio), false, TEXTURE_PIXEL_SIZE, SCREEN_PIXEL_SIZE, FRAGCOORD));

    float a = ((sin(ang - 3.14159*0.5 + y_angle) + cos(ang - 3.14159*1.5 + x_angle)) + adda) / 1.5;

    COLOR.a = clamp(base_alpha + a, 0.0, 1.0);
    COLOR.rgb = clamp(COLOR.rgb + mix(vec3(COLOR.a), bC.rgb, clear) * vec3(1.0 + add_light), vec3(0.0), vec3(1.0));
}
