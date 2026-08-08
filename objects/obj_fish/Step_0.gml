switch(state)
{

case 0:
    progress += 1 / duration;
    if (progress > 1)
        progress = 1;
    var t = progress;
    x =
        sqr(1-t) * start_x +
        2*(1-t)*t*control_x +
        sqr(t)*end_x;

    y =
        sqr(1-t) * start_y +
        2*(1-t)*t*control_y +
        sqr(t)*end_y;

    image_angle += rot_speed;

    // desacelera a rotação
    rot_speed *= 0.98;

    if (progress >= 1)
    {
        state = 1;

        x = end_x;
        y = end_y;

        bounce = -12;
        bounce_speed = 2.8;

        image_angle = random_range(-15,15);
    }

break;


//=========================================
// QUIQUES
//=========================================
case 1:

    bounce += bounce_speed;
    bounce_speed += 0.8;

    if (bounce >= 0)
    {
        bounce = 0;

        bounce_count--;

        if (bounce_count > 0)
        {
            bounce_speed = random_range(1.8,2.3);
            bounce = -6;
        }
else
        {
            state = 2;
            depth = -y;
            image_angle = random_range(-10, 10); 
        }
    }

break;

case 2:
break;
}