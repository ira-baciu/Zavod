// Размер окна игры.
window_set_size(1152, 648);

// Размещаем окно по центру монитора.
window_center();

// Размер координат интерфейса.
display_set_gui_size(384, 216);

// Отключаем сглаживание пиксельных рисунков.
gpu_set_texfilter(false);

// Если громкость ещё не задана, устанавливаем максимум.
if (!variable_global_exists("volume"))
{
    global.volume = 1;
}

// Применяем общую громкость.
audio_master_gain(global.volume);

// Запускаем музыку с повторением.
audio_play_sound(snd_menu, 0, true);