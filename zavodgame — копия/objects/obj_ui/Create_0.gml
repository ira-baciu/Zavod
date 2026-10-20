// Интерфейс отображается поверх обычных объектов.
depth = -100;

// Открытая панель: none, settings, rules или store.
panel = "none";
rules_return = "none";

// Кнопки главного меню.
button_x = 260;
gap = 8;

start_y = 50;
rules_y = start_y + sprite_get_height(spr_menu_start) + gap;
settings_y = rules_y + sprite_get_height(spr_menu_rules) + gap;

// Настраиваем размер панели Settings.
settings_scale = min(
    1,
    364 / sprite_get_width(spr_opened_settings),
    196 / sprite_get_height(spr_opened_settings)
);

settings_w = sprite_get_width(spr_opened_settings) * settings_scale;
settings_h = sprite_get_height(spr_opened_settings) * settings_scale;

settings_x = (384 - settings_w) / 2;
settings_y_top = (216 - settings_h) / 2;

// Кнопки внутри настроек.
settings_buttons = [
    spr_settings_restart,
    spr_settings_rules,
    spr_settings_menu
];

settings_button_w = settings_w * 0.72;
settings_button_h = settings_h * 0.12;
settings_button_x = settings_x + settings_w * 0.14;

settings_button_ys = [
    settings_y_top + settings_h * 0.44,
    settings_y_top + settings_h * 0.61,
    settings_y_top + settings_h * 0.78
];

// Дорожка ползунка громкости.
slider_left = settings_x + settings_w * 0.20;
slider_right = settings_x + settings_w * 0.80;
slider_y = settings_y_top + settings_h * 0.25;

slider_handle_w = settings_w * 0.07;
slider_handle_h = settings_h * 0.09;
slider_dragging = false;

// Сохраняем ранее выбранную громкость.
if (!variable_global_exists("volume"))
{
    global.volume = 1;
}

audio_master_gain(global.volume);

// Значки справа сверху.
icon_size = 18;
settings_icon_x = 358;
store_icon_x = 334;
icons_y = 8;

// Спрайты состояния: от полного к почти пустому.
stomach_sprites = [
    spr_stomach_1,
    spr_stomach_2,
    spr_stomach_3,
    spr_stomach_4,
    spr_stomach_5,
    spr_stomach_6,
    spr_stomach_7
];

brain_sprites = [
    spr_brain_1,
    spr_brain_2,
    spr_brain_3,
    spr_brain_4,
    spr_brain_5,
    spr_brain_6,
    spr_brain_7
];

// Определяем номер картинки по текущему значению.
status_index = function(_value)
{
    if (_value >= 90) return 0;
    if (_value >= 70) return 1;
    if (_value >= 55) return 2;
    if (_value >= 30) return 3;
    if (_value >= 16) return 4;
    if (_value >= 6) return 5;
    return 6;
};

// Настраиваем размер панели магазина.
store_scale = min(
    1,
    364 / sprite_get_width(spr_opened_store),
    184 / sprite_get_height(spr_opened_store)
);

store_w = sprite_get_width(spr_opened_store) * store_scale;
store_h = sprite_get_height(spr_opened_store) * store_scale;

store_x = (384 - store_w) / 2;
store_y = (216 - store_h) / 2;

// Рисунки, цены и восстановление здоровья.
food_sprites = [
    spr_store_chiken_foot,
    spr_store_chiken_cutlets,
    spr_store_eggs
];

food_prices = [2, 4, 10];
food_healing = [3, 6, 10];

// Три строки товаров внутри панели.
food_row_ys = [
    store_y + store_h * 0.18,
    store_y + store_h * 0.43,
    store_y + store_h * 0.68
];

food_row_x = store_x + store_w * 0.08;
food_row_w = store_w * 0.84;
food_row_h = store_h * 0.21;

// Временное сообщение для игрока.
notice = "";
notice_time = 0;

// Показываем спрайт внутри заданной области.
// Пропорции сохраняются, Origin учитывается автоматически.
draw_fit = function(_spr, _x, _y, _w, _h)
{
    var s = min(
        _w / sprite_get_width(_spr),
        _h / sprite_get_height(_spr)
    );

    var px = _x + (_w - sprite_get_width(_spr) * s) / 2;
    var py = _y + (_h - sprite_get_height(_spr) * s) / 2;

    draw_sprite_ext(
        _spr, 0,
        px + sprite_get_xoffset(_spr) * s,
        py + sprite_get_yoffset(_spr) * s,
        s, s,
        0, c_white, 1
    );
};