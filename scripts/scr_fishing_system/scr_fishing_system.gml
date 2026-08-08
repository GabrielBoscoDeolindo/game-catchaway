function start_fishing_minigame() {
    target_sequence = [];
    current_key_index = 0;
    var possible_keys = ["W", "A", "S", "D"];
    
    if (instance_exists(obj_emote)) {
        obj_emote.is_active = false;
        obj_emote.visible = false;
    }
    current_glove_shield = buff_ignore_first_error;
    

    var fish_pool = [];
    
    switch (current_wave) {
        case 1: // Max 10: 100% Tier 1
            fish_pool = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]; 
            break;
        case 2: // Max 12: 20% T1, 70% T2, 10% T3
            fish_pool = [1, 1, 2, 2, 2, 2, 2, 2, 2, 3]; 
            break;
        case 3: // Max 14: 20% T2, 70% T3, 10% T4
            fish_pool = [2, 2, 3, 3, 3, 3, 3, 3, 3, 4]; 
            break;
        case 4: // Max 16: 20% T3, 70% T4, 10% T5
            fish_pool = [3, 3, 4, 4, 4, 4, 4, 4, 4, 5]; 
            break;
        case 5: // Max 18: 20% T4, 70% T5, 10% T6
            fish_pool = [4, 4, 5, 5, 5, 5, 5, 5, 5, 6]; 
            break;
        default: // Max 20 (Wave 6 em diante): 70% T5, 30% T6
            fish_pool = [5, 5, 5, 5, 5, 5, 5, 6, 6, 6]; 
            break;
    }
    
    // Sorteia 1 peixe da sacola
    var random_pool_index = irandom(array_length(fish_pool) - 1);
    current_fish_tier = fish_pool[random_pool_index];
    
    // --- BUFF: ISCA NEON ---
    // Como a chance base já está na sacola, a isca só adiciona uma chance extra direta
    if (random(100) <= buff_rare_chance && current_fish_tier < 6) {
        current_fish_tier += 1;
    }

    // --- 2. STATUS BASEADOS NO PEIXE ---
    var time_per_key = 0;
    
    switch (current_fish_tier) {
        case 1: sequence_length = 3; time_per_key = 1.20; break;
        case 2: sequence_length = 4; time_per_key = 1.00; break;
        case 3: sequence_length = 5; time_per_key = 0.85; break;
        case 4: sequence_length = 6; time_per_key = 0.65; break;
        case 5: sequence_length = 7; time_per_key = 0.50; break;
        case 6: sequence_length = 8; time_per_key = 0.40; break; 
    }
    
    // --- BUFF: CAFÉ ---
    time_per_key += buff_extra_time;
    
    // --- 3. GERA A SEQUÊNCIA ---
    for (var i = 0; i < sequence_length; i++) {
        var random_index = irandom(array_length(possible_keys) - 1);
        array_push(target_sequence, possible_keys[random_index]);
    }
    
    // --- 4. CONFIGURA O TEMPO ---
    max_timer = 60 * (sequence_length * time_per_key);
    current_timer = max_timer;
}

function apply_strike_penalty() {
    audio_play_sound(snd_wrong, 10, false);
    
    var cam = view_camera[0];
    cam_base_x = camera_get_view_x(cam);
    cam_base_y = camera_get_view_y(cam);
    
    if (water_lives > 0) {
        water_lives -= 1;
        shake_intensity = 3;
        
        if (instance_exists(obj_lifebar_water)) {
            if (water_lives == 1) {
                obj_lifebar_water.sprite_index = spr_lifebar_water_50;
            } else if (water_lives <= 0) {
                obj_lifebar_water.visible = false;
                
                if (instance_exists(obj_water)) {
                    obj_water.visible = false;
                }
            }
        }
    } 
    else {
        current_lives -= 1;
        shake_intensity = 6; 
        
        if (instance_exists(obj_player)) {
            obj_player.flash_timer = 15; 
        }
    }
    
    // Reseta o jogador para a pose inicial
    if (instance_exists(obj_player)) {
        obj_player.sprite_index = spr_player_idle; 
    }
    
    // Mostra o emote de erro/raiva
    if (instance_exists(obj_emote)) {
        obj_emote.sprite_index = spr_emote_angry; 
        obj_emote.is_active = true;
        obj_emote.visible = true;
        obj_emote.image_index = 0;
        obj_emote.image_speed = 1;
    }
    
    // Limpa a sequência atual para cancelar o peixe
    sequence_length = 0;
    combo_streak = 0; 
    
    // Verifica Game Over
    if (current_lives <= 0) {
        game_state = 5;
        audio_stop_sound(snd_song);
    } else {
        alarm[0] = 120; // Tempo antes de vir o próximo peixe
    }
}