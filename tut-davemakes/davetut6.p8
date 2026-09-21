pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
	--entities
	ents={
		--walls
		--left
		{
			x=-16,
			y=64,
			h=72,
			w=16,
		},
		--right
		{
			x=127+16,
			y=64,
			h=72,
			w=16
		},
		--top
		{
			x=64,
			y=-16,
			h=16,
			w=72,
		},
		--bottom
		{
			x=64,
			y=145,
			h=16,
			w=72,
			on_hit=function(w,o)
				o.remove=true
			end
		},
		ball_new(64,64,0.5,1),
	}

	pad=paddle_new()
	add(ents,pad)
	
	--bricks
	for y=16,48,8 do
		for x=0,127,16 do
			add(
				ents,
				brick_new(
					x+8,
					y+4,
					rnd({16,18,20,22,34})
				)
			)
		end
	end
end

function _update60()
 for i=1,#ents do
 	local e=ents[i]
 	if(e.update) e:update()
 end
 
 for i=#ents,1,-1 do
 	local e=ents[i]
 	
 	--vertical first
 	if e.vy and e.vy!=0 then
 		move(e,0,e.vy)
 	end
 	
 	--then horizontal
 	if e.vx and e.vx!=0 then
 		move(e,e.vx,0)
 	end
 	
 	--remove
 	if e.remove then
 		deli(ents,i)
 	end
 end
end

function _draw()
	cls(14)
	
	for e in all(ents) do
		if (e.draw) e:draw()
	end
end
-->8
--physics

--move an entity
function move(e,vx,vy)
	e.x+=vx
	e.y+=vy
	
	for o in all(ents) do
		-- if not me
		if o!=e then
			if collide(e,o) then
				resolve(e,vx,vy,o)
				
				--callback
				if(o.on_hit) o:on_hit(e)
				
				return -- stop checking
			end
		end
	end
end

function collide(e,o)
	return not e.remove
			 and e.y-e.h<o.y+o.h
	   and e.y+e.h>o.y-o.h
	   and e.x-e.w<o.x+o.w
	   and e.x+e.w>o.x-o.w
end

--resolve collisions
function resolve(e,vx,vy,o)
	local rest=e.rest or 1

	if vy!=0 then --vertical
		if vy>0 then --down
			e.y=o.y-o.h-e.h
		elseif vy<0 then --up
			e.y=o.y+o.h+e.h
		end
		
		if e.vy then
			if o.vy then
				--elastic collisions
				--for ball x ball
				e.vy,o.vy=o.vy,e.vy
			else
				e.vy*=-rest
			end
		end
	elseif vx!=0 then --horizontal
		if vx>0 then --right
			e.x=o.x-o.w-e.w
		else --left
			e.x=o.x+o.w+e.w
		end
		
		--bounce
		if e.vx then
		
			e.vx*=-rest
		end
	end
end
-->8
--paddle

function paddle_new()
	return {
		x=64,
		y=120,
		
		--velocity
		vx=0,
		acc=24/64,
		brake=24/64,
		fric=12/64,
		topspd=4,
		rest=1/2, --restitution
		
		--half width and height
		w=16,
		h=3,
		
		update=paddle_update,
		draw=paddle_draw,
		on_hit=paddle_hit,
	}
end

function paddle_update(p)
	local nx=0
	if(btn(⬅️)) nx-=1
	if(btn(➡️)) nx+=1
	--accel
	p.vx+=nx*p.acc
	
	--break force
	if sgn(p.vx)!=nx then
		p.vx+=nx*p.brake
	end
	
	if abs(p.vx)>p.fric then
		p.vx-=sgn(p.vx)*p.fric
	else
	 p.vx=0
	end
	
	-- limit top speed
	p.vx=mid(p.vx,-p.topspd,p.topspd)
end

function paddle_draw(p)
	--fill
	rectfill(
		p.x-p.w,p.y-p.h,
		p.x+p.w,p.y+p.h-2,
		7
	)
	
	--outline
	rect(
		p.x-p.w,p.y-p.h,
		p.x+p.w,p.y+p.h,
		1
	)
end

function paddle_hit(p,o)
	if o.vx then
		o.vx+=(o.x-p.x)/16
	end
end
-->8
--ball
function ball_new(x,y,vx,vy)
	return {
		x=x,
		y=y,
		vx=vx,
		vy=vy,
		topspd=4,
		
		w=3,
		h=3,
		
		im=1,
		
		draw=ball_draw,
		update=ball_update,
	}
end

function ball_draw(b)
	spr(b.im,b.x-b.w,b.y-b.h)
end

function ball_update(b)
	b.vx=mid(b.vx,-b.topspd,b.topspd)
	b.vy=mid(b.vy,-b.topspd,b.topspd)
end
-->8
function brick_new(x,y,im)
	local b={
		x=x,
		y=y,
		w=8,
		h=4,
		
		im=im,
		
		hp=1,
		remove=false,
		
		draw=brick_draw,
		on_hit=brick_hit,
	}
	
	--breakable bricks
	if im==34 then
		b.hp=2
		b.on_hit=function(b,o)
			b.im=36
			brick_hit(b,o)
		end
 end
	
	return b
end

function brick_draw(b)
	spr(b.im,b.x-b.w,b.y-b.h,2,1)
end

function brick_hit(b,o)
	b.hp-=1
	
	b.remove=b.hp<1
end
__gfx__
00000000001110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000001bbb1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007001b7bbb100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770001b7bbb100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770001bbbbb100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070001bbb1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444444444444444ccccccccccccccccaaaaaaaaaaaaaaaadddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000
004000400040004000c000c000c000c000a000a000a000a000d000d000d000d00000000000000000000000000000000000000000000000000000000000000000
004000400040004000c000c000c000c000a000a000a000a000d000d000d000d00000000000000000000000000000000000000000000000000000000000000000
4444444444444444ccccccccccccccccaaaaaaaaaaaaaaaadddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000
4000400040004000c000c000c000c000a000a000a000a000d000d000d000d0000000000000000000000000000000000000000000000000000000000000000000
4000400040004000c000c000c000c000a000a000a000a000d000d000d000d0000000000000000000000000000000000000000000000000000000000000000000
4444444444444444ccccccccccccccccaaaaaaaaaaaaaaaadddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeebbbbbbbbbbbbbbbb888888888888888822222222222222220000000000000000000000000000000000000000000000000000000000000000
00e000e000e000e000b000b000b000b0008000800080008000200020002000200000000000000000000000000000000000000000000000000000000000000000
00e000e000e000e000b000b000b000b0008000800080008000200020002000200000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeebbbbbbbbbbbbbbbb888888888888888822222222222222220000000000000000000000000000000000000000000000000000000000000000
e000e000e000e000b000b000b000b000800080008000800020002000200020000000000000000000000000000000000000000000000000000000000000000000
e000e000e000e000b000b000b000b000800080008000800020002000200020000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeebbbbbbbbbbbbbbbb888888888888888822222222222222220000000000000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000
