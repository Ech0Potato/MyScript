Windo_����·�����Ի���:
	ControlSetText , edit1, %Windy_CurWin_FolderPath%, ahk_class #32770
return

Windo_���ھ���:
	VA_SetAppMute(Windy_CurWin_Pid, !VA_GetAppMute(Windy_CurWin_Pid))
return

Windo_����·����windy�ղؼ�:
	SplitPath,Windy_CurWin_FolderPath,menuname
	iniwrite,%Windy_CurWin_FolderPath%,%A_ScriptDir%\Settings\Windy\������\windy_Fav.ini,menu,%menuname%
return

Windo_������:
	monitor := 0
	Candy_Saved_ClipBoard := ClipboardAll
	StringSplit, kql_Arr, A_ThisMenuItem, %A_Space%
	GetSelText(0)
	send {del}{%kql_Arr1%}
	Send,^v
	send {%kql_Arr2%}
	Sleep, 500
	Clipboard := Candy_Saved_ClipBoard    
	Candy_Saved_ClipBoard =
	monitor := 1
Return

Windo_���ִ�д:
	monitor := 0
	Candy_Saved_ClipBoard := ClipboardAll
	CandySel:=GetSelText()
	Loop, Parse, CandySel, %A_Space%_`,|;-��`.  
	{  
		; ����ָ�����λ��.  
		Position += StrLen(A_LoopField) + 1
		; ��ȡ����ѭ�����ҵ��ķָ���.  
		Delimiter := SubStr(CandySel, Position, 1)
		str1:= Format("{:T}", A_LoopField)
		out:=out . str1 . Delimiter 
	}  
	Clipboard :=out  
	Send,^v
	Sleep,500
	Clipboard := Candy_Saved_ClipBoard
	out :=Candy_Saved_ClipBoard:=Position:=""
	monitor := 1
Return