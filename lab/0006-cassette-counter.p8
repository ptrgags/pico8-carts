pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- cassette counter
-- by peter gagliardi (@ptrgags)

-- inspired by a mix of:
-- - number lab by dave makes
--   https://www.lexaloffle.com/bbs/?pid=194143
-- - my rew/ffwd album cover
--   https://ptrgags.dev/#/album/rewind-and-ffwd

function _init()
	tape=make_tape()
	trans=make_transp()
end

function _update()
	update_transp(trans)
	
	tape.speed=trans.spd
	update_tape(tape)
end

function _draw()
 cls(4)
 draw_transp(trans)
 draw_tape(tape)
end

-->8
-- transport
function make_transp()
 local spd_slow=1
 local spd_fast=15
	return {
	 sel=3,
	 speeds={
	 	-spd_fast,
	 	-spd_slow,
	 	0,
	 	spd_slow,
	 	spd_fast
	 },
	 cur=3,
	 spd=0,
	 x=8
	}
end

function get_speed(transp)
	return transp.speeds[transp.sel]
end

function update_transp(transp)
	if (btnp(⬅️)) transp.cur-=1
	if (btnp(➡️)) transp.cur+=1
	transp.cur=mid(transp.cur,1,5)
	
	if btnp(❎) then
		transp.sel=transp.cur
	end
	
	transp.spd=transp.speeds[transp.sel]
end

function draw_transp(transp)
 -- cursor
	spr(7,transp.x+transp.cur*16+4,0)

	for i=1,5 do
	 -- spr 16 is the button
	 --  (not pressed)
	 -- spr 18 is the button
	 --  (pressed)
	 local idx=sel(16,18,i==transp.sel)
		spr(idx,transp.x+i*16,8,2,2)
		
		local ico=1+i
		local y_o=sel(-2,2,i==transp.sel)
		spr(ico,transp.x+i*16+4,8+4+y_o)
	end
end
-->8
-- util

-- i find the and/or idiom
-- confusing, so let's make
-- a select function. this is
-- like select() in wgsl
-- see https://www.w3.org/tr/wgsl/#select-builtin
function sel(a,b,x)
 return x and b or a
end
-->8
--reels of tape

count_max=1023
min_r=12
max_r=32

reel_l={x=32,y=64}
reel_r={x=96,y=64}

r_guide=4
s_guide=2

function make_tape()
	return {
		counter=0,
		r_left=max_r,
		r_right=min_r,
		percent=0,
	}
end

-- update the tape
-- important: make sure
-- to update tape.speed
-- beforehand
function update_tape(tape)
	tape.counter+=tape.speed
	tape.counter=mid(
		tape.counter,0,count_max)
		
	local p=tape.counter/count_max
	local q=1-p
	
	tape.percent=p
	tape.r_left=min_r+q*(max_r-min_r)
	tape.r_right=min_r+p*(max_r-min_r)
end

function draw_tape(tape)
	local p=tape.percent
	local rl=tape.r_left
	local rr=tape.r_right
	
	--tape speed 
	local guide_spd=tape.speed*2
	local reel_spd=tape.speed*8.5
	
	--reels of tape
	circfill(
		reel_l.x,reel_l.y,rl,5)
	circfill(
		reel_r.x,reel_r.y,rr,5)

 --line of tape between reels
 --(approx)
 line(32-rl,64,0,128-2*r_guide,5)
 line(95+rr,64,127,128-2*r_guide,5)
 line(r_guide,127-r_guide,128-r_guide,127-r_guide,5)

	--decorate center of reels
	circfill(32,64,min_r,0)
	circfill(96,64,min_r,0)
	for i=0,6 do
	 local angle=i/6
	 line(
	 	32+0.5*min_r*cos(reel_spd*p+angle),
	 	64+0.5*min_r*sin(reel_spd*p+angle),
	 	32+0.9*min_r*cos(reel_spd*p+angle),
	 	64+0.9*min_r*sin(reel_spd*p+angle),
	 	7
	 )
	 line(
	 	96+0.5*min_r*cos(reel_spd*p+angle),
	 	64+0.5*min_r*sin(reel_spd*p+angle),
	 	96+0.9*min_r*cos(reel_spd*p+angle),
	 	64+0.9*min_r*sin(reel_spd*p+angle),
	 	7
	 )
	end
	circ(reel_l.x,reel_l.y,min_r,7)
	circ(reel_r.x,reel_r.y,min_r,7)

 --tape guides
 spr(1,0,128-3*r_guide)
 spr(1,128-2*r_guide,128-3*r_guide)
 
 line(
 	r_guide,
 	128-2*r_guide,
 	r_guide+s_guide*cos(guide_spd*p),
 	128-2*r_guide+s_guide*sin(guide_spd*p),
 	1
 )
 line(
 	128-r_guide,
 	128-2*r_guide,
 	128-r_guide+s_guide*cos(guide_spd*p+0.25),
 	128-2*r_guide+s_guide*sin(guide_spd*p+0.25),
 	1
 )
end
__gfx__
00000000007777000000000000000cc0000000000cc0000000000000000ee0000000000000000000000000000000000000000000000000000000000000000000
0000000007dddd70000c00c0000cccc00cc00cc00cccc0000c00c000000ee0000000000000000000000000000000000000000000000000000000000000000000
007007007dddddd700cc0cc00cccccc00cc00cc00cccccc00cc0cc00000ee0000000000000000000000000000000000000000000000000000000000000000000
000770007dd55dd70cccccc0ccccccc00cc00cc00ccccccc0cccccc0000ee0000000000000000000000000000000000000000000000000000000000000000000
000770007dd55dd7ccccccc0ccccccc00cc00cc00ccccccc0ccccccceeeeeeee0000000000000000000000000000000000000000000000000000000000000000
007007007dddddd70cccccc00cccccc00cc00cc00cccccc00cccccc00eeeeee00000000000000000000000000000000000000000000000000000000000000000
0000000007dddd7000cc0cc0000cccc00cc00cc00cccc0000cc0cc0000eeee000000000000000000000000000000000000000000000000000000000000000000
0000000000777700000c00c000000cc0000000000cc000000c00c000000ee0000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d66666666666666d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d66666666666666d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d66666666666666ddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d66666666666666ddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d66666666666666dd66666666666666d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d66666666666666dd66666666666666d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d66666666666666dd66666666666666d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d66666666666666dd66666666666666d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d66666666666666dd66666666666666d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d66666666666666dd66666666666666d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddddddddddd66666666666666d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddddddddddd66666666666666d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddddddddddd66666666666666d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddddddddddd66666666666666d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
