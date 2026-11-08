// Кровать работает только в комнате героя.
if (room != rm_home) exit;

// Ждём окончания заставки дня или диалога.
if (!variable_global_exists("input_locked")) exit;
if (global.input_locked) exit;

// Клик через открытую панель не должен нажимать на кровать.
var ui = instance_find(obj_ui, 0);

if (ui != noone)
{
    if (ui.panel != "none") exit;
}

// Нужен новый клик левой кнопкой мыши.
if (!mouse_check_button_pressed(mb_left)) exit;

// Проверяем, кликнула ли ты по области кровати.
if (!point_in_rectangle(
    mouse_x, mouse_y,
    bbox_left, bbox_top,
    bbox_right, bbox_bottom
))
{
    exit;
}

// Для каждого дня есть две отметки о завершённых разговорах.
var first_npc = (global.day - 1) * 2;
var second_npc = first_npc + 1;

// Кровать сработает только после обоих разговоров.
if (!global.npc_done[first_npc] || !global.npc_done[second_npc])
{
    exit;
}

// Проверку финала после 14-го дня подключим отдельно.
if (global.day >= 14) exit;

// Начинаем следующий день и сбрасываем дневной лимит магазина.
global.day += 1;
global.food_bought_today = 0;

// Снимаем здоровье и ментальное здоровье в начале дня.
var mp_loss = 5;

if (global.mp < 50)
{
    mp_loss = 10;
}

global.hp = max(0, global.hp - 10);
global.mp = max(0, global.mp - mp_loss);

// Показываем заставку нового дня в той же комнате.
global.day_intro_pending = true;
global.input_locked = true;

instance_create_depth(0, 0, -10000, obj_day_intro);