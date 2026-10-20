function scr_new_game()
{
    // Останавливаем музыку главного меню.
    audio_stop_sound(snd_menu);

    // Начинаем первый день.
    global.day = 1;

    // Начальные показатели без списания за первый день.
    global.hp = 70;
    global.mp = 80;

    // Услуги оплатим позже, во время диалога.
    global.money = 550;

    // Сегодня еда ещё не покупалась.
    global.food_bought_today = 0;

    // Счётчик круток после последней легендарки.
    global.pulls_since_legendary = 0;

    // Коллекция пока пустая.
    global.collection = array_create(14, false);

    // Прогресс заданий условного NPC.
    global.underwear_jobs_completed = 0;
    global.photo_job_completed = false;
    global.video_job_completed = false;

    // Завершённых встреч пока нет.
    global.npc_done = array_create(28, false);

    // Запрашиваем вступление дня.
    global.day_intro_pending = true;

    // Блокируем управление на время вступления.
    global.input_locked = true;

    // Переходим в комнату героя.
    room_goto(rm_home);
}