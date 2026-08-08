if (keyboard_check_pressed(vk_space)) {
    
    audio_play_sound(snd_start, 10, false);
	obj_btn_play.sprite_index = spr_btn_play_pressed;
    
    if (!instance_exists(obj_transition)) {
        audio_stop_sound(snd_song); 
        
        var _tran = instance_create_layer(0, 0, "Instances", obj_transition);
        _tran.target_room = rm_game;
    }
}