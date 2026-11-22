if(intro_stage==0) {
    draw_set_alpha(1);draw_set_color(c_black);draw_rectangle(0,0,384,216,false);
    draw_set_font(fnt_pixel);draw_set_color(c_white);draw_set_halign(fa_center);draw_set_valign(fa_middle);
    draw_text(192,108,day_title);draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_font(-1);
} else zv_box_text("Narrator",pages[page_index]);
