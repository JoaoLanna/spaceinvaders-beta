--joao

w=1100
h=963

enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}

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
  player.firesound = love.audio.newSource('Laser_Shoot2.wav','static')
  player.fire=function() --  tiro do player
    if player.cooldown <=0 then
      love.audio.play(player.firesound)
      player.cooldown= 40
      bullet = {}
      bullet.y = player.y 
      bullet.size = 10
      bullet.x = player.x + playersprite:getWidth() - bullet.size/2
      table.insert(player.bullets,bullet)
    end
  end
  
  enemies_controller:spawnEnemy(player.x,400)   -- SPAWNANDO INIMIGOS
  
end
  
function enemies_controller:spawnEnemy(x,y)
  enemy = {} 
  enemy.x = x
  enemy.y = y
  enemy.width = 22
  enemy.height = 16
  enemy.bullets = {}
  enemy.cooldown = 20
  enemy.speed = 20
  enemy.scale = {x = 2, y = 2}
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
  checkCollisions(enemies_controller.enemies,player.bullets)
  
  if love.keyboard.isDown("right") then   -- ANDAR >
		player.x= player.x + player.setSpeed
	elseif love.keyboard.isDown("left") then   -- ANDAR <
		player.x= player.x - player.setSpeed
	end
  
  
  if love.keyboard.isDown("space")then  -- ATIRAR
		player.fire()
  end
  
  for _,e in pairs(enemies_controller.enemies)do
		e.y = e.y + 1
	end
  
  for i,b in ipairs(player.bullets) do
    b.y = b.y - 7
    if b.y < -10 then
      table.remove(player.bullets, i)
    end
  end
end

function CheckBoxCollision(x1,y1,w1,h1,x2,y2,w2,h2) return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1 end

  
function checkCollisions(enemies, bullets)
	for i, e in ipairs(enemies) do
    for v, b in pairs(bullets) do
      if CheckBoxCollision(e.x, e.y, e.width*e.scale.x, e.height * e.scale.y, b.x, b.y, b.size, b.size) then
        print("COLISAO")
        table.remove(enemies, i)
		    table.remove(bullets, v)
      end
    end
	end
end

function love.draw()

  love.graphics.draw(playersprite,player.x,player.y,0,2)  -- draw player
  --love.graphics.draw(navesprite,w*0.05,h*0.05)
  --arcade=love.graphics.draw(arcadesprite,1,1)
  
  for _,e in pairs(enemies_controller.enemies) do  -- draw enemy
    love.graphics.draw(navesprite, e.x, e.y,0, e.scale.x, e.scale.y )
  end
  
  
  love.graphics.setColor(255,255,255)	 -- DESENHA TIRO
	for _,b in pairs(player.bullets) do
		love.graphics.rectangle("fill", b.x, b.y, b.size, b.size)
	end
end       

function love.keypressed(key)
  if key=='escape' then  --  FECHA O JOGO
    love.event.quit()
  end

end
