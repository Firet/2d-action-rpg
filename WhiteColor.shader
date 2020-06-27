shader_type canvas_item;

// To export our shader and use with animation player we use uniform
uniform bool active = false; 

// fragment execute on every pixel inside of our image
void fragment() {
	// texture access a pixel on the texture
	// UV is kind of an x,y position on the sprite
	vec4 previous_color = texture(TEXTURE, UV);
	// Set color to white, the fourth value is alpha
	// We want the alpha value of previos color 
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
	vec4 new_color = previous_color;
	// It's not recommended to use if operators in shaders
	// But it's the simplest way to make the blink effect
	if (active == true) {
		new_color = white_color;
	} 
	COLOR = new_color;
}