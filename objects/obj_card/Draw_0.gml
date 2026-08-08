var is_selected = false;
if (instance_exists(obj_game_manager)) {
    is_selected = (obj_game_manager.selected_card_index == card_index);
}

// 2. Define as cores separadamente
// A carta fica com a cor normal (c_white) se selecionada, e cinza se não
var sprite_color = is_selected ? c_white : make_color_rgb(100, 100, 100);

// O texto fica amarelo se selecionado, e cinza se não
var text_color = is_selected ? c_yellow : make_color_rgb(100, 100, 100);

// 3. Desenha a carta usando a sprite_color
if (card_sprite != -1) {
    draw_sprite_ext(card_sprite, 0, x, y, 1, 1, 0, sprite_color, 1);
}

// 4. Configura e desenha os textos
draw_set_halign(fa_center);
draw_set_valign(fa_top);

// Aplica a text_color apenas para os títulos e descrições
draw_set_color(text_color); 

var text_y_offset = (sprite_height / 2) + 30; 

draw_text(x, y + text_y_offset, card_title);
draw_text_transformed(x, y + text_y_offset + 10, card_desc, 0.8, 0.8, 0);

draw_set_halign(fa_left);

// Desenha o preço sempre em amarelo
draw_set_color(c_yellow); 
draw_text(x, y + text_y_offset + 25, "$" + string(card_price));
draw_set_color(c_white); // Reseta para branco por segurança