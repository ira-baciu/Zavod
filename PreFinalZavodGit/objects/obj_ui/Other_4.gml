// Останавливаем все экземпляры музыкальных треков.
// Это убирает и те, которые могли остаться от прошлых локаций.
audio_stop_sound(snd_menu);
audio_stop_sound(snd_room);
audio_stop_sound(snd_street);
audio_stop_sound(snd_gacha);

// Выбираем музыку текущей локации.
var track = -1;

switch (room)
{
    case rm_menu:
        track = snd_menu;
        break;

    case rm_home:
        track = snd_room;
        break;

    case rm_street:
        track = snd_street;
        break;

    case rm_gacha:
        track = snd_gacha;
        break;
}

// Используем громкость, выбранную ползунком.
if (!variable_global_exists("volume"))
{
    global.volume = 1;
}

audio_master_gain(global.volume);

// Запускаем только выбранную музыку.
if (track != -1)
{
    audio_play_sound(track, 0, true);
}
if(global.zv_last_room!=-1 && global.zv_last_room!=room) zv_sfx(snd_location);
global.zv_last_room=room;
if(room==rm_menu) {global.input_locked=false;global.zv_ending=false;}

zv_street_prepare();
zv_meta_check();
