local screen
local obstacle = {
	x = 200,
	y = 200,
	w = 100,
	h = 200,
}
local point = {
	x = 200,
	y = 300,
}
local lightShader
local sheepImage
local bgImage

function love.load()
	sheepImage = love.graphics.newImage("sheep.png")
	bgImage = love.graphics.newImage("background.png")

	lightShader = love.graphics.newShader("shaders/shadow.glsl")
	screen = { x = love.graphics.getWidth(), y = love.graphics.getHeight() }
	-- lightShader:send("screen", { screen.x, screen.y })
	lightShader:send("point", { point.x, point.y })
	lightShader:send("vertexCount", 4)
	lightShader:send(
		"vertices",
		unpack({
			{ obstacle.x, obstacle.y },

			{ obstacle.x + obstacle.w, obstacle.y },

			{ obstacle.x + obstacle.w, obstacle.y + obstacle.h },

			{ obstacle.x, obstacle.y + obstacle.h },
		})
	)
end

function love.draw()
	love.graphics.setBackgroundColor(1, 1, 1)
	love.graphics.setShader(lightShader)
	love.graphics.draw(bgImage)

	love.graphics.setColor(1, 0, 0)

	love.graphics.rectangle("fill", obstacle.x, obstacle.y, obstacle.w, obstacle.h)

	love.graphics.draw(sheepImage, 400, 300)

	-- draw light dot
	love.graphics.setColor(0.4, 0.9, 0.6, 1)
	love.graphics.setShader()
	love.graphics.circle("fill", point.x, point.y, 4)
	love.graphics.setColor(1, 1, 1)
end

function love.update(dt)
	if love.keyboard.isDown("left") then
		point.x = point.x - 200 * dt
	elseif love.keyboard.isDown("right") then
		point.x = point.x + 200 * dt
	end
	if love.keyboard.isDown("up") then
		point.y = point.y - 200 * dt
	elseif love.keyboard.isDown("down") then
		point.y = point.y + 200 * dt
	end

	lightShader:send("point", { point.x, point.y })
end

function love.keypressed(key)
	if key == "escape" or key == "q" then
		love.event.quit()
	end
end
