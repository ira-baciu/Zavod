if (room != rm_home) exit;

// Обновляем видимость по состоянию коллекции.
for (var item = 0; item < 14; item++)
{
    var element = shelf_elements[item];

    // Если эта мини-фигурка размещена в комнате.
    if (element != -1)
    {
        if (global.collection[item])
        {
            // Получена — показываем.
            layer_sprite_alpha(element, 1);
        }
        else
        {
            // Пока не получена — скрываем.
            layer_sprite_alpha(element, 0);
        }
    }
}