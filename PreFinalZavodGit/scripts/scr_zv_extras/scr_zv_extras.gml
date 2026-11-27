// Collection milestones, native-size achievements panel, and daily street discoveries.
function zv_extras_content() {
    global.zv_figures = json_parse("[{\"index\":0,\"id\":\"figure_bubble\",\"name\":\"Bubble\",\"achievement\":\"Angler\",\"target\":4,\"text\":\"A funny, slightly silly little fish. Soft, though not fluffy at all, and so much fun to poke. An adorable little keychain.\"},{\"index\":1,\"id\":\"figure_kit\",\"name\":\"Kit\",\"achievement\":\"Cat Person\",\"target\":4,\"text\":\"Such a sweet, fluffy little prize, even if he does turn up rather often. This cat has quite a mind of his own, but he would look adorable hanging from your bag.\"},{\"index\":2,\"id\":\"figure_ducky\",\"name\":\"Ducky\",\"achievement\":\"Workaholic Duck\",\"target\":4,\"text\":\"A very serious-looking little duck. He seems hardworking. Perhaps hanging him from your bag will help you earn a little more money...\"},{\"index\":3,\"id\":\"figure_iray\",\"name\":\"Iray\",\"achievement\":\"Pick-Me\",\"target\":3,\"text\":\"This boy adores cute pink things, and they suit him beautifully. He loves shopping and cooking in the comfort of his cosy home. He always seems sweet and easygoing... but is that really who he is? Such a hungry little thing when it comes to attention...\"},{\"index\":4,\"id\":\"figure_jay\",\"name\":\"Jay\",\"achievement\":\"Schoolboy Fan\",\"target\":3,\"text\":\"This boy is still in school. He is the student council president, and although he seems a little shy, he is responsible and brave. He spends his free time reading books.\"},{\"index\":5,\"id\":\"figure_rowan\",\"name\":\"Rowan\",\"achievement\":\"Social Butterfly in Black\",\"target\":3,\"text\":\"An alternative boy, always dressed in black and red. His skin is so pale you might think he never goes outside. Quite the opposite, actually. He has plenty of like-minded friends and spends time with them almost every day. Such an outgoing, interesting fellow.\"},{\"index\":6,\"id\":\"figure_yeqon\",\"name\":\"Yeqon\",\"achievement\":\"Shy Goth\",\"target\":3,\"text\":\"This boy wears crosses all over his clothes. A goth, of course. So secretive and awkward, which only makes him more endearing. He likes miniskirts and ripped tights, and they suit him. He wants to seem dark and mysterious, but his smile often gives him away. He is terribly afraid of cemeteries.\"},{\"index\":7,\"id\":\"figure_yuke\",\"name\":\"Yuke\",\"achievement\":\"Gyaru with Low Self-Esteem\",\"target\":3,\"text\":\"A gyaru boy. He may seem a little arrogant, but he is kind and always willing to help. He loves fashionable clothes and accessories, yet struggles with self-loathing. He always thought he was too fat... though now he looks rather gaunt.\"},{\"index\":8,\"id\":\"figure_alkaid\",\"name\":\"Alkaid\",\"achievement\":\"The Mage's Secret Wish\",\"target\":2,\"text\":\"A very powerful sorcerer, and far too cute for his own good. He behaves rather strangely: he rarely speaks to people and has little sense of what he should or should not say. An honest, guileless, awkward mage. He loves watching the stars and walking through the woods. He would welcome some company, too, though he would never admit it.\"},{\"index\":9,\"id\":\"figure_beleth\",\"name\":\"Beleth\",\"achievement\":\"A Demon in Human Disguise\",\"target\":2,\"text\":\"Elohim's complete opposite. A demon, yes, but curious and cheerful, with a fondness for tempting people. He often mingles with humans, pretending to be one of them, and rarely loses his temper. He wants to learn everything he can about people, and become a little more like them.\"},{\"index\":10,\"id\":\"figure_elohim\",\"name\":\"Elohim\",\"achievement\":\"An Angel's Anger\",\"target\":2,\"text\":\"An angel in the flesh. There is something divine about his presence. He looks so indulgent, though he is actually terribly short-tempered. One wrong move is enough to make him furious. Still, he quickly regains his composure, hiding his displeasure behind that air of gracious superiority.\"},{\"index\":11,\"id\":\"figure_orion\",\"name\":\"Orion\",\"achievement\":\"Lonely Fae\",\"target\":2,\"text\":\"A mysterious fae. Those dark rumours about fairies stealing people away and marrying them amuse him, so he often plays tricks on travellers passing through the forest. He is kind at heart, helping people find their way through its dangers. Still, life in the woods can be lonely.\"},{\"index\":12,\"id\":\"figure_brownie\",\"name\":\"Brownie\",\"achievement\":\"A Changeable Little Cow\",\"target\":2,\"text\":\"An impossibly sweet and shy human-cow hybrid. Such a caring, empathetic boy. He loves sitting out in nature and wandering through the fields. He needs someone just as kind and caring by his side. Rude, arrogant people drive him mad. If they come into his clearing, he quite literally throws them out.\"},{\"index\":13,\"id\":\"figure_ciel\",\"name\":\"Ciel\",\"achievement\":\"A Cat Hungry for Love\",\"target\":2,\"text\":\"An exceedingly arrogant, provocative, jealous cat. He likes deceiving people and stealing them away to marry him, but they always escape, leaving him sad and lonely. He keeps searching for someone who will choose to stay, yet his domineering nature so often drives them away.\"}]");
    var list=global.zv_content.achievements.achievements;
    for(var i=0;i<array_length(global.zv_figures);i++) {
        var f=global.zv_figures[i];
        var desc="Obtain "+f.name+" at least "+string(f.target)+" times in a single playthrough.";
        if(i>=12) desc="In one playthrough, obtain "+f.name+" twice, OR obtain him once and make at least 50 gacha pulls.";
        array_push(list,{id:f.id,name:f.achievement,description:desc,condition:{kind:"figure_milestone",index:i}});
    }
    array_push(list,{id:"all_achievements",name:"Nothing Left to Unlock",
        description:"Unlock every other achievement, including all figurine milestones, across your playthroughs.",
        condition:{kind:"all_achievements"}});
    global.zv_content.achievements.achievements=list;
}
function zv_extras_reset() {
    global.zv_figure_counts=array_create(14,0);
    global.zv_figure_seen=array_create(14,false);
    global.zv_lore_queue=[];
    global.zv_street_state={day:-1,npc_x:[],money_ids:[],picked:[]};
}
function zv_figure_goal(_index) {
    var n=global.zv_figure_counts[_index];
    if(_index>=12) return n>=2 || (n>=1 && global.total_pulls>=50);
    return n>=global.zv_figures[_index].target;
}
// Check every figurine after each pull: pull 50 can trigger an earlier Legendary.
function zv_figure_check() {
    for(var i=0;i<14;i++) {
        if(!zv_figure_goal(i)) continue;
        zv_unlock(global.zv_figures[i].id);
        if(!global.zv_figure_seen[i]) {
            global.zv_figure_seen[i]=true;
            array_push(global.zv_lore_queue,i);
        }
    }
    zv_meta_check();
}
function zv_meta_check() {
    var list=global.zv_content.achievements.achievements;
    for(var i=0;i<array_length(list);i++) {
        if(list[i].id=="all_achievements") continue;
        if(!zv_story_flag(global.zv_profile.unlocked,list[i].id)) return;
    }
    zv_unlock("all_achievements");
}
// Fisher-Yates returns a shuffled copy; no duplicate daily positions.
function zv_shuffled(_values) {
    var result=[];
    for(var i=0;i<array_length(_values);i++) array_push(result,_values[i]);
    for(var i=array_length(result)-1;i>0;i--) {
        var j=irandom(i);var temp=result[i];result[i]=result[j];result[j]=temp;
    }
    return result;
}
function zv_street_prepare() {
    if(room!=rm_street) return;
    if(global.zv_street_state.day==global.day) return;
    // Keep away from home and the gacha entrance at x=1184.
    var npc_slots=zv_shuffled([104,232,360,488,616,744,872,1000,1336,1416]);
    var second=1;
    while(second<array_length(npc_slots)-1 && abs(npc_slots[0]-npc_slots[second])<128) second++;
    var ids=[];for(var i=0;i<15;i++) array_push(ids,i);
    ids=zv_shuffled(ids);
    global.zv_street_state={day:global.day,npc_x:[npc_slots[0],npc_slots[second]],
        money_ids:[ids[0],ids[1],ids[2]],picked:[false,false,false]};
}
function zv_money_spot(_index) {
    // Fifteen fixed locations along the sidewalk. The icon's TOP LEFT is stored.
    var xs=[80,168,256,344,432,520,608,696,784,872,960,1048,1136,1264,1384];
    var ys=[176,181,170,184,175,188,172,181,190,174,186,177,190,173,184];
    return {px:xs[_index],py:ys[_index]};
}
function zv_street_draw() {
    if(room!=rm_street || global.zv_street_state.day!=global.day) return;
    var state=global.zv_street_state;
    for(var i=0;i<3;i++) {
        if(state.picked[i]) continue;
        var spot=zv_money_spot(state.money_ids[i]);
        draw_sprite_ext(spr_money,0,spot.px+sprite_get_xoffset(spr_money),
            spot.py+sprite_get_yoffset(spr_money),1,1,0,c_white,1);
    }
}
function zv_street_click() {
    if(room!=rm_street || global.input_locked || global.zv_street_state.day!=global.day) return;
    var ui=instance_find(obj_ui,0);if(ui==noone || ui.panel!="none") return;
    if(!mouse_check_button_pressed(mb_left)) return;
    // Never collect through the fixed GUI buttons or status display.
    var gx=device_mouse_x_to_gui(0);var gy=device_mouse_y_to_gui(0);
    if((gx>=330 && gy<=30) || (gx<=80 && gy<=75)) return;
    var state=global.zv_street_state;
    for(var i=0;i<3;i++) {
        if(state.picked[i]) continue;
        var spot=zv_money_spot(state.money_ids[i]);
        if(point_in_rectangle(mouse_x,mouse_y,spot.px-1,spot.py-1,
            spot.px+sprite_get_width(spr_money)+1,spot.py+sprite_get_height(spr_money)+1)) {
            state.picked[i]=true;
            global.zv_street_state=state;
            zv_money(2);return;
        }
    }
}
// Geometry shared by the drawing and the Close hitbox. Sprite scale is always 1.
function zv_ach_layout() {
    var w=sprite_get_width(spr_opened_achivements);
    var h=sprite_get_height(spr_opened_achivements);
    var left=round((display_get_gui_width()-w)/2);
    var top=round((display_get_gui_height()-h)/2);
    return {px:left,py:top,pw:w,ph:h,inner_x:left+32,inner_w:w-64,
        rows:max(1,floor((h-70)/48)),list_y:top+42,
        close_x:left+w-77,close_y:top+15};
}
function zv_ach_draw(_scroll) {
    var r=zv_ach_layout();
    draw_set_alpha(1);draw_set_color(c_white);
    draw_sprite_ext(spr_opened_achivements,0,r.px+sprite_get_xoffset(spr_opened_achivements),
        r.py+sprite_get_yoffset(spr_opened_achivements),1,1,0,c_white,1);
    draw_set_font(fnt_pixel);draw_set_halign(fa_left);draw_set_valign(fa_top);
    var list=global.zv_content.achievements.achievements;var opened=[];
    for(var i=0;i<array_length(list);i++) if(zv_story_flag(global.zv_profile.unlocked,list[i].id)) array_push(opened,list[i]);
    draw_set_color(make_color_rgb(48,30,72));
    draw_text_transformed(r.inner_x,r.py+16,"Achievements "+string(array_length(opened))+"/"+string(array_length(list)),0.85,0.85,0);
    draw_text_transformed(r.close_x,r.close_y,"Close",0.8,0.8,0);
    if(array_length(opened)==0) draw_text_transformed(r.inner_x,r.list_y+15,"No achievements unlocked yet.",0.8,0.8,0);
    _scroll=clamp(_scroll,0,max(0,array_length(opened)-r.rows));
    for(var row=0;row<r.rows;row++) {
        var ix=_scroll+row;if(ix>=array_length(opened)) break;
        var a=opened[ix];var yy=r.list_y+48*row;
        draw_rectangle(r.inner_x-3,yy-2,r.inner_x+r.inner_w+3,yy+43,true);
        var sc=min(0.85,r.inner_w/max(1,string_width(a.name)));
        draw_text_transformed(r.inner_x+3,yy,a.name,sc,sc,0);
        var ds=0.65;
        while(string_height_ext(a.description,-1,(r.inner_w-6)/ds)*ds>27 && ds>0.45) ds-=0.025;
        draw_text_ext_transformed(r.inner_x+3,yy+14,a.description,-1,(r.inner_w-6)/ds,ds,ds,0);
    }
    draw_text_transformed(r.inner_x,r.py+r.ph-23,"Wheel / Up / Down: Scroll    Esc: Close",0.65,0.65,0);
    draw_set_color(c_white);draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_font(-1);
}
