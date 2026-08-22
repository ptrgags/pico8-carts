pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--lerpy crow

grav=1/8

p_spd=-2
p_width=24
gap_min=40
gap_range=40
y_min=12
y_range=128-y_min*2
x_min=80
x_range=50

best=0
score=0

function lerp(a,b,t)
	return (1-t)*a+t*b
end

-- ui

function score_draw()
	print("score:"..score,2,2,0)
	
	if best>0 then
		print("best:"..best,2,8,0)
	end
end


-- main

function _init()
	cartdata("ptrgags_lerpybird_1")
	best=dget(0)
 title_init()
end

function _update60()
	if scene=="title" then
		title_update()
	elseif scene=="game" then
		game_update()
	end
end

function _draw()
	if scene=="title" then
		title_draw()
	elseif scene=="game" then
		game_draw()
	end
end
-->8
--title scene
function title_init()
	scene="title"
end

function title_update()
	if btn(⬆️) and btnp(🅾️) then
		best=0
		dset(0,best)			
	elseif btnp(🅾️) or btnp(❎) then
		game_init()
	end
end

function title_draw()
	cls(12)
	
	local txt="lerpy crow"
	--half width of text, 4px/char
	print(txt,64-#txt*2,60,7)
	
	if best>0 then
		score_draw()
	end
end
-->8
--game scene
function game_init()
	scene="game"
	score=0
	
	bird=bird_new()
	pipes=pipes_new()
end

function game_update()
 bird_update(bird)
 
 if not bird.alive then
	 return
 end
 
	pipes_update(pipes)
 
 if collide(bird,pipes) then
 	bird_lose(bird)
 end
end

function game_draw()
	cls(15)
	
	pipes_draw(pipes)
	bird_draw(bird)
	
	score_draw()
end

-- collision
function collide(b,tbl)
	for p in all(tbl) do
		if b.x+b.r>p.x
		and b.x-b.r<p.x+p_width
		and (b.y-b.r<p.y
		or b.y+b.r>p.y+p.gap)
		then
			return true
		end
	end
	
	return false
end
-->8
--bird

function bird_new()
	return {
		x=16,
		y=32,
		r=2,
		wing=32,
		
		--velocity
		vx=0,
		vy=0,
		
		flap=-3,
		
		alive=true,
		
		angle=0,
		cbody=1,
		cnose=9,
		cwing=1,
	}
end

function bird_lose(b)
	b.alive=false
	
	b.vy=-3
	b.vx=-1/4
	
	best=max(best,score)
	dset(0,best)
end

function bird_update(b)
	if b.y>128+48 then
		title_init()
		return
	end

	b.vy+=grav
	
	if btnp() > 0 and b.alive then
		b.vy=b.flap
 end
	
	b.x+=b.vx
	b.y+=b.vy
end

function bird_draw(b)
	local prev_angle=b.angle
	
	if b.alive then
		b.angle=b.vy/16
	else
		b.angle-=1/32
	end
	
	local a=lerp(prev_angle,b.angle,0.5)
	
	--nose
	circfill(
	 b.x+cos(a)*(b.r+3),
	 b.y-sin(a)*(b.r+3),
	 b.r,
	 b.cnose
	)
	
	--tail
	circfill(
		b.x+cos(a-0.5)*(b.r+1),
		b.y-sin(a-0.5)*(b.r+1),
		b.r+2,
		b.cbody
	)

	--body
	circfill(
		b.x,
		b.y,
		b.r+2,
		b.cbody
	)
	
	--eye
	circfill(
		b.x,
		b.y,
		b.r,
		7
	)
	circfill(
		b.x,
		b.y,
		b.r-1,
		0
	)
	
	--wings
	if b.alive then
		local wy=b.y+b.r+1
		local wo=4
		-- if bird is falling
		if b.vy>0 then
			wy=b.y-b.r-1
			wo=-2
		end
		b.wing=lerp(b.wing,wy,0.4)
		ovalfill(
			b.x-7,
			b.wing-2,
			b.x,
			b.wing+2,
			b.cwing
		)
		ovalfill(
			b.x-7,
			b.wing-3,
			b.x-2,
			b.wing+wo,
			b.cwing
		)
	else	
		circfill(
			b.x+cos(a-0.5)*(b.r+3),
			b.y-sin(a-0.5)*(b.r+1),
			b.r,
			b.cwing
		)
	end
end
-->8
--pipes

function pipes_new()
	local tbl={}
	
	for i=1,3 do
		tbl[i] = {
			x=0,
			y=0,
			gap=0,
		}
		
		pipe_init(tbl[i],tbl)
	end
	
	return tbl
end

function pipe_init(p,tbl)
	local x=x_min+rnd(x_range)
	local gap=gap_min+rnd(gap_range)
	
	local y=rnd(y_range-gap)+y_min
	
	-- find rightmost pipe
	if #tbl>0 then
		local xmax=0
		for o in all(tbl) do
			xmax=max(xmax,o.x)
		end
		x+=xmax
	end
	
	p.x=x
	p.y=y
	p.gap=gap
end

function pipes_update(tbl)
	for p in all(tbl) do
		p.x+=p_spd
	
		if p.x<=-p_width then
			pipe_init(p,tbl)
			score+=1
		end
	end
end

function pipes_draw(tbl)
	for p in all(tbl) do
		rectfill(
			p.x,
			0,
			p.x+p_width,
			p.y,
			3
		)
		
		rectfill(
			p.x,
			p.y+p.gap,
			p.x+p_width,
			127,
			3
		)
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
