if(intro_stage==0) {
    banner_time-=delta_time/1000000;
    if(banner_time>0) exit;
    if(array_length(intro_lines)==0) {global.input_locked=false;instance_destroy();exit;}
    intro_stage=1;pages=zv_pages(intro_lines[0].text,344,29,0.8);exit;
}
if(!(keyboard_check_pressed(vk_space)||keyboard_check_pressed(vk_enter)||mouse_check_button_pressed(mb_left))) exit;
if(page_index+1<array_length(pages)) {page_index++;exit;}
if(global.day==1 && intro_index==1) zv_money(-40);
intro_index++;page_index=0;
if(intro_index>=array_length(intro_lines)) {global.input_locked=false;instance_destroy();exit;}
pages=zv_pages(intro_lines[intro_index].text,344,29,0.8);
