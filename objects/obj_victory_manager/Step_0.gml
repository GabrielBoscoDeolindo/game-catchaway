// --- RETORNAR AO MENU ---
if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_menu);
}

// --- ANIMAÇÃO DE FLUTUAR (1 SEGUNDO = 60 FRAMES) ---
bob_timer += 1;

if (bob_timer >= 60) {
    bob_timer = 0;
    bob_dir *= -1; // Inverte a direção (1 vira -1, e vice-versa)

    // Move o jogador 1 pixel
    if (instance_exists(obj_player_victory)) {
        obj_player_victory.y += bob_dir;
    }
    
    // Move o gato 1 pixel
    if (instance_exists(obj_cat)) {
        obj_cat.y += bob_dir;
    }
}