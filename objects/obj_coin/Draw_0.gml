draw_self();

// 2. Busca o valor do dinheiro lá no manager
var current_money = 0;
if (instance_exists(obj_game_manager)) {
    current_money = obj_game_manager.player_money;
}

// 3. Configura a fonte e a cor
draw_set_color(c_white); // Mude para a cor que preferir (ex: c_yellow)
// draw_set_font(fnt_sua_fonte); // Descomente e coloque sua fonte pixel art aqui se tiver uma

// 4. Alinhamento perfeito
draw_set_halign(fa_left);   // O texto cresce para a direita
draw_set_valign(fa_middle); // Centraliza a altura do texto com o meio da moeda

// 5. Desenha o texto à direita
var margin = 12; // Ajuste esse valor de acordo com a largura do seu sprite
draw_text(x + margin, y, string(current_money));

// 6. Reseta o alinhamento (boa prática para não quebrar outros textos do jogo)
draw_set_halign(fa_left);
draw_set_valign(fa_top);