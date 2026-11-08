// Останавливаем именно тот звук, который запустили при входе.
if (music_instance != -1)
{
    audio_stop_sound(music_instance);
    music_instance = -1;
}