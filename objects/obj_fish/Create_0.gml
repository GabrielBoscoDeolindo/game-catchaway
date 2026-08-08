if (instance_exists(obj_fish_box))
{
    var margem = 6;

    target_x = random_range(
        obj_fish_box.bbox_left + margem,
        obj_fish_box.bbox_right - margem
    );

    target_y = random_range(
        obj_fish_box.bbox_top + margem,
        obj_fish_box.bbox_bottom - margem
    );
}
else
{
    target_x = x + 100;
    target_y = y;
}


start_x = x;
start_y = y;
end_x = target_x;
end_y = target_y;
control_x = lerp(start_x,end_x,0.5);
control_y = min(start_y,end_y) - random_range(60,90);

//==============================
// Movimento
//==============================

progress = 0;
duration = random_range(35,50);

state = 0;

//==============================
// Rotação
//==============================

image_angle = random_range(-20,20);
rot_speed = random_range(-10,10);
image_xscale = choose(1, -1);

//==============================
// Quique
//==============================

bounce = 0;
bounce_speed = 0;
bounce_count = 2;

depth = -9999;