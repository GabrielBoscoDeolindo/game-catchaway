randomise();
depth = -9998;
audio_play_sound(snd_song, 10, 1);

// =========================================
// STATUS DO JOGADOR E ECONOMIA
// =========================================
max_lives = 3;
water_lives = 0;
current_lives = max_lives;
player_score = 0;
player_money = 0;
combo_streak = 0; 
current_difficulty = 1;

// =========================================
// MÁQUINA DE ESTADOS E LOJA
// =========================================
game_state = 4;
build_sequence = ["A", "S", "W", "D"];
build_index = 0;
shop_is_open = false;
is_first_shop = true;
selected_card_index = 1; 
init_card_database(); 

// =========================================
// MECÂNICA DE PESCA (MINIGAME)
// =========================================
target_sequence = []; 
sequence_length = 0;
current_key_index = 0;

max_timer = 0;
current_timer = 0;
payment_timer = 0;
error_key_index = -1;
error_timer = 0;
countdown_timer = 240; 

// =========================================
// INTERFACE VISUAL (UI DA CAIXA)
// =========================================
key_width = 11;
key_height = 13;
pad_left = 7;
pad_right = 7; 
pad_top = 6;
pad_bottom = 9;
spacing = 7;
box_height = 28;

// =========================================
// BUFFS PASSIVOS (CARTAS)
// =========================================
buff_extra_time = 0;           
buff_rare_chance = 0;          
buff_ignore_first_error = 0;   
buff_fish_value_mult = 1.0;    

max_fish_per_wave = 10;        
current_glove_shield = 0;      

shake_intensity = 0;
cam_base_x = 0;
cam_base_y = 0;

current_wave = 1;
base_max_fish = 10;
max_fish_per_wave = base_max_fish;
has_discount_coupon = false;
has_radio = false;
