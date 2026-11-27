screen_mode="dialogue"; ctx=undefined; current_node=undefined; npc_owner=noone;
choice_index=0; input_delay=0.15; page_index=0; pages=[""];
ending_time=0; ending_page=0; ending_sprite=-1; ending_key="";
narrator_lines=[];narrator_index=0;
global.input_locked=true;
refresh_node=function() {
    current_node=zv_story_current(ctx,global.zv_flags); choice_index=0;page_index=0;input_delay=0.12;
    if(current_node.kind=="line") pages=zv_pages(current_node.text,296,36);
    if(current_node.kind!="finish") return;
    var result=current_node; variable_struct_set(global.zv_done,ctx.encounter_id,true);
    if(instance_exists(npc_owner)) with(npc_owner) instance_destroy();
    if(result.outcome=="skip_to_day14") {
        variable_struct_set(global.zv_flags,"tycoon_escaped",true);zv_ach_check();
        global.input_locked=false;instance_destroy();zv_next_day(14);return;
    }
    if(result.outcome!="continue") {
        var route=variable_struct_exists(result,"route") ? result.route : "";
        if(route=="tycoon_stay") variable_struct_set(global.zv_flags,"tycoon_stayed_alive",true);
        zv_end(result.outcome,route);return;
    }
    zv_ach_check();
    if(zv_story_can_sleep(global.zv_content,global.day,global.zv_flags,global.zv_done)) {
        var key=string(global.day);
        if(!zv_story_flag(global.zv_outros,key)) {
            variable_struct_set(global.zv_outros,key,true);
            narrator_lines=global.zv_content.story.days[global.day-1].outro;
            if(array_length(narrator_lines)>0) {
                screen_mode="narrator";narrator_index=0;page_index=0;
                pages=zv_pages(narrator_lines[0].text,296,36);return;
            }
        }
    }
    global.input_locked=false;instance_destroy();
};
begin_dialogue=function(_id,_owner) {
    npc_owner=_owner;ctx=zv_story_context(global.zv_content,_id);refresh_node();
};
