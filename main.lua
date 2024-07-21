local init_x
local x
local y
local time = 0
local speed = 300
local max_w
function love.load()
	myImage = love.graphics.newImage("robot.png")
	-- myImage = love.graphics.newImage("rainbow.jpg")

	max_w = love.graphics.getWidth() - myImage:getWidth()
	y = math.floor((love.graphics.getHeight() - myImage:getHeight()) / 2)
	init_x = math.floor(max_w / 2)
	x = init_x
	myShader = love.graphics.newShader([[

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
            number factor = screen_coords.x /screen_width;
            pixel.r = pixel.r + (avg - pixel.r) * factor;
            pixel.g = pixel.g + (avg - pixel.g) * factor;
            pixel.b = pixel.b + (avg - pixel.b) * factor;
            return pixel;
        }
    ]])
	myShader:send("screen_width", love.graphics.getWidth())
end

function love.draw()
	love.graphics.setColor(1, 0, 0)
	love.graphics.setShader(myShader)
	love.graphics.draw(myImage, x, y)

	-- love.graphics.rectangle("fill", 300, 100, 100, 100)
	love.graphics.setShader()
end

local function move_by_time(dt)
	time = time + dt * 2
	x = init_x + math.sin(time) * init_x
end

function love.update(dt)
	move_by_time(dt)
end

function love.keypressed(key)
	if key == "escape" or key == "q" then
		love.event.quit()
	end
end
