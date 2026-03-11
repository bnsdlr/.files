; alt		!
; altgr		RAlt
; win		#
; right win 	RWin
; ctrl		^
; right ctrl	RCtrl
; no-recursion	$ (at beginning of line)

SetCapsLockState "AlwaysOff"

; Tap = Esc
; Hold = Ctrl (works with other keys)

CapsLock::
{
    if KeyWait("CapsLock", "T0.15") {
        Send "{Esc}"
        return
    }

    Send "{Ctrl down}"
    KeyWait "CapsLock"
    Send "{Ctrl up}"
}

; Option+U -> ¨ (it is only visible after pressing the next key...)

!u::{
    key := InputHook("L1")
    key.Start()
    key.Wait()
    k := key.Input

    switch k {
        case "a": Send "ä"
        case "o": Send "ö"
        case "u": Send "ü"
        case "A": Send "Ä"
        case "O": Send "Ö"
        case "U": Send "Ü"
        default:  Send "¨" k  ; fallback
    }
}


z::y
y::z


>:::
:::>

$<::Send ";"
$;::Send "<"


/::-
?::_

$_::Send "?"
$-::+

$=::Send "{@}"
$++::Send "{^}"

$&::Send "/"
$^::Send "&"
$#::Send "*"
$'::Send "{#}"
$"::Send "'"

*::(
(::)

$)::Send "="

$@::"

LCtrl::LWin
;; LWin::LCtrl
LWin::LAlt
LAlt::LCtrl

RCtrl::RAlt
RAlt::RCtrl

~*Esc::Send "{Ctrl up}{Alt up}{Shift up}{LWin up}{RWin up}"

#Space::Return

; hytale

#HotIf WinActive("ahk_exe HytaleClient.exe")
CapsLock::
{
    if KeyWait("CapsLock", "T0.15") {
        Send "{Esc}"
        return
    }

    Send "{F21 down}"
    KeyWait "CapsLock"
    Send "{F21 up}"
}
#HotIf

MsgBox("Loaded AHK skript",,)
