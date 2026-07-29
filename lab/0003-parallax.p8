pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- collapsible tunnel
-- by ptrgags

function _init()
 --[[
 uv coordinates of the point
 at infinity 
 --]]
 u=0.5
 v=0.5
 speed=0.05
 
 --[[
 change in depth between each
 layer
 ]]
 d_depth=0.1
 depth_speed=0.05
 
 --see update code
 rects={}
end

w_screen=128

-- given a layer (1, 2, ...)
-- compute a parallax 
function parallax_rect(idx)
	local w=w_screen*(1-d_depth)^idx
	local margin=w_screen-w
	local x=u*margin
	local y=v*margin
	
	return {
		x1=x,y1=y,x2=x+w,y2=y+w
	}
end

function _update60()
 if btn(⬅️) then
  u-=speed
 elseif btn(➡️) then
  u+=speed
 elseif btn(⬆️) then
  v-=speed
 elseif btn(⬇️) then
  v+=speed
 elseif btnp(❎) then
  d_depth+=depth_speed
 elseif btnp(🅾️) then
 	d_depth-=depth_speed
 end
 
 u=mid(u, 0, 1)
 v=mid(v, 0, 1)
 d_depth=mid(d_depth,0.1,0.7)

 rects={
  parallax_rect(4),
  parallax_rect(3),
  parallax_rect(2),
  parallax_rect(1),
 }
end

function _draw()
	cls(0)
	
 for r in all(rects) do
  rect(
  	r.x1,
  	r.y1,
  	r.x2,
  	r.y2,
  7)
 end 

 --[[
 the first layer is always
 the full size of the screen
 --]]
	rect(0,0,127,127,7)
	
	--[[
	draw lines through all the
	corresponding corners to
	make it look more like a
	tunnel
	--]]
	line(
	 0,0,rects[1].x1, rects[1].y1)
	line(
	 127,0,rects[1].x2,rects[1].y1)
	line(
	 0,127,rects[1].x1,rects[1].y2)
	line(
	 127,127,rects[1].x2,rects[1].y2)
	
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
