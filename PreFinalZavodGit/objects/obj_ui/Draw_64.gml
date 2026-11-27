// Во время чёрного экрана дня интерфейс скрыт.
if (instance_exists(obj_day_intro))
{
    if (obj_day_intro.intro_stage == 0)
    {
        exit;
    }
}

// Обычные параметры отображения.
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(fnt_pixel);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Масштаб чисел.
var number_scale = 0.75;

// Главное меню.
if (room == rm_menu)
{
    draw_sprite_ext(spr_menu_start,0,button_x+sprite_get_xoffset(spr_menu_start)*menu_button_scale,start_y+sprite_get_yoffset(spr_menu_start)*menu_button_scale,menu_button_scale,menu_button_scale,0,c_white,1);
    draw_sprite_ext(spr_menu_rules,0,button_x+sprite_get_xoffset(spr_menu_rules)*menu_button_scale,rules_y+sprite_get_yoffset(spr_menu_rules)*menu_button_scale,menu_button_scale,menu_button_scale,0,c_white,1);
    draw_sprite_ext(spr_menu_settings,0,button_x+sprite_get_xoffset(spr_menu_settings)*menu_button_scale,settings_y+sprite_get_yoffset(spr_menu_settings)*menu_button_scale,menu_button_scale,menu_button_scale,0,c_white,1);
    draw_sprite_ext(spr_menu_achivments,0,button_x+sprite_get_xoffset(spr_menu_achivments)*menu_button_scale,achievements_y+sprite_get_yoffset(spr_menu_achivments)*menu_button_scale,menu_button_scale,menu_button_scale,0,c_white,1);
}
// Показатели в комнате героя.
else if (room == rm_home || room == rm_street || room == rm_gacha)
// Общие размеры всех трёх плашек.
{
	var hud_x = 4;
var hud_y = 7;

var hud_w = 54;   // Ширина каждой плашки.
var hud_h = 18;   // Высота каждой плашки.
var hud_gap = 3;  // Промежуток между плашками.

// Значки.
var hud_icons = [
    spr_money,
    stomach_sprites[status_index(global.hp)],
    brain_sprites[status_index(global.mp)]
];

// Подписи.
var hud_values = [
    "$" + string(round(shown_money)),
    string(round(shown_hp)) + "/100",
    string(round(shown_mp)) + "/100"
];

draw_set_font(fnt_pixel);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

// Рисуем три одинаковые строки.
for (var i = 0; i < 3; i++)
{
    var row_y = hud_y + i * (hud_h + hud_gap);

    // Плашка с учётом её Origin.
    var sx = hud_w / sprite_get_width(spr_under_numbers);
    var sy = hud_h / sprite_get_height(spr_under_numbers);

    draw_sprite_ext(
        spr_under_numbers, 0,
        hud_x + sprite_get_xoffset(spr_under_numbers) * sx,
        row_y + sprite_get_yoffset(spr_under_numbers) * sy,
        sx, sy,
        0, c_white, 1
    );

    // Одинаковая область для иконок.
    // Значок денег немного меньше желудка и мозга.
    var icon_size_hud = (i == 0) ? 14 : 20;

    draw_fit(
        hud_icons[i],
        hud_x + 2 + (20 - icon_size_hud) / 2,
        row_y + (hud_h - icon_size_hud) / 2,
        icon_size_hud,
        icon_size_hud
    );

    // Все числа начинаются на одной вертикальной линии.
    // При необходимости длинное число уменьшается по ширине.
    var text_scale = min(
        0.7,
        (hud_w - 27) / max(1, string_width(hud_values[i]))
    );

    draw_text_transformed(
        hud_x + 25,
        row_y + hud_h / 2,
        hud_values[i],
        text_scale, text_scale,
        0
    );
}

// Возвращаем обычное выравнивание для остального интерфейса.
draw_set_halign(fa_left);
draw_set_valign(fa_top);
    // Значки настроек и магазина.
    draw_fit(
        spr_icon_settings,
        settings_icon_x, icons_y,
        icon_size, icon_size
    );

    draw_fit(
        spr_icon_store,
        store_icon_x, icons_y,
        icon_size, icon_size
    );
}

// Затемнение под открытой панелью.
if (panel != "none")
{
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(0, 0, 384, 216, false);

    draw_set_alpha(1);
    draw_set_color(c_white);
}

// Настройки.
if (panel == "settings")
{
    draw_sprite_ext(
        spr_opened_settings, 0,
        settings_x, settings_y_top,
        settings_scale, settings_scale,
        0, c_white, 1
    );

    // Три кнопки настроек.
    for (var i = 0; i < 3; i++)
    {
        draw_fit(
            settings_buttons[i],
            settings_button_x,
            settings_button_ys[i],
            settings_button_w,
            settings_button_h
        );
    }

    // Ползунок громкости.
    var handle_x = lerp(
        slider_left,
        slider_right,
        global.volume
    );

    draw_fit(
        spr_volume_slider,
        handle_x - slider_handle_w / 2,
        slider_y - slider_handle_h / 2,
        slider_handle_w,
        slider_handle_h
    );
}

// Магазин.
if (panel == "store")
{
    draw_sprite_ext(
        spr_opened_store, 0,
        store_x, store_y,
        store_scale, store_scale,
        0, c_white, 1
    );

    // Итоговые смещения относительно исходного положения.
    // Порядок: лапка, котлеты, яичница.
    var food_offset_x = [-3, -5, 0];
    var food_offset_y = [-3, -1, -2];

    // Показываем три блюда.
    for (var i = 0; i < 3; i++)
    {
        var food_spr = food_sprites[i];

        // Размер области, использовавшейся до увеличения яичницы.
        var box_w = store_w * 0.27;
        var box_h = food_row_h;

        // Прежний масштаб рисунка.
        var food_scale = min(
            box_w / sprite_get_width(food_spr),
            box_h / sprite_get_height(food_spr)
        );

        // Прежняя ширина и высота на экране игры.
        var food_w = sprite_get_width(food_spr) * food_scale;
        var food_h = sprite_get_height(food_spr) * food_scale;

        // Прежнее положение с учётом новых смещений.
        var food_x = food_row_x + food_offset_x[i]
            + (box_w - food_w) / 2;

        var food_y = food_row_ys[i] + food_offset_y[i]
            + (box_h - food_h) / 2;

        // Только яичницу увеличиваем на 3 × 2 пикселя.
        // Её левый верхний угол остаётся на прежнем месте.
        if (i == 2)
        {
            food_w += 3;
            food_h += 2;
        }
		// Отдельно рассчитываем масштаб по ширине и высоте.
        var scale_x = food_w / sprite_get_width(food_spr);
        var scale_y = food_h / sprite_get_height(food_spr);

        // Показываем рисунок с учётом Origin.
        draw_sprite_ext(
            food_spr, 0,
            food_x + sprite_get_xoffset(food_spr) * scale_x,
            food_y + sprite_get_yoffset(food_spr) * scale_y,
            scale_x, scale_y,
            0, c_white, 1
        );
    }

    // Цены нарисованы кодом, баланс изменяется сразу.
    for(var fi=0;fi<3;fi++) {
        draw_set_color(c_black);
        draw_text_transformed(food_row_x+store_w*0.46,food_row_ys[fi]+5,"$"+string(food_prices[fi]),0.65,0.65,0);
    }
    // Счётчик покупок.
    draw_set_color(c_white);
    draw_set_halign(fa_center);

    draw_text_transformed(
        192, max(0, store_y - 12),
        "Purchases: " + string(global.food_bought_today) + "/3",
        number_scale, number_scale, 0
    );

    draw_set_halign(fa_left);
}

// Правила.
if (panel == "rules")
{
    var rules_scale = min(
        1,
        364 / sprite_get_width(spr_opened_rules),
        196 / sprite_get_height(spr_opened_rules)
    );

    var rules_x = (384 - sprite_get_width(spr_opened_rules) * rules_scale) / 2;
    var rules_y_top = (216 - sprite_get_height(spr_opened_rules) * rules_scale) / 2;

    draw_sprite_ext(
        spr_opened_rules, 0,
        rules_x, rules_y_top,
        rules_scale, rules_scale,
        0, c_white, 1
    );
}

// Сообщение о результате покупки.
if (notice_time > 0)
{
    draw_set_color(c_black);
    draw_rectangle(0, 196, 384, 216, false);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(192, 206, notice);
}

// Восстанавливаем параметры отрисовки.
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
if(panel=="start_choice") {
    draw_set_font(fnt_pixel);draw_set_color(c_white);draw_set_halign(fa_center);
    draw_text_transformed(192,80,"Choose your game",0.8,0.8,0);
    draw_text_transformed(192,110,(menu_choice==0 ? "> " : "")+"New Game",0.8,0.8,0);
    if(file_exists("zavod_save_v1.json")) draw_text_transformed(192,135,(menu_choice==1 ? "> " : "")+"Continue",0.8,0.8,0);
    draw_text_transformed(192,174,"Up / Down + Enter     Esc: Back",0.5,0.5,0);
}
if(panel=="achievements") zv_ach_draw(ach_scroll);

draw_set_color(c_white);draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_font(-1);
