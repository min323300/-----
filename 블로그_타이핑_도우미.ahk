#Requires AutoHotkey v2.0
#SingleInstance Force

global TypingActive := false

; Ctrl+Alt+B로 입력창 열기
^!b:: {
    ShowInputGUI()
}

ShowInputGUI() {
    myGui := Gui(, "블로그 타이핑 도우미")
    myGui.SetFont("s10")
    myGui.Add("Text", , "본문을 입력하세요:")
    myGui.Add("Edit", "vContent w400 h300 Multi")
    myGui.Add("Button", "w100", "F2 타이핑").OnEvent("Click", (*) => StartTyping(myGui, 150))
    myGui.Add("Button", "x+10 w100", "F3 느리게").OnEvent("Click", (*) => StartTyping(myGui, 300))
    myGui.Show()
}

StartTyping(myGui, delay) {
    saved := myGui.Submit()
    text := saved.Content
    if (text = "") {
        MsgBox("내용을 입력해주세요!")
        return
    }
    Sleep(1000)
    TypeText(text, delay)
}

TypeText(text, delay) {
    global TypingActive
    TypingActive := true
    
    Loop Parse, text {
        if (!TypingActive)
            break
        char := A_LoopField
        if (char = "`n")
            Send("{Enter}")
        else if (char = "`t")
            Send("{Tab}")
        else
            SendText(char)
        randomDelay := delay + Random(-delay * 0.3, delay * 0.3)
        Sleep(randomDelay)
    }
    TypingActive := false
    ToolTip("타이핑 완료!")
    SetTimer(() => ToolTip(), -2000)
}

ESC:: {
    global TypingActive
    if (TypingActive) {
        TypingActive := false
        ToolTip("타이핑 중단됨")
        SetTimer(() => ToolTip(), -1500)
    }
}
