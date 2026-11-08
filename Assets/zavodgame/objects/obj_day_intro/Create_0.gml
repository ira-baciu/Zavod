// Проверяем, было ли запрошено вступление.
if (!variable_global_exists("day_intro_pending"))
{
    instance_destroy();
    exit;
}

// При обычном возвращении в комнату вступление не повторяем.
if (!global.day_intro_pending)
{
    instance_destroy();
    exit;
}

// Запрос вступления принят.
global.day_intro_pending = false;
global.input_locked = true;

// Названия дней, которые видит игрок.
day_titles = [
    "Day 1",
    "Day 2",
    "Day 3",
    "Day 4",
    "Day 5",
    "Day 6",
    "Day 7",
    "Day 8",
    "Day 9",
    "Day 10",
    "Day 11",
    "Day 12",
    "Day 13",
    "Day 14"
];

// Получаем название текущего дня.
day_title = day_titles[global.day - 1];

// Этап 0 — название дня.
// Этапы 1, 2, 3 — вступительные реплики.
intro_stage = 0;

// Продолжительность показа названия дня в секундах.
banner_time = 1.5;