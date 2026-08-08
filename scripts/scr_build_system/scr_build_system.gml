function manage_build_state() {
    var expected_key = build_sequence[build_index];
    var key_pressed = "";

    if (keyboard_check_pressed(ord("W"))) key_pressed = "W";
    else if (keyboard_check_pressed(ord("A"))) key_pressed = "A";
    else if (keyboard_check_pressed(ord("S"))) key_pressed = "S";
    else if (keyboard_check_pressed(ord("D"))) key_pressed = "D";

    if (key_pressed != "") {
        if (key_pressed == expected_key) {
            build_index += 1;
            audio_play_sound(snd_button, 10, false); 
            shake_intensity = 2; 
            
            if (build_index >= array_length(build_sequence)) {
                game_state = 3; 
                audio_play_sound(snd_countdown, 15, false);
			
                
                if (instance_exists(obj_player)) {
                    obj_player.sprite_index = spr_player_idle;
                }
            }
        } else {
            audio_play_sound(snd_wrong, 10, false);
            shake_intensity = 4;
        }
    }
}

function draw_build_state() {

    draw_set_color(c_black);
    draw_set_alpha(0.6); 
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_sign);
    
    draw_set_color(c_yellow);
    draw_text_transformed(room_width / 2, (room_height / 2) - 60, "You started with nothing, wanna fish?", 1.2, 1.2, 0);
    
    draw_set_color(c_white);
    draw_text(room_width / 2, (room_height / 2) - 35, "THEN BUILD YOUR ROD!");
    
    var total_build_length = array_length(build_sequence);
    var key_spacing = 20; 
    var start_x = (room_width / 2) - (((total_build_length - 1) * key_spacing) / 2);
    
    for (var i = 0; i < total_build_length; i++) {
        var key_letter = build_sequence[i];
        var spr_to_draw = -1;
        var is_hit = (i < build_index);
        
        switch(key_letter) {
            case "W": spr_to_draw = is_hit ? spr_key_w_down : spr_key_w_up; break;
            case "A": spr_to_draw = is_hit ? spr_key_a_down : spr_key_a_up; break;
            case "S": spr_to_draw = is_hit ? spr_key_s_down : spr_key_s_up; break;
            case "D": spr_to_draw = is_hit ? spr_key_d_down : spr_key_d_up; break;
        }
        
        if (spr_to_draw != -1) {
            var y_offset = is_hit ? 2 : 0;
            draw_sprite(spr_to_draw, 0, start_x + (i * key_spacing), (room_height / 2) + y_offset);
        }
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}