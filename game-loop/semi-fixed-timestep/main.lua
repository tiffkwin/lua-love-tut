function love.load()
  image = love.graphics.newImage('/chicken-transparent.png')
end

function love.update(dt)

end

function love.draw()
  love.graphics.draw(image, love.math.random(0, 800), love.math.random(0, 600))
end

-- Semi-fixed timestep
function love.run()
  if love.math then
    love.math.setRandomSeed(os.time())
  end

  if love.load then love.load(arg) end

  -- We don't want the first frame's dt to include time taken by love.load.
  if love.timer then love.timer.step() end

  local dt = 1/60
  local frameTime = 0

  -- Main loop time.
  while true do
    -- Process events.
    if love.event then
      love.event.pump()
      for name, a,b,c,d,e,f in love.event.poll() do
        if name == "quit" then
          if not love.quit or not love.quit() then
            return a
          end
        end
        love.handlers[name](a,b,c,d,e,f)
      end
    end

    -- Update frameTime, as we'll be using it to update dt
    if love.timer then
      love.timer.step()
      frameTime = love.timer.getDelta()
    end

    while frameTime > 0 do
      deltaTime = math.min(dt, frameTime)
      if love.update then love.update(deltaTime) end
      frameTime = frameTime - deltaTime
    end

    -- Call update and draw
    -- if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

    if love.graphics and love.graphics.isActive() then
      love.graphics.clear(love.graphics.getBackgroundColor())
      love.graphics.origin()
      if love.draw then love.draw() end
      love.graphics.present()
    end

    if love.timer then love.timer.sleep(0.001) end
  end
end