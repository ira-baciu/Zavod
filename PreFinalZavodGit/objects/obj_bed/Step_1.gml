if(room!=rm_home || global.input_locked) exit;
var ui=instance_find(obj_ui,0);
if(ui!=noone && ui.panel!="none") exit;
if(!mouse_check_button_pressed(mb_left)) exit;
if(!point_in_rectangle(mouse_x,mouse_y,bbox_left,bbox_top,bbox_right,bbox_bottom)) exit;
if(!zv_story_can_sleep(global.zv_content,global.day,global.zv_flags,global.zv_done)) {
    if(ui!=noone) {ui.notice="Finish today's conversations first.";ui.notice_time=2;} exit;
}
if(global.day==14) {
    zv_ach_check(true);
    zv_end(global.collection[12] ? "desired" : (global.collection[13] ? "wrong" : "none"));
    exit;
}
zv_next_day(global.day+1);
