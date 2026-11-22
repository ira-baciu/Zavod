draw_set_alpha(1);draw_set_color(c_white);draw_set_font(fnt_pixel);
draw_set_halign(fa_left);draw_set_valign(fa_top);
if(screen_mode=="ending") {
    draw_set_color(c_black);draw_rectangle(0,0,384,216,false);draw_set_color(c_white);
    if(ending_page==0) {
        var sc=min(384/sprite_get_width(ending_sprite),216/sprite_get_height(ending_sprite));
        draw_sprite_ext(ending_sprite,0,(384-sprite_get_width(ending_sprite)*sc)/2+sprite_get_xoffset(ending_sprite)*sc,
            (216-sprite_get_height(ending_sprite)*sc)/2+sprite_get_yoffset(ending_sprite)*sc,sc,sc,0,c_white,1);
    } else {
        var story_text=ending_story_pages[ending_story_index];
        var story_h=string_height_ext(story_text,-1,328/1.1)*1.1;
        draw_set_halign(fa_center);
        draw_text_ext_transformed(192,98-story_h/2,story_text,-1,328/1.1,1.1,1.1,0);
        draw_set_halign(fa_left);
    }
    draw_set_color(c_black);draw_rectangle(0,200,384,216,false);draw_set_color(c_white);
    draw_set_halign(fa_center);
    if(ending_page==1 && array_length(ending_story_pages)>1)
        draw_text_transformed(192,183,"Left / Right: Page "+string(ending_story_index+1)+"/"+string(array_length(ending_story_pages)),0.8,0.8,0);
    draw_text_transformed(192,202,"Space: Picture / Text    Enter: Main Menu",0.8,0.8,0);
    draw_set_halign(fa_left);
} else if(screen_mode=="narrator") {
    zv_box_text("Narrator",pages[page_index]);
} else if(!is_undefined(current_node)) {
    if(current_node.kind=="line") {
        zv_box_text(current_node.speaker,pages[page_index],"Space / Enter: Next  "+string(page_index+1)+"/"+string(array_length(pages)));
    } else if(current_node.kind=="choice") {
        // Scroll long choices instead of shrinking their text.
        var opts=current_node.options;var sc=0.8;var first=0;var used=0;
        for(var i=0;i<=choice_index;i++) {
            used+=string_height_ext(opts[i].text,-1,320/sc)*sc+9;
            while(used>92 && first<i) {
                used-=string_height_ext(opts[first].text,-1,320/sc)*sc+9;
                first++;
            }
        }
        var last=first;var total=0;
        while(last<array_length(opts)) {
            var row_h=string_height_ext(opts[last].text,-1,320/sc)*sc+9;
            if(last>first && total+row_h>92) break;
            total+=row_h;last++;
        }
        var top=max(8,208-total-32);
        draw_set_color(c_white);draw_sprite_stretched(spr_dialogues,0,8,top,368,208-top);
        draw_set_color(c_black);
        draw_text_transformed(20,top+5,"Up / Down: Choose   Enter: Confirm",0.6,0.6,0);
        var yy=top+24;
        for(var i=first;i<last;i++) {
            draw_text_transformed(18,yy,i==choice_index ? ">" : "",sc,sc,0);
            draw_text_ext_transformed(30,yy,opts[i].text,-1,320/sc,sc,sc,0);
            yy+=string_height_ext(opts[i].text,-1,320/sc)*sc+9;
        }

    }
}
zv_toast_draw();
draw_set_color(c_white);draw_set_alpha(1);draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_font(-1);
