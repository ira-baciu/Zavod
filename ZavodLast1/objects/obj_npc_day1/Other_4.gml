if(room!=rm_street) { instance_destroy(); exit; }
var available=zv_story_available(global.zv_content,global.day,global.zv_flags);
// Slot 1 is the left/old-woman position, slot 0 the janitor position.
var slot=npc_kind==1 ? 0 : 1;
var today=global.zv_content.story.days[global.day-1].encounters;
encounter_id=today[slot];
if(!array_contains(available,encounter_id) || zv_story_flag(global.zv_done,encounter_id)) {instance_destroy();exit;}
var enc=variable_struct_get(global.zv_content.story.encounters,encounter_id);
sprite_index=asset_get_index(variable_struct_get(global.zv_content.rules.sprites,enc.role));
