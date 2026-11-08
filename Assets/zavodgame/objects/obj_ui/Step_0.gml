// Уменьшаем время показа временного сообщения.
if (notice_time > 0)
{
    notice_time = max(0, notice_time - delta_time / 1000000);
}

// Во время вступления кнопки интерфейса недоступны.
if (variable_global_exists("input_locked"))
{
    if (global.input_locked)
    {
        slider_dragging = false;
        exit;
    }
}

// Координаты мыши в системе интерфейса.
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Новое нажатие левой кнопки мыши.
var clicked = mouse_check_button_pressed(mb_left);

// Правила закрываются любым нажатием.
if (panel == "rules")
{
    if (clicked)
    {
        panel = rules_return;
    }
}
// Настройки.
else if (panel == "settings")
{
    if (clicked)
    {
        // Проверяем дорожку громкости.
        if (point_in_rectangle(
            mx, my,
            slider_left - slider_handle_w / 2,
            slider_y - slider_handle_h / 2,
            slider_right + slider_handle_w / 2,
            slider_y + slider_handle_h / 2
        ))
        {
            slider_dragging = true;
        }
        else
        {
            // Проверяем кнопки настроек.
            for (var i = 0; i < 3; i++)
            {
                if (point_in_rectangle(
                    mx, my,
                    settings_button_x,
                    settings_button_ys[i],
                    settings_button_x + settings_button_w,
                    settings_button_ys[i] + settings_button_h
                ))
                {
                    // Restart.
                    if (i == 0)
                    {
                        panel = "none";
                        slider_dragging = false;
                        scr_new_game();
                        exit;
                    }

                    // Rules.
                    if (i == 1)
                    {
                        rules_return = "settings";
                        panel = "rules";
                    }

                    // Menu.
                    if (i == 2)
                    {
                        panel = "none";
                        slider_dragging = false;

                        if (room != rm_menu)
                        {
                            room_goto(rm_menu);
                            exit;
                        }
                    }

                    break;
                }
            }

            // Закрываем настройки нажатием вне панели.
            if (panel == "settings")
            {
                if (!point_in_rectangle(
                    mx, my,
                    settings_x, settings_y_top,
                    settings_x + settings_w,
                    settings_y_top + settings_h
                ))
                {
                    panel = "none";
                    slider_dragging = false;
                }
            }
        }
    }

    // Перетаскивание ползунка.
    if (slider_dragging)
    {
        if (mouse_check_button(mb_left))
        {
            global.volume = clamp(
                (mx - slider_left) / (slider_right - slider_left),
                0,
                1
            );

            audio_master_gain(global.volume);
        }
        else
        {
            slider_dragging = false;
        }
    }
}
// Магазин.
else if (panel == "store")
{
    if (clicked)
    {
        // Нажатие вне панели закрывает магазин.
        if (!point_in_rectangle(
            mx, my,
            store_x, store_y,
            store_x + store_w,
            store_y + store_h
        ))
        {
            panel = "none";
            notice_time = 0;
        }
        else
        {
            // Проверяем три строки товаров.
            for (var i = 0; i < 3; i++)
            {
                if (point_in_rectangle(
                    mx, my,
food_row_x, food_row_ys[i],
                    food_row_x + food_row_w,
                    food_row_ys[i] + food_row_h
                ))
                {
                    // Лимит общий для всех блюд.
                    if (global.food_bought_today >= 3)
                    {
                        notice = "Daily purchase limit reached.";
                    }
                    else if (global.money < food_prices[i])
                    {
                        notice = "Not enough money.";
                    }
                    else
                    {
                        // Оплачиваем еду.
                        global.money -= food_prices[i];

                        // Восстанавливаем HP, максимум до 100.
                        global.hp = min(
                            100,
                            global.hp + food_healing[i]
                        );

                        // Учитываем покупку.
                        global.food_bought_today += 1;

                        notice = "Food purchased.";
                    }

                    // Сообщение видно две секунды.
                    notice_time = 2;
                    break;
                }
            }
        }
    }
}
// Главное меню, когда панели закрыты.
else if (room == rm_menu)
{
    if (clicked)
    {
        if (point_in_rectangle(
            mx, my,
            button_x, start_y,
            button_x + sprite_get_width(spr_menu_start),
            start_y + sprite_get_height(spr_menu_start)
        ))
        {
            scr_new_game();
            exit;
        }
        else if (point_in_rectangle(
            mx, my,
            button_x, rules_y,
            button_x + sprite_get_width(spr_menu_rules),
            rules_y + sprite_get_height(spr_menu_rules)
        ))
        {
            rules_return = "none";
            panel = "rules";
        }
        else if (point_in_rectangle(
            mx, my,
            button_x, settings_y,
            button_x + sprite_get_width(spr_menu_settings),
            settings_y + sprite_get_height(spr_menu_settings)
        ))
        {
            slider_dragging = false;
            panel = "settings";
        }
    }
}
// Значки в комнате героя.
else if (room == rm_home||  room == rm_street || room == rm_gacha)
{
    if (clicked)
    {
        // Значок настроек.
        if (point_in_rectangle(
            mx, my,
            settings_icon_x, icons_y,
            settings_icon_x + icon_size,
            icons_y + icon_size
        ))
        {
            slider_dragging = false;
            panel = "settings";
        }
        // Значок магазина.
        else if (point_in_rectangle(
            mx, my,
            store_icon_x, icons_y,
            store_icon_x + icon_size,
            icons_y + icon_size
        ))
        {
            notice_time = 0;
            panel = "store";
        }
    }
}