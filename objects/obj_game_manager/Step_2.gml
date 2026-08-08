if (shake_intensity > 0) {
    var cam = view_camera[0];
    var shake_x = random_range(-shake_intensity, shake_intensity);
    var shake_y = random_range(-shake_intensity, shake_intensity);
    camera_set_view_pos(cam, cam_base_x + shake_x, cam_base_y + shake_y);
    shake_intensity -= 0.5; 

    if (shake_intensity <= 0) {
        camera_set_view_pos(cam, cam_base_x, cam_base_y);
    }
}