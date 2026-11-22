// Убираем блокировку, если объект удалён
// при открытом результате.
if (screen_state != "idle")
{
    global.input_locked = false;
}