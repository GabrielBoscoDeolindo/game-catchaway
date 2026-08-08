if (is_active) {
    if (image_speed > 0 && image_index >= image_number - 1) {
        image_speed = 0;
        image_index = image_number - 1;
    }
    if (image_speed == 0) {
        hover_time += 0.1;
        y = base_y + sin(hover_time) * 1.5; 
    }
} else {
    y = base_y;
}