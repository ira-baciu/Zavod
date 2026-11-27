function scr_new_game()
{
    // Инициализируем случайность один раз за запуск приложения.
    if (!variable_global_exists("gacha_random_ready"))
    {
        randomise();
        global.gacha_random_ready = true;
    }

    zv_boot();
    global.zv_flags={}; global.zv_jobs={}; global.zv_done={}; global.zv_outros={};
    global.zv_outfit=""; global.zv_ending=false;
    zv_extras_reset();zv_onboarding_reset();
    global.day = 1;
    global.hp = 70;
    global.mp = 80;

    // Услуги оплачиваются позже во вступительном диалоге.
    global.money = 500;

    global.food_bought_today = 0;

    // Каталог и пустая коллекция.
    global.gacha_catalog = scr_gacha_catalog();
    global.collection = array_create(14, false);

    // Счётчики гачи.
    global.total_pulls = 0;
    global.pulls_since_legendary = 0;

    // Прогресс заданий.
    global.underwear_jobs_completed = 0;
    global.photo_job_completed = false;
    global.video_job_completed = false;

    global.npc_done = array_create(28, false);

    // Сбрасываем точки возврата.
    global.street_spawn_x = -1;
    global.gacha_return_x = 48;

    // Начинаем вступление первого дня.
    global.day_intro_pending = true;
    global.input_locked = true;

    room_goto(rm_home);
}
