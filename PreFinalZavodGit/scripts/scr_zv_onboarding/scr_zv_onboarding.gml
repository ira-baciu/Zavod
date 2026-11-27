// First-play introduction and first-visit messages. Stored separately from achievements.
function zv_onboarding_data(_key) {
    var data=json_parse("{\"prologue\":[{\"speaker\":\"Narrator\",\"text\":\"Player, starting today, the gacha machine will offer limited-edition figurines of various rarities: keychains, characters from different subcultures, and fantasy creatures. Collect as many as you can within 14 days. On Day 15, every remaining figurine will be destroyed. This is their final release...\"},{\"speaker\":\"Player\",\"text\":\"They all look wonderful! I want every single one in my collection, lined up beautifully on the shelves in my room. Especially Brownie. He is so cute and unusual. I absolutely have to get him!\"},{\"speaker\":\"Player\",\"text\":\"I was laid off from my job at the factory, but my pay for last month should arrive today. Looks like I will have to beg for money on the street if I want to earn any more.\"},{\"speaker\":\"Player\",\"text\":\"Above all, I need to avoid starving to death. Good thing there is an online store where I can order food every day. I also need to keep an eye on my mental health. Only pulls from the gacha machine can lift my spirits.\"}],\"home\":[{\"speaker\":\"Narrator\",\"text\":\"Your room looks so dull. A few figurines on those shelves would certainly brighten it up. Still, this is your home. You can save your progress here and go to bed to begin a new day.\"}],\"street\":[{\"speaker\":\"Narrator\",\"text\":\"The street looks empty and dreary, but you can talk to the locals here. Perhaps they will reward you for your help. Keep your eyes open, too. Someone might have dropped some money.\"},{\"speaker\":\"Narrator\",\"text\":\"Remember to talk to people and look for lost bucks every day.\"},{\"speaker\":\"Narrator\",\"text\":\"There is also a gacha machine out on the street. The entrance to the arcade is beside it. Head inside to get your figurines.\"}],\"gacha\":[{\"speaker\":\"Narrator\",\"text\":\"What a bright arcade! Why not try the gacha machine? Each pull costs 20 bucks! They say you are guaranteed a Legendary on your 30th pull. There are two different Legendaries, though, and that guaranteed pull will give you only one of them...\"}]}");
    return variable_struct_get(data,_key);
}
// Tutorial state is owned by the existing UI, never by an instance created during room loading.
function zv_onboarding_reset(_seen=false) {
    global.zv_onboarding={prologue:_seen,home:_seen,street:_seen,gacha:_seen};
    global.zv_tutorial={key:"",lines:[],line_index:0,page_index:0,pages:[],delay:0};
    global.zv_tutorial_cooldown=0;
}
function zv_onboarding_active() {
    return variable_global_exists("zv_tutorial") && global.zv_tutorial.key!="";
}
function zv_tutorial_prepare() {
    var t=global.zv_tutorial;
    var line=t.lines[t.line_index];
    t.pages=t.key=="prologue" ? zv_pages(line.text,328,132,1) : zv_pages(line.text,296,36);
    t.page_index=0;
    global.zv_tutorial=t;
}
// Recompute the lock from actual visible modal owners, rather than a stale Boolean.
function zv_sync_input_lock() {
    var busy=zv_onboarding_active() || instance_exists(obj_day_intro) || instance_exists(obj_day1_dialogue) || global.zv_ending;
    var g=instance_find(obj_gacha,0);
    if(g!=noone && g.screen_state!="idle") busy=true;
    global.input_locked=(room!=rm_menu && busy);
}
function zv_onboarding_begin(_key) {
    if(zv_story_flag(global.zv_onboarding,_key) || zv_onboarding_active()) return;
    global.zv_tutorial={key:_key,lines:zv_onboarding_data(_key),line_index:0,page_index:0,pages:[],delay:0.2};
    zv_tutorial_prepare();
    global.input_locked=true;
}
function zv_onboarding_tick() {
    var dt=min(delta_time/1000000,0.1);
    global.zv_tutorial_cooldown=max(0,global.zv_tutorial_cooldown-dt);
    if(zv_onboarding_active()) {
        var t=global.zv_tutorial;
        t.delay=max(0,t.delay-dt);
        if(t.delay<=0 && (keyboard_check_pressed(vk_space)||keyboard_check_pressed(vk_enter))) {
            t.delay=0.15;
            if(t.page_index+1<array_length(t.pages)) t.page_index++;
            else {
                t.line_index++;
                if(t.line_index<array_length(t.lines)) {
                    global.zv_tutorial=t;zv_tutorial_prepare();t=global.zv_tutorial;
                } else {
                    variable_struct_set(global.zv_onboarding,t.key,true);
                    t={key:"",lines:[],line_index:0,page_index:0,pages:[],delay:0};
                    global.zv_tutorial_cooldown=0.2;
                }
            }
        }
        global.zv_tutorial=t;zv_sync_input_lock();return;
    }
    zv_sync_input_lock();
    if(global.zv_tutorial_cooldown>0 || global.input_locked || room==rm_menu) return;
    var ui=instance_find(obj_ui,0);if(ui!=noone && ui.panel!="none") return;
    switch(room) {
        case rm_home: zv_onboarding_begin("home");break;
        case rm_street: zv_onboarding_begin("street");break;
        case rm_gacha: zv_onboarding_begin("gacha");break;
    }
}
function zv_onboarding_draw() {
    if(!zv_onboarding_active()) return;
    var t=global.zv_tutorial;var line=t.lines[t.line_index];
    draw_set_alpha(1);draw_set_color(c_white);draw_set_font(fnt_pixel);
    draw_set_halign(fa_center);draw_set_valign(fa_top);
    if(t.key=="prologue") {
        draw_set_color(c_black);draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
        draw_set_color(c_white);
        draw_text_transformed(192,20,line.speaker,0.9,0.9,0);
        var text=t.pages[t.page_index];var hh=string_height_ext(text,-1,328);
        draw_text_ext_transformed(192,round(108-hh/2),text,-1,328,1,1,0);
        draw_text_transformed(192,198,"Space / Enter: Next  "+string(t.line_index+1)+"/"+string(array_length(t.lines)),0.65,0.65,0);
    } else zv_box_text(line.speaker,t.pages[t.page_index],"Space / Enter: Next");
    draw_set_color(c_white);draw_set_alpha(1);draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_font(-1);
}
