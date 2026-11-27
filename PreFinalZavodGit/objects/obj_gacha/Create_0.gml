// idle — ожидаем крутку.
// result — показываем предмет.
// error — показываем нехватку денег.
screen_state = "idle";

result_time = 0;
result_id = -1;
result_rarity = "";
result_duplicate = false;
result_mp_gain = 0;
lore_name="";lore_pages=[""];lore_index=0;
show_next_lore=function() {
    if(array_length(global.zv_lore_queue)==0) {screen_state="idle";global.input_locked=false;return;}
    var ix=global.zv_lore_queue[0];array_delete(global.zv_lore_queue,0,1);
    lore_name=global.zv_figures[ix].name;
    lore_pages=zv_pages(global.zv_figures[ix].text,328,132,1);
    lore_index=0;screen_state="lore";result_time=0;global.input_locked=true;
};
