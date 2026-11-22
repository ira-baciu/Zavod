// Рисуем самого NPC.
draw_self();

if (global.input_locked) exit;

var ui = instance_find(obj_ui, 0);

if (ui != noone)
{
    if (ui.panel != "none") exit;
}

var hero = instance_find(obj_player, 0);

if (hero == noone) exit;

if (abs(hero.x - x) > 40) exit;

if (instance_nearest(
    hero.x,
    hero.y,
    obj_npc_day1
) != id) exit;

// Подсказка появляется только около ближайшего NPC.
draw_set_font(fnt_pixel);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

draw_text_transformed(
    x,
    bbox_top - 5,
    "Press F to talk",
    1,
    1,
    0
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
