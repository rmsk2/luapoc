require(test_dir .. "tools")

word_len_addr = de_ref(load_address + 3)
guessed_char_addr = de_ref(load_address + 7)
guessed_word_addr = de_ref(load_address + 5)

function arrange()
    write_byte(word_len_addr, 4)
    set_memory(word_len_addr + 1, "41424142")
    write_byte(guessed_char_addr, 0x43)
end

function assert()
    local state_after = get_memory(guessed_word_addr, 4)
    if state_after ~= "5f5f5f5f" then
        return false, "Evaluation not correct"
    end

    if get_xreg() ~= 0 then
        return false, "Wrong number of correct guesses"
    end

    return true, ""
 end