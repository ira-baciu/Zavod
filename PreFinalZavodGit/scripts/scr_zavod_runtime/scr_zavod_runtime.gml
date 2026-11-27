// Общая инициализация: прогресс достижений живёт отдельно от прохождения.
function zv_boot() {
    if (variable_global_exists("zv_content")) return;
    randomise();
    global.zv_content = zv_load_story_content();
    zv_extras_content();zv_extras_reset();zv_onboarding_reset();
    global.zv_profile = { unlocked: {}, endings: {}, prison: {} };
    if (file_exists("zavod_achievements_v1.json")) {
        var loaded = zv_read_json_file("zavod_achievements_v1.json");
        if (is_struct(loaded) && variable_struct_exists(loaded,"unlocked")
            && variable_struct_exists(loaded,"endings") && variable_struct_exists(loaded,"prison")) global.zv_profile = loaded;
    }
    global.zv_toasts = []; global.zv_toast_time = 0;
    global.zv_ending = false; global.input_locked = false;
    global.zv_last_room = -1;
    global.zv_flags = {}; global.zv_jobs = {}; global.zv_done = {}; global.zv_outros = {};
    global.zv_outfit = "";
}
function zv_write(_name,_value) {
    var fh = file_text_open_write(_name);
    file_text_write_string(fh,json_stringify(_value)); file_text_close(fh);
}
function zv_profile_save() { zv_write("zavod_achievements_v1.json",global.zv_profile); }
function zv_sfx(_sound) { audio_play_sound(_sound,5,false); }
function zv_money(_delta,_silent=false) {
    var old = global.money; global.money = max(0,global.money + _delta);
    if (!_silent && global.money != old) zv_sfx(global.money > old ? snd_earning_money : snd_spending_money);
}
function zv_unlock(_id) {
    if (zv_story_flag(global.zv_profile.unlocked,_id)) return;
    variable_struct_set(global.zv_profile.unlocked,_id,true);
    array_push(global.zv_toasts,_id); zv_profile_save();
    if(_id!="all_achievements") zv_meta_check();
}
function zv_role_worked(_role) {
    var ids = variable_struct_get_names(global.zv_jobs);
    for(var i=0;i<array_length(ids);i++) {
        if (zv_story_flag(global.zv_jobs,ids[i]) && variable_struct_get(global.zv_content.story.encounters,ids[i]).role == _role) return true;
    }
    return false;
}
function zv_ach_check(_final=false) {
    var list=global.zv_content.achievements.achievements;
    for(var i=0;i<array_length(list);i++) {
        var a=list[i]; var c=a.condition; var ok=false;
        switch(c.kind) {
            case "figure_milestone": ok=zv_figure_goal(c.index); break;
            case "stat_zero": ok=(c.stat=="hp" ? global.hp : global.mp)<=0; break;
            case "owned_item": ok=global.collection[c.index]; break;
            case "ending": ok=zv_story_flag(global.zv_profile.endings,c.ending); break;
            case "all_endings": ok=array_length(variable_struct_get_names(global.zv_profile.endings))==8; break;
            case "prison_routes": ok=zv_story_flag(global.zv_profile.prison,"child") && zv_story_flag(global.zv_profile.prison,"dealer"); break;
            case "prison_route": ok=zv_story_flag(global.zv_profile.prison,c.route); break;
            case "all_jobs": ok=zv_story_all_flags(global.zv_jobs,c.ids); break;
            case "flags": ok=zv_story_all_flags(global.zv_flags,c.ids); break;
            case "never_role_final": ok=_final && !zv_role_worked(c.role); break;
            case "cow_escape": ok=zv_story_flag(global.zv_flags,"tycoon_escaped") && global.zv_outfit=="cow"; break;
            case "cat_escape": ok=zv_story_flag(global.zv_flags,"tycoon_escaped") && global.zv_outfit=="cat"; break;
            case "obsession": ok=zv_story_flag(global.zv_flags,"tycoon_escaped") && global.zv_outfit=="cow" && zv_story_flag(global.zv_flags,"beauty_service"); break;
            case "principles":
                ok=global.day==14 && zv_story_can_sleep(global.zv_content,14,global.zv_flags,global.zv_done);
                var bad=["old_woman","child","rich_kid","perv","tycoon","dealer"];
                for(var j=0;j<array_length(bad);j++) if(zv_role_worked(bad[j])) ok=false;
                if(zv_story_flag(global.zv_flags,"beauty_service")) ok=false;
                break;
        }
        if(ok) zv_unlock(a.id);
    }
}
function zv_stop_music() {
    audio_stop_sound(snd_menu); audio_stop_sound(snd_room); audio_stop_sound(snd_street); audio_stop_sound(snd_gacha); audio_stop_sound(snd_walking);
}
function zv_end(_key,_route="") {
    if(global.zv_ending) return;
    global.zv_ending=true; global.input_locked=true;
    variable_struct_set(global.zv_profile.endings,_key,true);
    if(_key=="prison" && _route!="") variable_struct_set(global.zv_profile.prison,_route,true);
    if(_key=="slave" && string_pos("tycoon",_route)>0) variable_struct_set(global.zv_flags,"tycoon_slave_ending",true);
    zv_ach_check(); zv_profile_save(); zv_stop_music(); zv_sfx(snd_ending);
    var d=instance_find(obj_day1_dialogue,0);
    if(d==noone) d=instance_create_depth(0,0,-10000,obj_day1_dialogue);
    d.screen_mode="ending"; d.ending_key=_key; d.ending_time=0;
    d.ending_page=0; d.ending_data=variable_struct_get(global.zv_content.story.endings,_key);
    d.ending_sprite=asset_get_index(d.ending_data.sprite);
    d.ending_story_pages=zv_pages(d.ending_data.text,328,144,1.1);
    d.ending_story_index=0;
}
function zv_check_zero() {
    if(global.hp<=0) { zv_end("hp"); return false; }
    if(global.mp<=0) { zv_end("mp"); return false; }
    return true;
}
// Все последствия JSON применяются только при подтверждении реплики/ответа.
function zv_apply(_a,_ctx) {
    var dh=0; var dm=0;
    switch(_a.kind) {
        case "job":
            var pay=_a.money; if(is_struct(pay)) pay=irandom_range(pay.min,pay.max);
            zv_money(pay); dh=_a.hp; dm=_a.mp;
            variable_struct_set(global.zv_jobs,_ctx.encounter_id,true); break;
        case "stats":
            if(variable_struct_exists(_a,"hp")) dh=_a.hp;
            if(variable_struct_exists(_a,"mp")) dm=_a.mp; break;
        case "set_flag": variable_struct_set(global.zv_flags,_a.name,_a.value); break;
        case "local_add":
            variable_struct_set(_ctx.locals,_a.name,variable_struct_get(_ctx.locals,_a.name)+_a.value); break;
        case "beauty_service":
            var cost=min(global.money,_a.spend_cap); zv_money(-cost);
            variable_struct_set(global.zv_flags,"beauty_service",true);
            if(cost>0) variable_struct_set(global.zv_flags,global.day==8 ? "beauty_paid_08" : "beauty_paid_13",true);
            dh=_a.hp; dm=_a.mp; break;
        case "child_final":
            var correct=_ctx.locals.child_correct+_a.correct_delta;
            zv_money(_a.rewards[correct]); dh=_a.hp; dm=_a.mp;
            variable_struct_set(global.zv_jobs,_ctx.encounter_id,true);
            if(correct==3) variable_struct_set(global.zv_flags,"child_all_correct",true);
            if(correct==0) variable_struct_set(global.zv_flags,"child_all_wrong",true); break;
        case "tycoon_cost":
            global.zv_outfit=_a.outfit;
            global.hp=clamp(global.hp+_a.hp,0,100); global.mp=clamp(global.mp+_a.mp,0,100);
            if(global.hp<=0 || global.mp<=0) { zv_end("slave","tycoon_damage"); return false; }
            variable_struct_set(global.zv_flags,"tycoon_survived",true); break;
    }
    global.hp=clamp(global.hp+dh,0,100); global.mp=clamp(global.mp+dm,0,100);
    // Проверка после всех действий узла сохраняет флаги, идущие после награды.
    return true;
}
function zv_next_day(_day) {
    global.day=_day; global.food_bought_today=0;
    global.hp=max(0,global.hp-10); global.mp=max(0,global.mp-(global.mp<50 ? 10 : 5));
    if(!zv_check_zero()) return;
    global.day_intro_pending=true; global.input_locked=true;
    if(room==rm_home) instance_create_depth(0,0,-10000,obj_day_intro);
    else room_goto(rm_home);
}
function zv_narrate(_lines) {
    if(array_length(_lines)==0) return;
    var d=instance_create_depth(0,0,-10000,obj_day1_dialogue);
    d.screen_mode="narrator"; d.narrator_lines=_lines; d.narrator_index=0;
}
// Отдельный слот сохраняет только прохождение, не сбрасывая достижения.
function zv_save() {
    zv_write("zavod_save_v1.json",{
        version:1, day:global.day,hp:global.hp,mp:global.mp,money:global.money,
        food:global.food_bought_today,collection:global.collection,pulls:global.total_pulls,pity:global.pulls_since_legendary,
        flags:global.zv_flags,jobs:global.zv_jobs,done:global.zv_done,outros:global.zv_outros,outfit:global.zv_outfit,
        figure_counts:global.zv_figure_counts,figure_seen:global.zv_figure_seen,lore_queue:global.zv_lore_queue,street:global.zv_street_state,
        onboarding:global.zv_onboarding
    });
}
function zv_continue() {
    if(!file_exists("zavod_save_v1.json")) return false;
    var s=zv_read_json_file("zavod_save_v1.json");
    if(!is_struct(s) || !variable_struct_exists(s,"version") || s.version!=1) return false;
    global.day=s.day; global.hp=s.hp; global.mp=s.mp; global.money=s.money;
    global.food_bought_today=s.food;global.collection=s.collection;
    global.total_pulls=s.pulls;global.pulls_since_legendary=s.pity;
    global.zv_flags=s.flags;global.zv_jobs=s.jobs;global.zv_done=s.done;global.zv_outros=s.outros;global.zv_outfit=s.outfit;
    zv_extras_reset();
    // Old saves recorded ownership only. Do not invent missing duplicate counts.
    if(variable_struct_exists(s,"figure_counts") && is_array(s.figure_counts) && array_length(s.figure_counts)==14)
        global.zv_figure_counts=s.figure_counts;
    else for(var i=0;i<14;i++) global.zv_figure_counts[i]=global.collection[i] ? 1 : 0;
    if(variable_struct_exists(s,"figure_seen") && is_array(s.figure_seen) && array_length(s.figure_seen)==14) global.zv_figure_seen=s.figure_seen;
    if(variable_struct_exists(s,"lore_queue") && is_array(s.lore_queue)) global.zv_lore_queue=s.lore_queue;
    if(variable_struct_exists(s,"street") && is_struct(s.street)) global.zv_street_state=s.street;
    zv_onboarding_reset(true);
    if(variable_struct_exists(s,"onboarding") && is_struct(s.onboarding)) {
        var keys=["prologue","home","street","gacha"];
        for(var ti=0;ti<array_length(keys);ti++) {
            if(variable_struct_exists(s.onboarding,keys[ti]))
                variable_struct_set(global.zv_onboarding,keys[ti],variable_struct_get(s.onboarding,keys[ti]));
        }
    }
    zv_figure_check();
    global.gacha_catalog=scr_gacha_catalog();global.npc_done=array_create(28,false);
    global.street_spawn_x=-1;global.gacha_return_x=48;
    global.day_intro_pending=false;global.input_locked=false;global.zv_ending=false;
    room_goto(rm_home);return true;
}
// Перенос строк и разбиение длинных реплик на страницы без уменьшения до нечитаемого размера.
function zv_pages(_text,_width,_height,_scale=1) {
    draw_set_font(fnt_pixel);
    var words=string_split(string_replace_all(_text,"\n"," ")," "); var pages=[]; var page="";
    for(var i=0;i<array_length(words);i++) {
        var candidate=page=="" ? words[i] : page+" "+words[i];
        if(page!="" && string_height_ext(candidate,-1,_width/_scale)*_scale>_height) {
            array_push(pages,page);page=words[i];
        } else page=candidate;
    }
    array_push(pages,page);return pages;
}
function zv_box_text(_speaker,_text,_hint="Space / Enter: Next") {
    draw_set_font(fnt_pixel);draw_set_halign(fa_left);draw_set_valign(fa_top);
    draw_set_color(c_white);draw_set_alpha(1);
    draw_sprite_stretched(spr_dialogues,0,32,132,320,76);
    draw_set_color(c_black);
    draw_text_transformed(44,137,_speaker,1,1,0);
    draw_text_ext_transformed(44,151,_text,-1,296,1,1,0);
    draw_text_transformed(44,194,_hint,0.75,0.75,0);
    draw_set_color(c_white);draw_set_font(-1);
}
function zv_toast_draw() {
    if(array_length(global.zv_toasts)==0 || global.zv_toast_time<=0) return;
    var list=global.zv_content.achievements.achievements; var title="";
    for(var i=0;i<array_length(list);i++) if(list[i].id==global.zv_toasts[0]) title=list[i].name;
    draw_set_alpha(1);draw_set_color(make_color_rgb(20,15,30));draw_rectangle(80,4,304,38,false);
    draw_set_color(make_color_rgb(160,220,225));draw_rectangle(80,4,304,38,true);
    draw_set_font(fnt_pixel);draw_set_halign(fa_center);draw_set_valign(fa_top);
    draw_text_transformed(192,7,"Achievement unlocked!",0.5,0.5,0);
    var sc=min(0.6,212/max(1,string_width(title)));
    draw_text_transformed(192,21,title,sc,sc,0);
    draw_set_halign(fa_left);draw_set_color(c_white);draw_set_font(-1);
}
