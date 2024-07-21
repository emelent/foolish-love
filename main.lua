function love.load()
	myShader = love.graphics.newShader([[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec4 pixel = Texel(texture, texture_coords); // pixel color
            if (texture_coords.x > 0.5) {
                return pixel * color;
            } else {
               return vec4(1.0, 0.0, 1.0, 1.0);
            }
        }
    ]])

	myImage = love.graphics.newImage("robot.png")
end

function love.draw()
	love.graphics.setColor(1, 0, 0)
	love.graphics.setShader(myShader)
	love.graphics.draw(myImage, 100, 100)
	love.graphics.rectangle("fill", 300, 100, 100, 100)
	love.graphics.setShader()
end

function love.keypressed(key)
	if key == "escape" or key == "q" then
		love.event.quit()
	end
end
