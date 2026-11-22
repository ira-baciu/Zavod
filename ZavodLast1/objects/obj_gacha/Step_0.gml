if (room != rm_gacha) exit;

// Если результат или сообщение уже открыты.
if (screen_state != "idle")
{
    result_time += delta_time / 1000000;

    // Закрываем через Space после небольшой задержки.
    if (result_time >= 0.3 &&
        keyboard_check_pressed(vk_space))
    {
        screen_state = "idle";
        global.input_locked = false;
    }

    exit;
}

// Не покупаем крутку одновременно с выходом из гачи.
if (keyboard_check_pressed(ord("G"))) exit;

// Ждём окончания других диалогов.
if (global.input_locked) exit;

// Не покупаем крутку при открытой панели.
var ui = instance_find(obj_ui, 0);

if (ui != noone)
{
    if (ui.panel != "none") exit;
}

// Одна крутка на новое нажатие E.
if (!keyboard_check_pressed(ord("E"))) exit;

// При нехватке денег покупка не происходит.
if (global.money < 20)
{
    screen_state = "error";
    result_time = 0;
    global.input_locked = true;
    exit;
}

// Следующая крутка после последней легендарки.
var pull_number = global.pulls_since_legendary + 1;

// Выбираем предмет.
var reward = scr_gacha_roll(pull_number);

result_id = reward.item_id;
result_rarity = reward.rarity;

// Проверяем, был ли он получен раньше.
result_duplicate = global.collection[result_id];

// Оплачиваем крутку.
zv_money(-20,true);
zv_sfx(snd_pull_gacha);

// Восстанавливаем моральные пункты, максимум до 100.
var previous_mp = global.mp;
global.mp = min(100, global.mp + 3);

// Запоминаем реальную прибавку с учётом максимума.
result_mp_gain = global.mp - previous_mp;

// Предмет теперь получен.
// Повторная запись true не добавляет новую копию.
global.collection[result_id] = true;

global.total_pulls += 1;

// Любая легендарка сбрасывает гарант.
if (result_rarity == "Legendary")
{
    global.pulls_since_legendary = 0;
}
else
{
    global.pulls_since_legendary = pull_number;
}

zv_ach_check();
// Показываем результат.
screen_state = "result";
result_time = 0;

// Блокируем уход и другие действия до закрытия результата.
global.input_locked = true;
