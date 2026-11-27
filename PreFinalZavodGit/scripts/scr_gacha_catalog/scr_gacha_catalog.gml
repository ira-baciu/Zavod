function scr_gacha_catalog()
{
    // Номера предметов:
    // 0–2 — мусор.
    // 3–7 — обычные.
    // 8–11 — редкие.
    // 12–13 — легендарные.

    var names = [
        "Bubble",
        "Kit",
        "MrDucky",
        "Iray",
        "Jay",
        "Rowan",
        "Yeqon",
        "Yuke",
        "Alkaid",
        "Beleth",
        "Elohim",
        "Orion",
        "Brownie",
        "Ciel"
    ];

    // Большие версии для экрана гачи.
    var sprites = [
        spr_character_trash_Bubble,
        spr_character_trash_Kit,
        spr_character_trash_MrDucky,

        spr_character_ordinary_Iray,
        spr_character_ordinary_Jay,
        spr_character_ordinary_Rowan,
        spr_character_ordinary_Yeqon,
        spr_character_ordinary_Yuke,

        spr_character_rare_Alkaid,
        spr_character_rare_Beleth,
        spr_character_rare_Elohim,
        spr_character_rare_Orion,

        spr_character_legendary_Brownie,
        spr_character_legendary_Ciel
    ];

    // Мини-версии с названиями с твоего скриншота.
    var mini_sprites = [
        spr_mini_character_trash_Bubble,
        spr_mini_character_trash_Kit,
        spr_mini_character_trash_MrDucky,

        spr_mini_character_ordinary_Iray,
        spr_mini_character_ordinary_Jay,
        spr_mini_character_ordinary_Rowan,
        spr_mini_character_ordinary_Yeqon,
        spr_mini_character_ordinary_Yuke,

        spr_mini_character_rare_Alkaid,
        spr_mini_character_rare_Beleth,
        spr_mini_character_rare_Elohim,
        spr_mini_character_rare_Orion,

        spr_mini_character_legendary_Brownie,
        spr_mini_character_legendary_Ciel
    ];

    // Возвращаем каталог.
    return {
        names: names,
        sprites: sprites,
        mini_sprites: mini_sprites
    };
}