-- *********************************
-- This script simulates a primitive terminal which can be 
-- used by the emulated machine language program running
-- in 6502profiler.
-- *********************************
require("io")
require("math")
require("string")

TRAP_INPUT = 0
TRAP_OUTPUT = 1
STR_BASE = 0x0090

TRAP_TABLE = {}

function de_ref(ptr_addr)
    local hi_addr = read_byte(ptr_addr + 1)
    local lo_addr = read_byte(ptr_addr)
    
    return hi_addr * 256 + lo_addr
end

function trap(trap_code)
    trap_func = TRAP_TABLE[trap_code]

    if trap_func ~= nil then
        trap_func(trap_code)
    else
        error("Unknown trap")
    end
end

function init()
    log_file = io.open("hangman_log.txt", "wb+")
end

function cleanup()
    print("Closing log file")
    log_file:close()
end

-- *********************************
-- This function clears the screen using an appropriate escape sequence.
-- *********************************
function clear_screen(trap_code)
    io.write("\027[H\027[2J")
end

-- *********************************
-- This function determines the address to which STR_BASE and STR_BASE +1 
-- point. After that it prints the bytes of this and the following addresses.
-- The number of bytes is specified by the value of the x register.
-- *********************************
function write_string()
    local i = 0
    local out_addr = de_ref(STR_BASE)
    local stop = false
    local byte_str
    local to_print = ""
    local buffer_len = get_xreg()

    if buffer_len < 1 then
        return
    end

    for i = 0, buffer_len - 1, 1 do
        byte_str = read_byte(out_addr + i)
        io.write(string.char(byte_str))
    end    
end

-- *********************************
-- This function determines the address to which STR_BASE and STR_BASE +1 
-- point. After that it logs the bytes of this and the following addresses. to
-- the log file opened in the init() function.
-- The number of bytes is specified by the value of the x register.
-- *********************************
function log_string()
    local i = 0
    local out_addr = de_ref(STR_BASE)
    local stop = false
    local byte_str
    local to_print = ""
    local buffer_len = get_xreg()

    if buffer_len < 1 then
        return
    end

    log_file:write(ident .. ": ")

    for i = 0, buffer_len - 1, 1 do
        byte_str = read_byte(out_addr + i)
        log_file:write(string.char(byte_str))
    end

    log_file:write("\n")
end

-- *********************************
-- This function lets the user enter a string. This string is stored at the
-- address to which STR_BASE and STR_BASE +1 point. Upon entry the x register
-- specifies the maximum number of bytes the buffer can hold. Upon return the
-- x register is set to the length of the entered string.
-- *********************************
function read_string()
    local buffer_len = get_xreg()

    if buffer_len <= 0 then
        set_xreg(0)
        return
    end

    local in_addr = de_ref(STR_BASE)    
    local in_str = io.read()
    local i = 1
    local end_pos = math.min(buffer_len, string.len(in_str))

    while i <= end_pos do
        local str_byte = string.byte(in_str, i)
        write_byte(in_addr + i - 1, str_byte)
        i = i + 1
    end

    set_xreg(end_pos)
end

TRAP_TABLE[0] = read_string
TRAP_TABLE[1] = write_string
TRAP_TABLE[2] = clear_screen
TRAP_TABLE[3] = log_string


init()