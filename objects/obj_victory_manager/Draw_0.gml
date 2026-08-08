draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Certifique-se de usar a fonte que você já tem no projeto
draw_set_font(fnt_sign); 

// --- TEXTO DE CIMA (VITÓRIA) ---
draw_set_color(c_yellow);
// room_height * 0.3 coloca o texto exatamente nos 30% superiores da tela
draw_text_transformed(room_width / 2, room_height * 0.3, "Thanks for playing!", 1.5, 1.5, 0);

// --- TEXTO DE BAIXO (INSTRUÇÃO) ---
draw_set_color(c_white);

// Cria um efeito de piscar suave usando o tempo do jogo
var blink_alpha = abs(sin(current_time / 300));
draw_set_alpha(blink_alpha);

// room_height * 0.7 coloca o texto na parte de baixo
draw_text(room_width / 2, room_height * 0.7, "press esc to return to main menu");

// Reseta o alpha e o alinhamento para não bugar o resto do jogo
draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);