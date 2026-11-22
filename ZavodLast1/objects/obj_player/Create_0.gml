walk_voice=-1;
// Скорость ходьбы по улице.
walk_speed = 2;

// Последнее направление взгляда:
// 1 — вправо, -1 — влево.
facing = 1;

// Используем отдельные рисунки сторон, без зеркалирования.
image_xscale = 1;

// Проигрываем анимацию со скоростью,
// которую ты указала в редакторе спрайта.
image_speed = 1;
image_index = 0;

// По умолчанию герой виден.
visible = true;

if (room == rm_home)
{
    // В комнате герой стоит и проигрывает свою анимацию.
    sprite_index = spr_hero_128_idle;
}
else if (room == rm_street)
{
    // При появлении на улице герой смотрит вправо.
    sprite_index = spr_hero_64_idle_right;

    // Возвращаем героя в сохранённую точку после гачи.
    if (variable_global_exists("street_spawn_x"))
    {
        if (global.street_spawn_x >= 0)
        {
            x = global.street_spawn_x;

            // Сохранённую точку используем один раз.
            global.street_spawn_x = -1;
        }
    }
}
else if (room == rm_gacha)
{
    // В комнате автомата герой не отображается.
    visible = false;
}
