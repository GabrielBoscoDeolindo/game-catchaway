function init_card_database() {
    card_database = [
        { card_id: "snack", sprite: spr_card_1, title: "Snack", desc: "+1 Life", price: 50 },
        { card_id: "coffee", sprite: spr_card_2, title: "Coffee", desc: "+ Catch Time", price: 80 },
        
        { card_id: "stone_fire", sprite: spr_card_7, title: "Stone Fire", desc: "Cozy vibes", price: 100 },
        { card_id: "radio", sprite: spr_card_8, title: "Radio", desc: "Relaxing music", price: 150 },

        { card_id: "neon_bait", sprite: spr_card_3, title: "Reinforce Line", desc: "+ Rare Fish", price: 180 },
        { card_id: "bait", sprite: spr_card_4, title: "Bait", desc: "Ignore 1st typo", price: 200 },
        
        { card_id: "coupon", sprite: spr_card_5, title: "Coupon", desc: "25% OFF Next Shop", price: 150 },
        
        { card_id: "water", sprite: spr_card_9, title: "Fresh Water", desc: "+2 Extra Lives", price: 280 },
        { card_id: "license", sprite: spr_card_6, title: "License", desc: "Fish value +20%", price: 350 },
        
        { card_id: "cat", sprite: spr_card_10, title: "Stray Cat", desc: "She's cute", price: 200 },
        { card_id: "sail", sprite: spr_card_11, title: "Boat Sail", desc: "Escape! (WIN)", price: 2500 }
    ];
}

function remove_card_from_pool(id_para_remover) {
    for (var i = 0; i < array_length(card_database); i++) {
        if (card_database[i].card_id == id_para_remover) {
            array_delete(card_database, i, 1);
            break;
        }
    }
}

function apply_card_effect(id_da_carta) {
    switch(id_da_carta) {
        
        case "snack":
            if (current_lives < max_lives) current_lives += 1;
            audio_play_sound(snd_heal, 10, 0);
            break;
            
        case "coffee":
            buff_extra_time += 0.05; 
            audio_play_sound(snd_money, 10, 0);
            break;
            
        case "neon_bait":
            buff_rare_chance += 15;
            audio_play_sound(snd_money, 10, 0);
            break;
            
        case "bait":
            buff_ignore_first_error = 1;
			remove_card_from_pool("bait");
            audio_play_sound(snd_money, 10, 0);
            break;
            
        case "license":
            buff_fish_value_mult += 0.20;
            audio_play_sound(snd_money, 10, 0);
            break;
            
        case "coupon":
            has_discount_coupon = true; 
            remove_card_from_pool("coupon");
            audio_play_sound(snd_money, 10, 0);
            break;
            
        case "stone_fire":
            if (instance_exists(obj_campfire)) {
                obj_campfire.visible = true;
                audio_play_sound(snd_money, 10, 0);
            }
            remove_card_from_pool("stone_fire");
            break;
            
        case "radio":
            has_radio = true;
            
            if (instance_exists(obj_radio)) {
                obj_radio.visible = true;
            }
            
            audio_play_sound(snd_money, 10, 0);
            remove_card_from_pool("radio");
            break;
		
        case "water":
            water_lives = 2;
            
            if (instance_exists(obj_water)) {
                obj_water.visible = true;
            }
            
            if (instance_exists(obj_lifebar_water)) {
                obj_lifebar_water.visible = true;
            }
            
            audio_play_sound(snd_heal, 10, 0); 
            remove_card_from_pool("water");
            break;
        
        case "cat":
            if (instance_exists(obj_cat)) {
                obj_cat.visible = true;
                audio_play_sound(snd_meow, 10, 0);
            }
            remove_card_from_pool("cat");
            break;
        
        case "sail":
            room_goto(rm_victory);
			audio_stop_all();
            break;
    }
}

function manage_shop_state() {
    if (!shop_is_open) {
        var shuffled_cards = array_shuffle(card_database);
        

        if (is_first_shop) {
            is_first_shop = false;
            
            for (var j = 0; j < array_length(shuffled_cards); j++) {
                if (shuffled_cards[j].card_id == "sail") {
                    
                    if (j >= 3) {
                        var temp = shuffled_cards[2];
                        shuffled_cards[2] = shuffled_cards[j];
                        shuffled_cards[j] = temp;
                    }
                    break;
                }
            }
        }

        
        var cam = view_camera[0];
        var cam_x = camera_get_view_x(cam);
        var cam_y = camera_get_view_y(cam);
        var cam_w = camera_get_view_width(cam);
        var cam_h = camera_get_view_height(cam);
        
        var center_x = cam_x + (cam_w / 2);
        var center_y = cam_y + (cam_h / 2);
        var card_spacing = 64; 
        
        for (var i = 0; i < 3; i++) {
            var spawn_x = center_x + ((i - 1) * card_spacing); 
            var inst_card = instance_create_depth(spawn_x, center_y, -9999, obj_card);
            
            inst_card.card_sprite = shuffled_cards[i].sprite;
            inst_card.card_title = shuffled_cards[i].title;
            inst_card.card_desc = shuffled_cards[i].desc;
            inst_card.card_id = shuffled_cards[i].card_id;
            
            if (has_discount_coupon) {
                inst_card.card_price = round(shuffled_cards[i].price * 0.75); 
            } else {
                inst_card.card_price = shuffled_cards[i].price;
            }
            
            inst_card.card_index = i;        
            inst_card.base_y = center_y;     
        }
        
        selected_card_index = 1; 
        shop_is_open = true; 
    } 
    else {
        if (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left)) {
            audio_play_sound(snd_button, 10, 0);
            selected_card_index -= 1;
            if (selected_card_index < 0) selected_card_index = 2;
        }
        
        if (keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right)) {
            audio_play_sound(snd_button, 10, 0);
            selected_card_index += 1;
            if (selected_card_index > 2) selected_card_index = 0;
        }
        
        if (keyboard_check_pressed(vk_enter)) {
            
            var chosen_card = noone;
            with (obj_card) {
                if (card_index == other.selected_card_index) {
                    chosen_card = id; 
                }
            }
            
            if (chosen_card != noone) {
                if (player_money >= chosen_card.card_price) {
                    
                    player_money -= chosen_card.card_price; 
                    
                    if (has_discount_coupon) {
                        has_discount_coupon = false; // Gasta o cupom
                    }
                    
                    apply_card_effect(chosen_card.card_id);
                    
                    with (obj_card) {
                        instance_destroy();
                    }
                    
                    shop_is_open = false;
                    game_state = 0; 
                    alarm[0] = 60; 
                    
                } else {
                    audio_play_sound(snd_no_money, 10, 0);
                }
            }
        }
        
        if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_escape)) {
            
            if (has_discount_coupon) {
                has_discount_coupon = false;
            }
            
            with (obj_card) {
                instance_destroy();
            }
            shop_is_open = false;
            game_state = 0; 
            alarm[0] = 60;  
        }
    }
}