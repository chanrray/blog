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
MacroID=a86adee7-88a1-4246-8dcf-12b98561b6f1
Description=找不同方块
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

Function 找色点击(n)

x=int(489/n)

GetColor1 = GetPixelColor(478+int(0.5*x), 168+int(0.5*x))
GetColor2 = GetPixelColor(478+int(0.5*x), 168+int(1.5*x))
GetColor3 = GetPixelColor(478+int(1.5*x), 168+int(0.5*x))


If GetColor1=GetColor2 Then
Colorxy=GetColor1
Elseif GetColor1 = GetColor3 Then
Colorxy = GetColor1
Else 
Colorxy = GetColor3
End If

For j = 1 To n
	y1=	int(168+(j-0.5)*x)
	
	For k = 1 To n
		x1=int(478+(k-0.5)*x)
		
		IfColor x1, y1, Colorxy, 1 Then
			MoveTo x1,y1
			LeftClick 1
			Goto zzz
		End If
		
		
	Next	
	
Next
Rem zzz
End Function


Call 找色点击(2)
Call 找色点击(3)
Call 找色点击(4)
Call 找色点击(5)
Call 找色点击(5)
Call 找色点击(6)
Call 找色点击(6)
Call 找色点击(7)
Call 找色点击(7)
Call 找色点击(7)
For 6
Call 找色点击(8)
Next
For 100
Call 找色点击(9)
Next
