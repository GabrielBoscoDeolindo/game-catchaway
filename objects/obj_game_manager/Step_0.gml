//=========================================
// ESTADO 4: CONSTRUINDO A VARA INICIAL
//=========================================
if (game_state == 4) {
    manage_build_state();
}

//=========================================
// ESTADO 3: COUNTDOWN INICIAL
//=========================================
else if (game_state == 3) {
    countdown_timer -= 1;
    
    if (countdown_timer <= 0) {
        game_state = 0; 
        start_fishing_minigame(); 
    }
}

//=========================================
// ESTADO 0: PESCANDO
//=========================================
else if (game_state == 0) {

    if (error_timer > 0) {
        error_timer -= 1;
        if (error_timer <= 0) {
            error_key_index = -1;
        }
    }

    if (sequence_length > 0) {
        current_timer -= 1;
        
        // --- CONDIÇÃO DE FALHA 1: TEMPO ACABOU ---
        if (current_timer <= 0) {
            apply_strike_penalty(); 
        } 
        else {
            // Só verifica o input se o tempo ainda não acabou
            var expected_key = target_sequence[current_key_index];
            var key_pressed = "";

            // Verifica qual tecla foi apertada neste exato frame
            if (keyboard_check_pressed(ord("W"))) key_pressed = "W";
            else if (keyboard_check_pressed(ord("A"))) key_pressed = "A";
            else if (keyboard_check_pressed(ord("S"))) key_pressed = "S";
            else if (keyboard_check_pressed(ord("D"))) key_pressed = "D";
            
            // Se alguma das 4 teclas foi pressionada
            if (key_pressed != "") {
                if (key_pressed == expected_key) {
                    
                    // --- ACERTOU A TECLA ---
                    current_key_index += 1;
                    
                    // AUDIO JUICE: PITCH ESCALONADO
                    var progress = current_key_index / sequence_length; 
                    var calc_pitch = lerp(1.0, 1.6, progress);
                    var snd_click = audio_play_sound(snd_fish_click, 8, false);
                    audio_sound_pitch(snd_click, calc_pitch);
                    
                    // ANIMAÇÃO DO JOGADOR
                    if (instance_exists(obj_player)) {
                        if (current_key_index == 1) {
                            obj_player.sprite_index = spr_fishing_1;
                        } else if (current_key_index == 2) {
                            obj_player.sprite_index = spr_fishing_2;
                        } else if (current_key_index >= 3) {
                            obj_player.sprite_index = spr_fishing_3;
                        }
                    }
                    
                    // --- COMPLETOU A SEQUÊNCIA (PESCOU) ---
                    if (current_key_index >= sequence_length) {
                        
                        // 1. PONTUAÇÃO E COMBO
                        combo_streak += 1;
                        var points_earned = (sequence_length * 10) * combo_streak;
                        player_score += points_earned;
                        
                        // (Bloco de dificuldade por combo removido daqui!)
                        
                        sequence_length = 0; 
                        
                        // 3. INSTANCIA O PEIXE COM VISUAL E VALOR
                        var spawn_x = obj_player.x; 
                        var spawn_y = obj_player.y;

                        if (instance_exists(obj_fish_spawn)) {
                            spawn_x = obj_fish_spawn.x;
                            spawn_y = obj_fish_spawn.y;
                        }

                        var inst_fish = instance_create_layer(spawn_x, spawn_y, "Instances", obj_fish);
                        audio_play_sound(snd_pull, 10, 0);
                        inst_fish.fish_tier = current_fish_tier; 
                        
                        switch (current_fish_tier) {
                            case 1: inst_fish.sprite_index = spr_fish_1; inst_fish.fish_value = 10; break;
                            case 2: inst_fish.sprite_index = spr_fish_2; inst_fish.fish_value = 25; break;
                            case 3: inst_fish.sprite_index = spr_fish_3; inst_fish.fish_value = 50; break;
                            case 4: inst_fish.sprite_index = spr_fish_4; inst_fish.fish_value = 95; break;
                            case 5: inst_fish.sprite_index = spr_fish_5; inst_fish.fish_value = 135; break;
                            case 6: inst_fish.sprite_index = spr_fish_6; inst_fish.fish_value = 195; break;
                        }
                        
                        // 4. GATILHO DE MUDANÇA DE WAVE
                        var fish_count = instance_number(obj_fish);

                        if (fish_count >= max_fish_per_wave) {
                            // Muda de estado e inicia o timer de pagamento
                            game_state = 1;
                            payment_timer = 300; 
                            
                            if (instance_exists(obj_emote)) {
                                obj_emote.sprite_index = spr_emote_heart; 
                                obj_emote.is_active = true;
                                obj_emote.visible = true;
                                obj_emote.image_index = 0; 
                                obj_emote.image_speed = 1; 
                            }
                        } else {
                            alarm[0] = 30;
                        }
                    }
                } else {
                    if (current_glove_shield > 0) {
                        current_glove_shield = 0;
                    } else {
                        audio_play_sound(snd_wrong, 10, false);
                        shake_intensity = 3; 
                        current_timer -= 30; 
                        error_key_index = current_key_index;
                        error_timer = 15;
                        
                        // LÓGICA DO COMBO E DO RÁDIO
                        if (!has_radio) {
                            combo_streak = 0; 
                        }
                    }
                }
            }
        }
    }
}

//=========================================
// ESTADO 1: ANIMAÇÃO DE PAGAMENTO E ECONOMIA
//=========================================
else if (game_state == 1) {
    
    if (payment_timer > 0) {
        payment_timer -= 1; 
    } else {
        
        var wave_money = 0; 
        
        // 1. Faz a contabilidade e esvazia a caixa
        with (obj_fish) {
            wave_money += fish_value; 
            instance_destroy();
        }
        
        // 2. Paga o jogador (Buff da License aplicado)
        player_money += (wave_money * buff_fish_value_mult);
        
        // 3. Esconde o emote
        if (instance_exists(obj_emote)) {
            obj_emote.is_active = false;
            obj_emote.visible = false;
        }
        
        // 4. Aumenta a dificuldade da próxima wave!
        current_wave += 1;
        var buff_box_bonus = 0;        
        
        // A matemática da caixa agora trava no limite de 20!
        max_fish_per_wave = min(20, base_max_fish + ((current_wave - 1) * 2) + buff_box_bonus);
        
        game_state = 2;
    }
}

//=========================================
// ESTADO 2: LOJA / ESCOLHA DE CARTAS
//=========================================
else if (game_state == 2) {
    manage_shop_state();
}

//=========================================
// ESTADO 5: GAME OVER
//=========================================
else if (game_state == 5) {
    
    // Reinicia o jogo (Reseta a room atual)
    if (keyboard_check_pressed(vk_space)) {
        room_restart(); 
    }

    // Volta para o menu principal
    if (keyboard_check_pressed(vk_escape)) {
        room_goto(rm_menu);
    }
}