#Requires AutoHotkey v2.0
#SingleInstance Force

global TypingActive := false

F2:: {
    TypeClipboard(150)
}

F3:: {
    TypeClipboard(300)
}

ESC:: {
    global TypingActive
    if (TypingActive) {
        TypingActive := false
        ToolTip("타이핑 중단됨")
        SetTimer(() => ToolTip(), -1500)
    }
}

TypeClipboard(delay) {
    global TypingActive
    
    if (TypingActive) {
        TypingActive := false
        Sleep(100)
    }
    
    text := A_Clipboard
    if (text = "") {
        ToolTip("클립보드가 비어있습니다")
        SetTimer(() => ToolTip(), -2000)
        return
    }
    
    TypingActive := true
    totalChars := StrLen(text)
    
    ToolTip("타이핑 시작... (ESC로 중단)")
    
    Loop Parse, text {
        if (!TypingActive) {
            break
        }
        
        char := A_LoopField
        
        if (char = "`n") {
            Send("{Enter}")
        } else if (char = "`t") {
            Send("{Tab}")
        } else {
            SendText(char)
        }
        
        progress := Round((A_Index / totalChars) * 100)
        if (Mod(A_Index, 20) = 0) {
            ToolTip("타이핑 중... " progress "% (ESC로 중단)")
        }
        
        randomDelay := delay + Random(-delay * 0.3, delay * 0.3)
        Sleep(randomDelay)
    }
    
    TypingActive := false
    
    if (A_Index >= totalChars) {
        ToolTip("타이핑 완료!")
    }
    SetTimer(() => ToolTip(), -2000)
}
