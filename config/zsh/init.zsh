# so i can press ctrl+s without the terminal freezing
stty -ixon

ansi() {
    local ESC="\x1b"
    local RESET="${ESC}[0m"
    local seq_start="${ESC}[50G"

    # Helper function to print a row of color/style codes
    print_ansi_seq() {
        local arr=("$@")
        for c in "${arr[@]}"; do
            echo -en "${ESC}[${c}m${c}${RESET} "
        done
        echo -e "${ESC}[1D'"
    }

    echo -e "${ESC}[1m--- ANSI Terminal Capability Showcase ---${RESET}\n"
    echo -e "${seq_start}' 0  1  2  3  4  5  6  7'"

    # 1. Standard Colors
    local BG_COLORS=(40 41 42 43 44 45 46 47)
    echo -en "${ESC}[1mBackground Colors (40-47):${RESET}${seq_start}'"
    print_ansi_seq "${BG_COLORS[@]}"

    local FG_COLORS=(30 31 32 33 34 35 36 37)
    echo -en "${ESC}[1mForeground Colors (30-37):${RESET}${seq_start}'"
    print_ansi_seq "${FG_COLORS[@]}"

    local FG_COLORS_LIGHT=(90 91 92 93 94 95 96 97)
    echo -en "${ESC}[1mLight Foreground (90-97):${RESET}${seq_start}'"
    print_ansi_seq "${FG_COLORS_LIGHT[@]}"

    echo -e "\n${ESC}[1mText Styles:${RESET}"
    echo -e "  ${ESC}[1mBold${RESET} (1)  ${ESC}[2mDim${RESET} (2)  ${ESC}[3mItalic${RESET} (3)  ${ESC}[4mUnderline${RESET} (4)  ${ESC}[7mInverse${RESET} (7)  ${ESC}[9mStrikethrough${RESET} (9)"

    # 2. 256 Color Mode (8-bit)
    echo -e "\n${ESC}[1m256 Color Mode (Sample):${RESET}"
    echo -en "  "
    for i in {16..21..1}; do
        echo -en "${ESC}[38;5;${i}mColor $i ${RESET} "
    done
    echo -e "... etc."

    # 3. Truecolor Mode (24-bit RGB)
    echo -e "\n${ESC}[1mTruecolor (RGB) Gradient Test:${RESET}"
    echo -en "  "
    for i in {0..255..20}; do
        # Generates a purple-to-blue gradient
        echo -en "${ESC}[48;2;${i};50;200m ${RESET}"
    done
    echo -e " (If smooth, your terminal supports Truecolor)"
	echo -e "\n${ESC}[1mForeground: ESC[38;2;{r};{g};{b}m${ESC}[0m"
	echo -e "${ESC}[1mBackground: ESC[48;2;{r};{g};{b}m${ESC}[0m"

	# 4. Cursor Control Reference
	echo -e "\n${ESC}[1mCursor Control Sequences:${RESET}"
	
	# Define a helper to print table-style rows
	print_cursor_row() {
		printf "  ${ESC}[33m%-20s${RESET} | %s\n" "$1" "$2"
	}

	print_cursor_row "ESC[H" "Moves cursor to home position (0, 0)"
	print_cursor_row "ESC[{n};{m}H" "Moves cursor to line n, column m"
	print_cursor_row "ESC[#A" "Moves cursor UP # lines"
	print_cursor_row "ESC[#B" "Moves cursor DOWN # lines"
	print_cursor_row "ESC[#C" "Moves cursor RIGHT # columns"
	print_cursor_row "ESC[#D" "Moves cursor LEFT # columns"
	print_cursor_row "ESC[#E" "Moves to beginning of next line, # lines down"
	print_cursor_row "ESC[#F" "Moves to beginning of prev line, # lines up"
	print_cursor_row "ESC[#G" "Moves cursor to specific column #"
	print_cursor_row "ESC[6n" "Reports cursor position (as ESC[#;#R)"
	print_cursor_row "ESC M" "Moves cursor up one line (scrolling if needed)"
	print_cursor_row "ESC 7 / ESC 8" "Save / Restore cursor position (DEC)"
	print_cursor_row "ESC[s / ESC[u" "Save / Restore cursor position (SCO)"
	print_cursor_row "ESC[?25l / h" "Make cursor Invisible / Visible"

	echo -e "\n${ESC}[1mErase Functions:${RESET}"
	print_cursor_row "ESC[2J" "Erase entire screen"
	print_cursor_row "ESC[K"  "Erase from cursor to end of line"

	echo -e "\n${ESC}[1mMore info: ${ESC}[21;4mhttps://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797${RESET}"
}

source "$HOME/.config/zsh/alias.zsh"
