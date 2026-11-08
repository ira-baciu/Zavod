// Скорость ходьбы на улице: 2 пикселя за шаг игры.
walk_speed = 2;

// По умолчанию герой виден.
visible = true;

if (room == rm_home)
{
    // Большой герой для комнаты.
    sprite_index = spr_hero_128;
}
else if (room == rm_street)
{
    // Маленький герой для улицы.
    sprite_index = spr_hero_64;

    // Если возвращаемся от автомата, восстанавливаем позицию.
    if (variable_global_exists("street_spawn_x"))
    {
        if (global.street_spawn_x >= 0)
        {
            x = global.street_spawn_x;

            // Используем сохранённую позицию только один раз.
            global.street_spawn_x = -1;
        }
    }
}
else if (room == rm_gacha)
{
    // У автомата игрок видит экран гачи, а не героя.
    visible = false;
}