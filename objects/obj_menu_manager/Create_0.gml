if (!audio_is_playing(snd_song)) {
    audio_play_sound(snd_song, 5, true);
}

window_set_cursor(cr_none);