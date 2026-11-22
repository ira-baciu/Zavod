if (room != rm_gacha) exit;

// Когда открыты настройки или магазин, скрываем информацию о крутках.
if (screen_state == "idle")
{
    var ui = instance_find(obj_ui, 0);

    if (ui != noone)
    {
        if (ui.panel != "none") exit;
    }
}

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

draw_set_font(fnt_pixel);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);


// ====================================
// ИНФОРМАЦИЯ О КРУТКАХ
// ====================================

if (screen_state == "idle")
{
    // Берём настоящий размер спрайта.
    var panel_w = sprite_get_width(spr_pull_score);
    var panel_h = sprite_get_height(spr_pull_score);

    // Правый нижний угол, отступ от краёв — 8 пикселей.
    var panel_x = gui_w - panel_w - 8;
    var panel_y = gui_h - panel_h - 8;

    // Масштаб 1, 1 — рисуем без увеличения.
    // Поправка на Origin сохраняет точное положение плашки.
    draw_sprite_ext(
        spr_pull_score,
        0,
        panel_x + sprite_get_xoffset(spr_pull_score),
        panel_y + sprite_get_yoffset(spr_pull_score),
        1, 1,
        0,
        c_white,
        1
    );

    var lines = [
        "Gacha",
        "Pulls: " + string(global.total_pulls),
        "Pity: " + string(global.pulls_since_legendary) + "/30",
        "Cost: $20",
        "E: Pull",
        "G: Return"
    ];

    var line_count = array_length(lines);

    // Расстояние между строками — максимум 16 пикселей.
    // На маленькой плашке оно автоматически уменьшается.
    var line_step = min(
        16,
        max(1, (panel_h - 24) / line_count)
    );

    // Центрируем весь блок текста внутри плашки.
    var first_y = panel_y + panel_h / 2
        - (line_count - 1) * line_step / 2;

    draw_set_color(c_black);

    for (var i = 0; i < line_count; i++)
    {
        var text_scale = 0.5;

        if (i == 0)
        {
            text_scale = 0.65;
        }

        // Текст помещается по ширине и высоте.
        text_scale = min(
            text_scale,
            max(1, panel_w - 24)
                / max(1, string_width(lines[i])),
            line_step * 0.75
                / max(1, string_height(lines[i]))
        );

        draw_text_transformed(
            panel_x + panel_w / 2,
            first_y + i * line_step,
            lines[i],
            text_scale,
            text_scale,
            0
        );
    }
}


// ====================================
// ЭКРАН ПОЛУЧЕНИЯ ПЕРСОНАЖА
// ====================================

else
{
    // Полупрозрачное затемнение на весь экран.
    draw_set_color(c_black);
    draw_set_alpha(0.8);

    draw_rectangle(
        0, 0,
        gui_w, gui_h,
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);

    if (screen_state == "error")
    {
        draw_text_transformed(
            gui_w / 2,
            gui_h / 2,
            "Not enough currency",
            0.9, 0.9,
            0
        );
    }

    else if (screen_state == "result")
    {
        var spr = global.gacha_catalog.sprites[result_id];

        // Большой персонаж помещается в область 128 × 128.
        var figure_scale = min(
            128 / sprite_get_width(spr),
            128 / sprite_get_height(spr)
        );

        var figure_x = gui_w / 2
            - sprite_get_width(spr) * figure_scale / 2;

        var figure_y = gui_h / 2
            - sprite_get_height(spr) * figure_scale / 2;

        var reveal_alpha = min(1, result_time / 0.3);
        var glow=make_color_rgb(145,145,145);
        if(result_rarity=="Common" || result_rarity=="Ordinary") glow=make_color_rgb(85,190,255);
        if(result_rarity=="Rare") glow=make_color_rgb(175,85,235);
        if(result_rarity=="Legendary") glow=make_color_rgb(255,205,60);
        draw_set_color(glow);draw_set_alpha(0.25*reveal_alpha);
        draw_circle(gui_w/2,gui_h/2,72,false);
        draw_set_alpha(1);draw_set_color(c_white);

        draw_sprite_ext(
            spr,
            0,
            figure_x + sprite_get_xoffset(spr) * figure_scale,
            figure_y + sprite_get_yoffset(spr) * figure_scale,
            figure_scale,
            figure_scale,
            0,
            c_white,
            reveal_alpha
        );

        // Показываем только крупное имя, без редкости и прибавки MP.
        var figure_name = global.gacha_catalog.names[result_id];
		var name_scale = min(
            1.2,
            (gui_w - 24) / max(1, string_width(figure_name))
        );

        draw_text_transformed(
            gui_w / 2,
            gui_h - 24,
            figure_name,
            name_scale,
            name_scale,
            0
        );
    }
}


// Возвращаем стандартные параметры рисования.
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
