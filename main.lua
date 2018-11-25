--joao

w=1100
h=963

enemy={}
enemies_controller = {}
enemies_controller.enemies ={}

love.graphics.setDefaultFilter('nearest','nearest')
playersprite=love.graphics.newImage('player.png')
navesprite=love.graphics.newImage('android1.png')
arcadesprite=love.graphics.newImage('resizearcade.png')


function love.load()
  love.window.setMode(w,h)
  player = {}  --  player
  player.x = w*0.48
  player.y = h*0.75
  player.bullets = {}
  player.cooldown = 40
  player.setSpeed = 5
  player.image = love.graphics.newImage('player.png')
  player.fire=function() --  tiro do player
    if player.cooldown <=0 then
      player.cooldown= 40
      bullet = {}
      bullet.x = player.x 
      bullet.y = player.y 
      table.insert(player.bullets,bullet)
    end
  end
  
  enemies_controller:spawnEnemy(0,0)
  
end
  
function enemies_controller:spawnEnemy(x,y)
  enemy = {} 
  enemy.x = x
  enemy.y = y
  enemy.bullets = {}
  enemy.cooldown = 20
  enemy.speed = 10
  table.insert(self.enemies,enemy)
end

function enemy:fire()
  if self.cooldown <=0 then
    self.cooldown= 40
    bullet = {}
    bullet.x = self.x + 90
    bullet.y = self.y + 85
    table.insert(self.bullets,bullet)
  
  end
end

function love.update(dt)
  player.cooldown= player.cooldown - 1
  
  if love.keyboard.isDown("right") then   -- ANDAR >
		player.x= player.x + player.setSpeed
	elseif love.keyboard.isDown("left") then   -- ANDAR <
		player.x= player.x - player.setSpeed
	end
  
  if love.keyboard.isDown("space")then  -- ATIRAR
		player.fire()
  end
  
  for i,b in ipairs(player.bullets) do
    if b.y< -10 then
      table.remove(player.bullets, i)
    b.y = b.y - 10
	end
  
  for _,e in pairs(enemies_controller.enemies)do
		e.y = e.y + 1
	end

	--[checkCollisions(enemies_controller.enemies,player.bullets)]]
end
  
  --[[function checkCollisions(enemies, bullets)
	for i, e in ipairs(enemies) do
	    for _, b in ipairs(bullets) do
		if b.y <= e.y + e.getHeight and b.x > e.x and b.x < e.x + e.getWidth then
		    table.remove(enemies, i)
		    table.remove(bullets, i)
		end
	    end
	end]]
end

function love.draw()

  love.graphics.draw(playersprite,player.x,player.y,0,2)  -- draw player
  --love.graphics.draw(navesprite,w*0.05,h*0.05)
  --arcade=love.graphics.draw(arcadesprite,1,1)
  
  for _,e in pairs(enemies_controller.enemies) do  -- draw enemy
    love.graphics.draw(navesprite, e.x, e.y,0,8)
  end
  
  
  love.graphics.setColor(255,255,255)	 -- DESENHA TIRO
	for _,b in pairs(player.bullets) do
		love.graphics.rectangle("fill", b.x, b.y, 10, 10)
	end
end       

function love.keypressed(key)
  if key=='escape' then  --  FECHA O JOGO
    love.event.quit()
  end

end
