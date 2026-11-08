// Выбираем трек
var track = -1;

switch (room)
{
    case rm_menu:   track = snd_menu;   break;
    case rm_home:   track = snd_room;   break;
    case rm_street: track = snd_street; break;
    case rm_gacha:  track = snd_gacha;  break;
}

// Запускаем трек по кругу
music_instance = -1;

if (track != -1)
{
    music_instance = audio_play_sound(track, 0, true);
}