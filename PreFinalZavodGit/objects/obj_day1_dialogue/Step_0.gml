var dt=delta_time/1000000; input_delay=max(0,input_delay-dt);
if(screen_mode=="ending") {
    ending_time+=dt;
    if(ending_time<0.5) exit;
    if(keyboard_check_pressed(vk_space)) ending_page=1-ending_page;
    if(ending_page==1) {
        if(keyboard_check_pressed(vk_right)) ending_story_index=min(array_length(ending_story_pages)-1,ending_story_index+1);
        if(keyboard_check_pressed(vk_left)) ending_story_index=max(0,ending_story_index-1);
    }
    if(keyboard_check_pressed(vk_enter)) {global.input_locked=false;global.zv_ending=false;room_goto(rm_menu);}
    exit;
}
if(input_delay>0) exit;
var advance=keyboard_check_pressed(vk_space)||keyboard_check_pressed(vk_enter);
if(screen_mode=="narrator") {
    if(!advance) exit;
    if(page_index+1<array_length(pages)) {page_index++;exit;}
    narrator_index++;page_index=0;
    if(narrator_index>=array_length(narrator_lines)) {global.input_locked=false;instance_destroy();exit;}
    pages=zv_pages(narrator_lines[narrator_index].text,296,36); input_delay=0.12;exit;
}
if(is_undefined(current_node)) exit;
if(current_node.kind=="choice") {
    var count=array_length(current_node.options);
    if(keyboard_check_pressed(vk_up)) choice_index=(choice_index+count-1) mod count;
    if(keyboard_check_pressed(vk_down)) choice_index=(choice_index+1) mod count;
    if(!keyboard_check_pressed(vk_enter)) exit;
    zv_sfx(snd_buttons);
} else {
    if(!advance) exit;
    if(page_index+1<array_length(pages)) {page_index++;exit;}
}
zv_story_advance(ctx,choice_index,global.zv_flags,zv_apply);
if(global.zv_ending) exit;
zv_ach_check();
if(!zv_check_zero()) exit;
refresh_node();
