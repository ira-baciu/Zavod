function scr_gacha_weight(_pull)
{
    // Шансы выражены целыми числами:
    // 100 = 1%, 120 = 1.2%, 10000 = 100%.

    if (_pull <= 20) return 100;

    switch (_pull)
    {
        case 21: return 120;
        case 22: return 140;
        case 23: return 160;
        case 24: return 180;
        case 25: return 200;
        case 26: return 300;
        case 27: return 400;
        case 28: return 600;
        case 29: return 1000;
    }

    // На крутке 30 — гарант.
    return 10000;
}