if(!variable_global_exists("day_intro_pending") || !global.day_intro_pending) {instance_destroy();exit;}
global.day_intro_pending=false;global.input_locked=true;
intro_stage=0;banner_time=1.5;day_title="Day "+string(global.day);
intro_lines=[];intro_index=0;page_index=0;
if(global.day==1) {
    array_push(intro_lines,{speaker:"Narrator",text:"You received your salary from the factory today, only 550 bucks."});
    array_push(intro_lines,{speaker:"Narrator",text:"Wait, you have unpaid bills for electricity, gas, water and internet: 40 bucks in total."});
    array_push(intro_lines,{speaker:"Narrator",text:"With a heavy heart you paid the bills. You have 510 bucks left."});
}
var lines=global.zv_content.story.days[global.day-1].intro;
for(var i=0;i<array_length(lines);i++) array_push(intro_lines,lines[i]);
pages=[""];
