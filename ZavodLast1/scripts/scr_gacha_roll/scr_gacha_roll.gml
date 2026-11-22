function scr_gacha_roll(_pull)
{
    var legendary_weight = scr_gacha_weight(_pull);

    // Одно из 10000 целых чисел: от 0 до 9999.
    var roll = irandom(9999);

    // Легендарка: Brownie или Ciel, равновероятно.
    if (_pull >= 30 || roll < legendary_weight)
    {
        return {
            item_id: 12 + irandom(1),
            rarity: "Legendary"
        };
    }

    // Редкие: общий шанс 20%.
    if (roll < legendary_weight + 2000)
    {
        return {
            item_id: 8 + irandom(3),
            rarity: "Rare"
        };
    }

    // Обычные: общий шанс 33%.
    if (roll < legendary_weight + 2000 + 3300)
    {
        return {
            item_id: 3 + irandom(4),
            rarity: "Common"
        };
    }

    // Оставшийся шанс относится к мусору.
    return {
        item_id: irandom(2),
        rarity: "Trash"
    };
}