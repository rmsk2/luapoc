require(test_dir .. "tools")

word_len_addr = de_ref(load_address + 3)
guessed_char_addr = de_ref(load_address + 7)
guessed_word_addr = de_ref(load_address + 5)

function arrange()
    write_byte(word_len_addr, 4)
    set_memory(word_len_addr + 1, "41424142")
    set_memory(guessed_word_addr, "4142415f")
end

function assert()
    local equal_up_to = get_yreg()
    if equal_up_to ~= 3 then
        return false, "Evaluation not correct"
    end
    
    return true, ""
 end