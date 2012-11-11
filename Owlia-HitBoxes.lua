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
    y1 = y1 + 8;
    y2 = y2 + 8;
    -- gui.text(50,50,x1..","..y1.." "..x2..","..y2);
    if (x1 > 0 and x1 < 255 and x2 > 0 and x2 < 255 and y1 > 0 and y1 < 224 and y2 > 0 and y2 < 224) then
        --gui.drawbox(x1,y1,x2,y2,color);
        gui.drawline(x1,y1,x2,y1,color);
        gui.drawline(x2,y1,x2,y2,color);
        gui.drawline(x1,y2,x2,y2,color);
        gui.drawline(x1,y1,x1,y2,color);
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

camera_x = 0x0474
camera_y = 0x0476

hero_attack_rect_x = 0x0438
hero_attack_rect_y = 0x043A
hero_attack_rect_width = 0x043C
hero_attack_rect_height = 0x043D

local a,b,c,d;
while (running) do

        draw_attack_rect()

    FCEU.frameadvance()
end

gui.popup("script exited main loop");

