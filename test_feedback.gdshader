shader_type canvas_item;

uniform sampler2D current_texture;

void fragment() {
	// Place fragment code here.
	vec3 c=texture(current_texture,UV).rgb;
	
	float nr=c.r+0.01;
	if (nr>1.0){
		nr=0.0;
	}
	
	COLOR=vec4(nr,UV.x,UV.y,1.0);
}
