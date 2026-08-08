fade_alpha += (fade_speed * fade_state);

if (fade_alpha >= 1 && fade_state == 1) {
    room_goto(target_room);
    fade_state = -1; 
}

if (fade_alpha <= 0 && fade_state == -1) {
    instance_destroy();
}