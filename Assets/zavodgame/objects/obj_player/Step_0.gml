// Блокируем управление во время заставки или диалога.
if (variable_global_exists("input_locked"))
{
    if (global.input_locked) exit;
}

// Блокируем управление, пока открыта панель.
var ui = instance_find(obj_ui, 0);
if (ui != noone)
{
    if (ui.panel != "none") exit;
}

// Дома герой стоит на месте. D или стрелка вправо — выход.
if (room == rm_home)
{
    if (keyboard_check_pressed(ord("D")) ||
        keyboard_check_pressed(vk_right))
    {
        room_goto(rm_street);
    }

    exit;
}

// В комнате гачи G возвращает на улицу.
if (room == rm_gacha)
{
    if (keyboard_check_pressed(ord("G")))
    {
        if (variable_global_exists("gacha_return_x"))
        {
            global.street_spawn_x = global.gacha_return_x;
        }

        room_goto(rm_street);
    }

    exit;
}

// Ходьба работает только на улице.
if (room != rm_street) exit;

var go_left = keyboard_check(ord("A")) || keyboard_check(vk_left);
var go_right = keyboard_check(ord("D")) || keyboard_check(vk_right);
var direction_x = go_right - go_left;

var edge = ceil(sprite_get_width(spr_hero_64) / 2);

x = clamp(
    x + direction_x * walk_speed,
    edge,
    room_width - edge
);

if (direction_x != 0)
{
    image_xscale = direction_x;
}

// У левого края улицы возвращаемся домой.
if (direction_x < 0 && x <= edge)
{
    room_goto(rm_home);
}