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
	counter=0
	count_max=1023
	
	min_r=12
	max_r=32
	
	r_left=max_r
	r_right=min_r
	
	counter=0
	
	spd_stop=0
	spd_slow=1
	spd_fast=32
	speed=spd_slow
	
	r_guide=4
	s_guide=2
end

function _update()
	counter+=speed
	counter=mid(
		counter,0,count_max)
	percent=counter/count_max
	
	r_left=min_r+(1-percent)*(max_r-min_r)
	r_right=min_r+percent*(max_r-min_r)
end

function _draw()
 cls(4)
 
 --reels of tape
	circfill(32,64,r_left,5)
	circfill(96,64,r_right,5)

 --line of tape between reels
 --(approx)
 line(32-r_left,64,0,128-2*r_guide,5)
 line(95+r_right,64,127,128-2*r_guide,5)
 line(r_guide,127-r_guide,128-r_guide,127-r_guide,5)

	--decorate center of reels

	circfill(32,64,min_r,0)
	circfill(96,64,min_r,0)
	for i=0,6 do
	 angle=i/6
	 line(
	 	32+0.5*min_r*cos(32*percent+angle),
	 	64+0.5*min_r*sin(32*percent+angle),
	 	32+0.9*min_r*cos(32*percent+angle),
	 	64+0.9*min_r*sin(32*percent+angle),
	 	7
	 )
	 line(
	 	96+0.5*min_r*cos(32*percent+angle),
	 	64+0.5*min_r*sin(32*percent+angle),
	 	96+0.9*min_r*cos(32*percent+angle),
	 	64+0.9*min_r*sin(32*percent+angle),
	 	7
	 )
	end
	circ(32,64,min_r,7)
	circ(96,64,min_r,7)

 --tape guides
 spr(1,0,128-3*r_guide)
 spr(1,128-2*r_guide,128-3*r_guide)
 
 line(
 	r_guide,
 	128-2*r_guide,
 	r_guide+s_guide*cos(64*percent),
 	128-2*r_guide+s_guide*sin(64*percent),
 	1
 )
 line(
 	128-r_guide,
 	128-2*r_guide,
 	128-r_guide+s_guide*cos(64*percent+0.25),
 	128-2*r_guide+s_guide*sin(64*percent+0.25),
 	1
 )
 
 print(counter,0,0,10)
end

__gfx__
00000000007777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007dddd700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007007dddddd70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770007dd55dd70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770007dd55dd70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007007dddddd70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007dddd700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
