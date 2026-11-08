// Используем твой шрифт.
draw_set_font(fnt_pixel);
draw_set_alpha(1);

// Чёрный экран с названием дня.
if (intro_stage == 0)
{
    draw_set_color(c_black);
    draw_rectangle(0, 0, 384, 216, false);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(192, 108, day_title);
}
else
{
    // Диалоговая панель.
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_sprite_stretched(
        spr_dialogues, 0,
        8, 142,
        368, 66
    );

    // Реплики первого дня.
    var dialogue_text = "";

    if (intro_stage == 1)
    {
        dialogue_text = "You received your salary from the factory today, only 550 bucks.";
    }
    else if (intro_stage == 2)
    {
        dialogue_text = "How many figurines can you get for this money? Wait, but it seems you have unpaid bills for electricity, gas, water, and internet, a total of 40 bucks.";
    }
    else if (intro_stage == 3)
    {
        dialogue_text = "You had to pay those 40 bucks for the bills with a heavy heart, but now you have a whole 510 bucks left.";
    }

    draw_set_color(c_black);
    draw_text_ext(20, 152, dialogue_text, -1, 344);
}

//Параметры отрисовки.
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);