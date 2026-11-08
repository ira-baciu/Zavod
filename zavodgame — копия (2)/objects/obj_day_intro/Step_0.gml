//Название дня.
if (intro_stage == 0)
{
    // delta_time — время между кадрами в микросекундах.
    // Делим на миллион, чтобы получить секунды.
    banner_time -= delta_time / 1000000;

    if (banner_time <= 0)
    {
        if (global.day == 1)
        {
            // В первый день переходим к сообщению о зарплате.
            intro_stage = 1;
        }
        else
        {
            // В другие дни после надписи разрешаем играть.
            global.input_locked = false;
            instance_destroy();
        }
    }
}
else
{
    // Листаем нажатием мыши, пробела или Enter.
    var advance = mouse_check_button_pressed(mb_left)
        || keyboard_check_pressed(vk_space)
        || keyboard_check_pressed(vk_enter);

    if (advance)
    {
        if (intro_stage == 1)
        {
            // Показываем сообщение об услугах.
            // Деньги пока остаются на счёте.
            intro_stage = 2;
        }
        else if (intro_stage == 2)
        {
            // Списываем деньги только после этой реплики.
            global.money -= 40;
            intro_stage = 3;
        }
        else if (intro_stage == 3)
        {
            // Вступление закончено.
            global.input_locked = false;
            instance_destroy();
        }
    }
}