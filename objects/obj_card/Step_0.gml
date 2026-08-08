if (instance_exists(obj_game_manager)) {
    if (obj_game_manager.selected_card_index == card_index) {  
        float_timer += 0.08;   
        y = (base_y - 4) + round(sin(float_timer) * 2); 
        
    } else {
        y = base_y;
        float_timer = 0;
    }
}