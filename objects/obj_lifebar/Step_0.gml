if (instance_exists(obj_game_manager)) {
    
    switch (obj_game_manager.current_lives) {
        case 3: 
            sprite_index = spr_lifebar_100; 
            break;
        case 2: 
            sprite_index = spr_lifebar_66; 
            break;
        case 1: 
            sprite_index = spr_lifebar_33; 
            break;
        default: 
            sprite_index = spr_lifebar_0; 
            break;
    }
}