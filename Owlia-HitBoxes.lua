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

camera_x = 0x0617
camera_y = 0x0619

entity_action_rect1_x = 0x05d9
entity_action_rect1_y = 0x05db
entity_action_rect1_width = 0x05dd
entity_action_rect1_height = 0x05de

geotests_rect_in_rect = 0xd98e
geotests_rect_inside_rect = 0xd921

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

local function rect_in_rect_executed()

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

local function rect_inside_rect_executed()

    camera_x16 = memory.readbyte(camera_x+1) * 256 + memory.readbyte(camera_x);
    camera_y16 = memory.readbyte(camera_y+1) * 256 + memory.readbyte(camera_y);

    rect1_x16_left = memory.readbyte(w2+1) * 256 + memory.readbyte(w2) - camera_x16;
    rect1_y16_top = memory.readbyte(w3+1) * 256 + memory.readbyte(w3) - camera_y16;
    rect1_x16_right = memory.readbyte(w6+1) * 256 + memory.readbyte(w6) - camera_x16;
    rect1_y16_bottom = memory.readbyte(w7+1) * 256 + memory.readbyte(w7) - camera_y16;

    box(rect1_x16_left, rect1_y16_top, rect1_x16_right, rect1_y16_bottom, "blue")

    rect2_x16_left = memory.readbyte(w4+1) * 256 + memory.readbyte(w4) - camera_x16;
    rect2_y16_top = memory.readbyte(w5+1) * 256 + memory.readbyte(w5) - camera_y16;
    rect2_x16_right = memory.readbyte(w8+1) * 256 + memory.readbyte(w8) - camera_x16;
    rect2_y16_bottom = memory.readbyte(w9+1) * 256 + memory.readbyte(w9) - camera_y16;

    box(rect2_x16_left, rect2_y16_top, rect2_x16_right, rect2_y16_bottom, "blue")

end;

memory.registerexecute(geotests_rect_in_rect, 1, rect_in_rect_executed)
memory.registerexecute(geotests_rect_inside_rect, 1, rect_inside_rect_executed)

local a,b,c,d;
while (running) do

    FCEU.frameadvance()

end

gui.popup("script exited main loop");
