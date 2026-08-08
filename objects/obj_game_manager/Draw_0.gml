//=========================================
// 1. INTERFACE DE PESCA (ESTADO 0)
//=========================================
if (instance_exists(obj_player) && sequence_length > 0) {
    var total_keys_width = sequence_length * key_width;
    var total_spacing = (sequence_length - 1) * spacing;
    var box_width = pad_left + total_keys_width + total_spacing + pad_right;
    var box_left = obj_player.x - (box_width / 2);
    var box_top = obj_player.y - 40;  
    var cam = view_camera[0];
    var cam_x = camera_get_view_x(cam);
    var cam_w = camera_get_view_width(cam);
    var margin = 5;   
    box_left = clamp(box_left, cam_x + margin, (cam_x + cam_w) - box_width - margin);
    var ui_shake = current_key_index * 0.1; 
    var offset_x = random_range(-ui_shake, ui_shake);
    var offset_y = random_range(-ui_shake, ui_shake);
    box_left += offset_x;
    box_top += offset_y;
    
    // 3. Draw the background box
    draw_sprite_stretched(spr_box, 0, box_left, box_top, box_width, box_height);
    
    // 4. Calculate the center point for the FIRST key
    var current_x = box_left + pad_left + (key_width / 2);
    var current_y = box_top + pad_top + (key_height / 2);
    
    // 5. Draw the keys
    for (var i = 0; i < sequence_length; i++) {
        var key_letter = target_sequence[i];
        var spr_to_draw = -1;
        
        var is_hit = (i < current_key_index);
        
        // Verifica se ESSA é a tecla que acabamos de errar
        var is_error = (i == error_key_index && error_timer > 0);
        
        if (is_error) {
            // Se for a tecla errada e o timer estiver ativo, desenha o erro!
            switch(key_letter) {
                case "W": spr_to_draw = spr_key_w_error; break;
                case "A": spr_to_draw = spr_key_a_error; break;
                case "S": spr_to_draw = spr_key_s_error; break;
                case "D": spr_to_draw = spr_key_d_error; break;
            }
        } else {
            // Comportamento normal (já acertada ou ainda esperando)
            switch(key_letter) {
                case "W": spr_to_draw = is_hit ? spr_key_w_down : spr_key_w_up; break;
                case "A": spr_to_draw = is_hit ? spr_key_a_down : spr_key_a_up; break;
                case "S": spr_to_draw = is_hit ? spr_key_s_down : spr_key_s_up; break;
                case "D": spr_to_draw = is_hit ? spr_key_d_down : spr_key_d_up; break;
            }
        }
        
        if (spr_to_draw != -1) {
            // Se a tecla estiver em estado de erro ou já pressionada, empurramos 1 pixel pra baixo (juice)
            var y_offset = (is_hit || is_error) ? 1 : 0;
            draw_sprite(spr_to_draw, 0, current_x, current_y + y_offset);
        }
        
        current_x += (key_width + spacing);
    }
    
    // 6. Desenhar a Barra de Tempo
    var bar_y = box_top + box_height + 1; 
    var bar_height = 2;                   
    
    var time_ratio = max(0, current_timer / max_timer); 
    var current_bar_width = box_width * time_ratio;
    
    draw_set_color(make_color_rgb(100, 0, 0)); 
    draw_rectangle(box_left, bar_y, box_left + box_width, bar_y + bar_height, false);
    
    draw_set_color(c_red);
    draw_rectangle(box_left, bar_y, box_left + current_bar_width, bar_y + bar_height, false);
    
    draw_set_color(c_white);
}

//=========================================
// 2. INTERFACE DA LOJA (ESTADO 2)
//=========================================
if (game_state == 2) {
    draw_set_color(c_black);
    draw_set_alpha(0.6); 
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0); 
    
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    
    draw_text(room_width / 2, 50, "CHOOSE AN UPGRADE!"); 
    draw_set_font(fnt_sign); 
    draw_text(room_width / 2, room_height - 30, "Press SPACEBAR to skip");
    draw_set_halign(fa_left); 
}

//=========================================
// ESTADO 3: COUNTDOWN INICIAL (DRAW)
//=========================================
if (game_state == 3) {
    
    // 1. Escurece a tela um pouco
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
    
    // 2. Decide qual texto mostrar baseado nos frames restantes
    var text_to_draw = "";
    if (countdown_timer > 180) {
        text_to_draw = "3";
    } else if (countdown_timer > 120) {
        text_to_draw = "2";
    } else if (countdown_timer > 60) {
        text_to_draw = "1";
    } else {
        text_to_draw = "GO!";
    }
    
    // 3. Desenha o texto grandão no meio da tela
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle); // Centraliza no eixo Y também
    
    // Se você tiver uma fonte maior, use aqui. Se não, a fnt_sign serve!
    draw_set_font(fnt_sign); 
    
    draw_text(room_width / 2, room_height / 2, text_to_draw);
    
    // Reseta os alinhamentos para não bugar outras partes do jogo
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

//=========================================
// ESTADO 4: CONSTRUINDO A VARA INICIAL
//=========================================
if (game_state == 4) {
    draw_build_state();
}

//=========================================
// ESTADO 5: TELA DE GAME OVER
//=========================================
if (game_state == 5) {
    
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0); 


    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_sign); 


    draw_set_color(c_red);
    draw_text_transformed(room_width / 2, room_height * 0.3, "GAME OVER!", 1.5, 1.5, 0);


    draw_set_color(c_white);
    var blink_alpha = abs(sin(current_time / 300));
    draw_set_alpha(blink_alpha);
    draw_text(room_width / 2, room_height * 0.6, "press spacebar to restart");


    draw_set_alpha(1.0); 
    draw_text(room_width / 2, room_height * 0.8, "press esc to return to main menu");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}