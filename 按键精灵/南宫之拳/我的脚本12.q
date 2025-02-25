[General]
SyntaxVersion=2
BeginHotkey=121
BeginHotkeyMod=0
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=0
RunOnce=1
EnableWindow=
MacroID=60d92185-5bf8-48c4-bcb7-f36cc2adbb1c
Description=我的脚本1
Enable=1
AutoRun=0
[Repeat]
Type=0
Number=1
[SetupUI]
Type=2
QUI=
[Relative]
SetupOCXFile=
[Comment]

[Script]
Delay 200
Rem xiayiguan
Delay 200
MoveTo 1009, 277
Delay 200
LeftClick 2
MoveTo 864, 694
LeftClick 2
Delay 3000

FindPic 450,440,680,520,"E:\weitu\goumai.bmp",0.9,intX,intY
If intX > 0 And intY > 0 Then 
MoveTo 570, 480
Delay200
LeftClick 1
Delay200 
Goto xiayiguan
End If

LeftClick 1
Delay 2000
LeftClick 1
Delay 7000
KeyPress "J", 2

Delay 9000
FindPic 680,640,920,720,"E:\weitu\fanhui.bmp",0.9,intX,intY
If intX > 0 And intY > 0 Then
MoveTo 864, 694
Delay 200
LeftClick 1
Delay 1000
MoveTo 560, 480
Delay 200
LeftClick 1
Delay 9000
Goto xiayiguan
End If

Delay 3000
KeyPress "J", 2

For 4

Delay 3000
FindPic 680,640,920,720,"E:\weitu\fanhui.bmp",0.9,intX,intY
If intX > 0 And intY > 0 Then
MoveTo 864, 694
Delay 200
LeftClick 1
Delay 1000
MoveTo 560, 480
Delay 200
LeftClick 1
Delay 9000
Goto xiayiguan
End If

Next

Delay 200
KeyPress "J", 2

For 5

Delay 3000
FindPic 680,640,920,720,"E:\weitu\fanhui.bmp",0.9,intX,intY
If intX > 0 And intY > 0 Then
MoveTo 864, 694
Delay 200
LeftClick 1
Delay 1000
MoveTo 560, 480
Delay 200
LeftClick 1
Delay 9000
Goto xiayiguan
End If

Next

KeyPress "D", 1
Delay 200
KeyPress "D", 1
Delay 200

For 6
KeyPress "W", 1
Delay 200

Next

Delay 9000
MoveTo 60, 150
LeftClick 1
Goto xiayiguan
