pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
	r=16
	--grid center
	gx=64
	gy=64
	angle=0
	speed=0.01
	
	bullets={}
end

function _update60()

	if(btn(⬅️)) angle-=speed
	if(btn(➡️)) angle+=speed

	angle%=1
	
	if(btn(⬆️)) then
  gx+=cos(angle)
	 gy-=sin(angle)
	end
	
	if btnp(❎) then
		bullet_add(
			gx,gy,
			cos(angle),-sin(angle)
		)
	end
	
	bullet_update()
end

function _draw()
	cls()
	
	--draw a grid
	circ(gx,gy,r,1)
	line(gx-r,gy,gx+r,gy, 1)
	line(gx,gy-r,gx,gy+r, 1)
	
	--calculations
	local c=r*cos(angle)
	local s=r*sin(angle)
	line(gx,gy,gx+c,gy,3)
	line(gx,gy,gx,gy-s,3)
	
	circ(gx+c,gy-s,4,7)
	
	--draw text
	print(angle)
	print(flr(c))
	print(flr(s))
	
	bullet_draw()
end
-->8
--bullets

b_speed=5

function bullet_add(x,y,dx,dy)
 add(bullets,{
 	x=x,
 	y=y,
 	dx=dx*b_speed,
 	dy=dy*b_speed,
 	life=30
 })
end

function bullet_update()
 for b in all(bullets) do
  b.x+=b.dx
  b.y+=b.dy
  b.life-=1
  if b.life<=0 then
   del(bullets,b)
  end
 end
end

function bullet_draw()
 for b in all(bullets) do
  circfill(b.x,b.y,2,8)
 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
