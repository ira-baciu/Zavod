if (room != rm_street) exit;

// Одно нажатие G.
if (!keyboard_check_pressed(ord("G"))) exit;

// Не открываем автомат во время диалога или заставки.
if (variable_global_exists("input_locked"))
{
    if (global.input_locked) exit;
}

// Не открываем автомат поверх магазина или настроек.
var ui = instance_find(obj_ui, 0);
if (ui != noone)
{
    if (ui.panel != "none") exit;
}

// Находим героя.
var hero = instance_find(obj_player, 0);
if (hero == noone) exit;

// Герой ходит по одной линии, поэтому проверяем расстояние по X.
// Даём 12 пикселей запаса с каждой стороны автомата.
if (hero.x < bbox_left - 12 || hero.x > bbox_right + 12) exit;

// Запоминаем, куда вернуть героя после выхода из гачи.
global.gacha_return_x = hero.x;
room_goto(rm_gacha);