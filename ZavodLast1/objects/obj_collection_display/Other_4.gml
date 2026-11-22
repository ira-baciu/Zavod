if (room != rm_home) exit;

// Для каждого предмета запомним один элемент на полке.
shelf_elements = array_create(14, -1);

// Получаем слои комнаты.
var room_layers = layer_get_all();

for (var li = 0; li < array_length(room_layers); li++)
{
    // Получаем элементы текущего слоя.
    var elements = layer_get_all_elements(room_layers[li]);

    for (var ei = 0; ei < array_length(elements); ei++)
    {
        var element = elements[ei];

        // Нас интересуют только спрайты на Asset Layer.
        if (layer_get_element_type(element) != layerelementtype_sprite)
        {
            continue;
        }

        var element_sprite = layer_sprite_get_sprite(element);

        // Проверяем, какая это мини-фигурка.
        for (var item = 0; item < 14; item++)
        {
            if (element_sprite == global.gacha_catalog.mini_sprites[item])
            {
                // Сначала скрываем найденную фигурку.
                layer_sprite_alpha(element, 0);

                // Для каждого предмета используем только одно место.
                // Даже если его случайно расставили дважды,
                // второй экземпляр останется скрытым.
                if (shelf_elements[item] == -1)
                {
                    shelf_elements[item] = element;

                    if (global.collection[item])
                    {
                        layer_sprite_alpha(element, 1);
                    }
                }

                break;
            }
        }
    }
}