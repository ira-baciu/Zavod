if (room != rm_street) exit;

// Во время другого разговора взаимодействовать нельзя.
if (global.input_locked) exit;

if (instance_exists(obj_day1_dialogue)) exit;

// Не начинаем разговор поверх настроек или магазина.
var ui = instance_find(obj_ui, 0);

if (ui != noone)
{
    if (ui.panel != "none") exit;
}

var hero = instance_find(obj_player, 0);

if (hero == noone) exit;

// Из двух NPC выбираем того, кто ближе к герою.
var nearest_npc = instance_nearest(
    hero.x,
    hero.y,
    obj_npc_day1
);

if (nearest_npc != id) exit;

// Разговор доступен на расстоянии до 40 пикселей по горизонтали.
if (abs(hero.x - x) > 40) exit;

if (!keyboard_check_pressed(ord("F"))) exit;

// Пока герой разговаривает, показываем анимацию стояния.
if (hero.facing < 0)
{
    hero.sprite_index = spr_hero_64_idle_left;
}
else
{
    hero.sprite_index = spr_hero_64_idle_right;
}

hero.image_index = 0;

// Создаём окно разговора поверх интерфейса.
var dialogue = instance_create_depth(
    0,
    0,
    -10000,
    obj_day1_dialogue
);

// Передаём, кто говорит и с каким экземпляром NPC.
dialogue.begin_dialogue(encounter_id, id);
