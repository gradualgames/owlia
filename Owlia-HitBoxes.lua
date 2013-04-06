-- Owlia hitbox script
-- Written by Derek Andrews <derek.george.andrews@gmail.com>
-- 11-11-12

-- This script shows locations of various hit boxes in Owlia, used
-- for tweaking/tightening gameplay.

local running = true;
local restrainingorder = false;
local myoutput;

-- draw a box and take care of coordinate checking
local function box(x1,y1,x2,y2,color)
    y1 = y1 + 16;
    y2 = y2 + 16;
    -- gui.text(50,50,x1..","..y1.." "..x2..","..y2);
    if (x1 >= 0 and x1 <= 255 and x2 >= 0 and x2 <= 255 and y1 >= 0 and y1 < 224 and y2 >= 0 and y2 < 224) then
        --gui.drawbox(x1,y1,x2,y2,color);
        gui.drawline(x1,y1,x2,y1,color);
        gui.drawline(x2,y1,x2,y2,color);
        gui.drawline(x1,y2,x2,y2,color);
        gui.drawline(x1,y1,x1,y2,color);
    end;
end;

local function rect_in_rect_executed()

--rectangle A:
--w2 - left x
--w3 - top y
--b2 - width
--b3 - height
--rectangle B:
--w4 - left x
--w5 - top y
--b4 - width
--b5 - height
--global variables used:
--rectangle A:
--w6 - right x
--w7 - bottom y
--rectangle B:
--w8 - right x
--w9 - bottom y

    ah,bh = memory.readbyte(w2+1), memory.readbyte(w3+1)
    if (ah == 0 and bh == 0) then
        a,b = memory.readbyte(w2),memory.readbyte(w3)
        c,d = memory.readbyte(b2),memory.readbyte(b3)
        box(a,b,a+c,b+d,"red");
    end;

    ah,bh = memory.readbyte(w4+1), memory.readbyte(w5+1)
    if (ah == 0 and bh == 0) then
        a,b = memory.readbyte(w4),memory.readbyte(w5)
        c,d = memory.readbyte(b4),memory.readbyte(b5)
        box(a,b,a+c,b+d,"red");
    end;
    
end;

local function draw_attack_rect()

    camera_x16 = memory.readbyte(camera_x+1) * 256 + memory.readbyte(camera_x);
    camera_y16 = memory.readbyte(camera_y+1) * 256 + memory.readbyte(camera_y);
    
    hero_attack_rect_x16 = memory.readbyte(hero_attack_rect_x+1) * 256 + memory.readbyte(hero_attack_rect_x);
    hero_attack_rect_y16 = memory.readbyte(hero_attack_rect_y+1) * 256 + memory.readbyte(hero_attack_rect_y);
    
    screen_x = hero_attack_rect_x16 - camera_x16;
    screen_y = hero_attack_rect_y16 - camera_y16;
    
    hero_attack_rect_width_value = memory.readbyte(hero_attack_rect_width);
    hero_attack_rect_height_value = memory.readbyte(hero_attack_rect_height);
    
    box(screen_x, screen_y, screen_x+hero_attack_rect_width_value, screen_y+hero_attack_rect_height_value, "green");

--    ah,bh = memory.readbyte(hero_attack_rect_x+1),memory.readbyte(hero_attack_rect_y+1);
--    if (ah == 0 and bh == 0) then
--        a,b = memory.readbyte(hero_attack_rect_x),memory.readbyte(hero_attack_rect_y);
--        c,d = a+memory.readbyte(hero_attack_rect_width),b+memory.readbyte(hero_attack_rect_height);
--        box(a,b,c,d, "green");
--    end;

end;

b2 = 0x0002
b3 = 0x0003
w2 = 0x0010
w3 = 0x0012
b4 = 0x0004
b5 = 0x0005
w4 = 0x0014
w5 = 0x0016

camera_x = 0x0474
camera_y = 0x0476

hero_attack_rect_x = 0x0438
hero_attack_rect_y = 0x043A
hero_attack_rect_width = 0x043C
hero_attack_rect_height = 0x043D

geotests_rect_in_rect_16bit = 0xD819

memory.registerexecute(geotests_rect_in_rect_16bit, 110, rect_in_rect_executed)

local a,b,c,d;
while (running) do

    --draw_attack_rect()

    FCEU.frameadvance()
end

gui.popup("script exited main loop");

