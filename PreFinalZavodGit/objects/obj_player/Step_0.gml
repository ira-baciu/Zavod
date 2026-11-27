zv_sync_input_lock();
// Проверяем, разрешено ли сейчас управление.
var controls_blocked = false;

// Блокировка во время заставки или диалога.
if (variable_global_exists("input_locked"))
{
    if (global.input_locked)
    {
        controls_blocked = true;
    }
}

// Блокировка при открытых настройках, магазине или правилах.
var ui = instance_find(obj_ui, 0);

if (ui != noone)
{
    if (ui.panel != "none")
    {
        controls_blocked = true;
    }
}

// Не зеркалим спрайт: для каждой стороны есть своя анимация.
image_xscale = 1;

// В комнате герой стоит на месте.
if (room == rm_home)
{
    if (controls_blocked) exit;

    // D или правая стрелка выводит на улицу.
    if (keyboard_check_pressed(ord("D")) ||
        keyboard_check_pressed(vk_right))
    {
        room_goto(rm_street);
    }

    exit;
}

// Из комнаты автомата возвращаемся на улицу.
if (room == rm_gacha)
{
    if (controls_blocked) exit;

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

// Дальше обрабатываем только улицу.
if (room != rm_street) exit;

// По умолчанию команды движения нет.
var direction_x = 0;

// Читаем клавиши, только если управление разрешено.
if (!controls_blocked)
{
    var go_left = keyboard_check(ord("A")) ||
                  keyboard_check(vk_left);

    var go_right = keyboard_check(ord("D")) ||
                   keyboard_check(vk_right);

    direction_x = go_right - go_left;
}

// Запоминаем последнее выбранное направление.
if (direction_x != 0)
{
    facing = direction_x;
}

// Запоминаем положение до движения.
var previous_x = x;

// Ограничиваем движение краями улицы.
// Ширина берётся из нового спрайта героя.
var edge = ceil(sprite_get_width(spr_hero_64_idle_right) / 2);

x = clamp(
    x + direction_x * walk_speed,
    edge,
    room_width - edge
);

// У левого края возвращаемся домой.
if (!controls_blocked && direction_x < 0 && x <= edge)
{
    room_goto(rm_home);
    exit;
}

// Проверяем, действительно ли герой переместился.
var is_moving = (x != previous_x);

// Выбираем следующую анимацию.
var next_sprite;

if (is_moving)
{
    if (facing == 1)
    {
        next_sprite = spr_hero_64_walk_right;
    }
    else
    {
        next_sprite = spr_hero_64_walk_left;
    }
}
else
{
    if (facing == 1)
    {
        next_sprite = spr_hero_64_idle_right;
    }
    else
    {
        next_sprite = spr_hero_64_idle_left;
    }
}

// Меняем спрайт только при смене состояния.
if (sprite_index != next_sprite)
{
    sprite_index = next_sprite;

    // Новую анимацию начинаем с первого кадра.
    image_index = 0;
}

if(is_moving) {
    if(walk_voice==-1 || !audio_is_playing(walk_voice)) walk_voice=audio_play_sound(snd_walking,0,true);
} else if(walk_voice!=-1) {audio_stop_sound(walk_voice);walk_voice=-1;}
// Продолжаем проигрывание выбранной анимации.
image_speed = 1;
