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
var number_scale = 0.7;

// Главное меню.
if (room == rm_menu)
{
    draw_sprite(spr_menu_start, 0, button_x, start_y);
    draw_sprite(spr_menu_rules, 0, button_x, rules_y);
    draw_sprite(spr_menu_settings, 0, button_x, settings_y);
    draw_sprite(spr_menu_achivments,0,button_x,achievements_y);
}
// Показатели в комнате героя.
else if (room == rm_home || room == rm_street || room == rm_gacha)
{
draw_set_color(c_white);
draw_set_alpha(1);

// Деньги.
draw_sprite_stretched(
    spr_under_numbers, 0,
    4, 7,
    52, 16
);

// HP.
draw_sprite_stretched(
    spr_under_numbers, 0,
    4, 28,
    52, 18
);

// MP.
draw_sprite_stretched(
    spr_under_numbers, 0,
    4, 52,
    52, 18
);

    // Деньги. Число сдвинуто с X = 34 на X = 29.
    draw_fit(spr_money, 8, 8, 14, 14);

    draw_text_transformed(
        26, 10,
        "$" + string(round(shown_money)),
        number_scale, number_scale, 0
    );

    // Желудок и здоровье.
    var hp_index = status_index(global.hp);
    draw_fit(stomach_sprites[hp_index], 5, 27, 20, 20);

    draw_text_transformed(
        26, 32,
        string(round(shown_hp)) + "/100",
        number_scale, number_scale, 0
    );

    // Мозг и ментальное состояние.
    var mp_index = status_index(global.mp);
    draw_fit(brain_sprites[mp_index], 5, 51, 20, 20);

    draw_text_transformed(
        26, 56,
        string(round(shown_mp)) + "/100",
        number_scale, number_scale, 0
    );

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
if(panel=="achievements") {
    draw_sprite_stretched(spr_opened_achivements,0,8,8,368,200);
    // Opaque readable area inside the supplied panel.
    draw_set_color(make_color_rgb(20,15,30));draw_rectangle(24,32,360,190,false);
    draw_set_color(c_white);draw_set_font(fnt_pixel);draw_set_halign(fa_left);draw_set_valign(fa_top);
    draw_text_transformed(30,17,"Achievements",0.7,0.7,0);
    draw_text_transformed(328,17,"Close",0.5,0.5,0);
    var list=global.zv_content.achievements.achievements;var unlocked=[];
    for(var ai=0;ai<array_length(list);ai++) if(zv_story_flag(global.zv_profile.unlocked,list[ai].id)) array_push(unlocked,list[ai]);
    if(array_length(unlocked)==0) draw_text_transformed(34,65,"No achievements unlocked yet.",0.6,0.6,0);
    for(var row=0;row<3;row++) {
        var ix=ach_scroll+row;if(ix>=array_length(unlocked)) break;
        var a=unlocked[ix];var yy=37+row*50;
        draw_set_color(make_color_rgb(160,220,225));draw_rectangle(29,yy,355,yy+47,true);
        var sc=min(0.6,310/max(1,string_width(a.name)));
        draw_text_transformed(35,yy+3,a.name,sc,sc,0);
        sc=0.45;
        while(string_height_ext(a.description,-1,310/sc)*sc>28 && sc>0.3) sc-=0.025;
        draw_text_ext_transformed(35,yy+17,a.description,-1,310/sc,sc,sc,0);
    }
    draw_set_color(c_white);draw_text_transformed(32,193,"Wheel / Up / Down     Esc: Close",0.45,0.45,0);
}
draw_set_color(c_white);draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_font(-1);
