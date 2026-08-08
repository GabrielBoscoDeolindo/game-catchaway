draw_self();
var current_fish = instance_number(obj_fish);
var max_fish = 10;

if (instance_exists(obj_game_manager)) {
    max_fish = obj_game_manager.max_fish_per_wave;
}

draw_set_font(fnt_sign);
draw_set_color(c_black);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(x + 5, y + 2.5, string(current_fish) + "/" + string(max_fish));

draw_set_halign(fa_left);
draw_set_valign(fa_top);