-- Owlia hitbox script
-- Written by Derek Andrews <derek.george.andrews@gmail.com>
-- 11-11-12

-- This script shows locations of various hit boxes in Owlia, used
-- for tweaking/tightening gameplay.

local running = true;
local restrainingorder = false;
local myoutput;

b2 = 0x0002
b3 = 0x0003
w2 = 0x0010
w3 = 0x0012
b4 = 0x0004
b5 = 0x0005
w4 = 0x0014
w5 = 0x0016
w6 = 0x0018
w7 = 0x001a
w8 = 0x001c
w9 = 0x001e

camera_x = 0x05e7
camera_y = 0x05e9

entity_action_rect1_x = 0x05a9
entity_action_rect1_y = 0x05ab
entity_action_rect1_width = 0x05ad
entity_action_rect1_height = 0x05ae

geotests_rect_in_rect = 0xdef5

-- draw a box and take care of coordinate checking
local function box(x1,y1,x2,y2,color)
    y1 = y1 + 16;
    y2 = y2 + 16;

    if (x1 > 255) then
        return;
    end;

    if (x2 < 0) then
        return;
    end;

    if (y2 < 0) then
        return;
    end;

    if (y1 > 239) then
        return;
    end;

    if (x1 < 0) then
        x1 = 0
    end;

    if (x2 > 255) then
        x2 = 255
    end;

    if (y1 < 0) then
        y1 = 0
    end;

    if (y2 > 239) then
        y2 = 239
    end;

    gui.drawline(x1,y1,x2,y1,color);
    gui.drawline(x2,y1,x2,y2,color);
    gui.drawline(x1,y2,x2,y2,color);
    gui.drawline(x1,y1,x1,y2,color);
end;

-- local function draw_attack_rect()

    -- camera_x16 = memory.readbyte(camera_x+1) * 256 + memory.readbyte(camera_x);
    -- camera_y16 = memory.readbyte(camera_y+1) * 256 + memory.readbyte(camera_y);

    -- entity_action_rect1_x16 = memory.readbyte(entity_action_rect1_x+1) * 256 + memory.readbyte(entity_action_rect1_x);
    -- entity_action_rect1_y16 = memory.readbyte(entity_action_rect1_y+1) * 256 + memory.readbyte(entity_action_rect1_y);

    -- screen_x = entity_action_rect1_x16 - camera_x16;
    -- screen_y = entity_action_rect1_y16 - camera_y16;

    -- entity_action_rect1_width_value = memory.readbyte(entity_action_rect1_width);
    -- entity_action_rect1_height_value = memory.readbyte(entity_action_rect1_height);

    -- box(screen_x, screen_y, screen_x+entity_action_rect1_width_value, screen_y+entity_action_rect1_height_value, "green");

-- end;

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

    camera_x16 = memory.readbyte(camera_x+1) * 256 + memory.readbyte(camera_x);
    camera_y16 = memory.readbyte(camera_y+1) * 256 + memory.readbyte(camera_y);

    rect1_x16_left = memory.readbyte(w2+1) * 256 + memory.readbyte(w2) - camera_x16;
    rect1_y16_top = memory.readbyte(w3+1) * 256 + memory.readbyte(w3) - camera_y16;
    rect1_x16_right = memory.readbyte(w6+1) * 256 + memory.readbyte(w6) - camera_x16;
    rect1_y16_bottom = memory.readbyte(w7+1) * 256 + memory.readbyte(w7) - camera_y16;

    box(rect1_x16_left, rect1_y16_top, rect1_x16_right, rect1_y16_bottom, "red")

    rect2_x16_left = memory.readbyte(w4+1) * 256 + memory.readbyte(w4) - camera_x16;
    rect2_y16_top = memory.readbyte(w5+1) * 256 + memory.readbyte(w5) - camera_y16;
    rect2_x16_right = memory.readbyte(w8+1) * 256 + memory.readbyte(w8) - camera_x16;
    rect2_y16_bottom = memory.readbyte(w9+1) * 256 + memory.readbyte(w9) - camera_y16;

    box(rect2_x16_left, rect2_y16_top, rect2_x16_right, rect2_y16_bottom, "red")

end;

memory.registerexecute(geotests_rect_in_rect, 59, rect_in_rect_executed)

local a,b,c,d;
while (running) do

    FCEU.frameadvance()

end

gui.popup("script exited main loop");
