// Камера следует за героем только на улице.
if (room == rm_street && view_enabled)
{
    var cam = view_camera[0];

    if (cam != -1)
    {
        var cam_w = camera_get_view_width(cam);

        // Держим героя около центра видимого участка.
        var cam_x = clamp(
            x - cam_w / 2,
            0,
            max(0, room_width - cam_w)
        );

        // Двигаем камеру только по горизонтали.
        camera_set_view_pos(cam, round(cam_x), 0);
    }
}