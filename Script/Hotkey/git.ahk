; ����·�����Զ��򿪱����ļ�(����github �ϰ����ļ�����ʱ�Զ��򿪱����ļ�ͬ������)
git:
	if !SelectedPath
		SelectedPath := GetSelText()
	SelectedPath := StrReplace(SelectedPath, "/", "\")

	Switch  ; ��Ҫ������汾 1.1.31.00
	{
		case InStr(SelectedPath,"zh-cn"), InStr(SelectedPath,"v1"):
		{
			SelectedPath:=SubStr(SelectedPath, InStr(SelectedPath,"docs")+5)
			if FileExist("N:\����\autohotkey ����\v1\docs\" SelectedPath)
			{
				if WinExist("ahk_class Notepad3U")
				{
					WinActivate, ahk_class Notepad3U
					DropFiles("N:\����\autohotkey ����\v1\docs\" SelectedPath, "ahk_class Notepad3U")
				return
				}
				else
					run "%notepad3%" "N:\����\autohotkey ����\v1\docs\%SelectedPath%"
				return
			}
		}

		case InStr(SelectedPath,"v2"):
		{
			SelectedPath:=SubStr(SelectedPath, InStr(SelectedPath,"docs")+5)
			if FileExist("N:\����\autohotkey ����\v2\docs\" SelectedPath)
			{
				if WinExist("ahk_class Notepad2U")
				{
					WinActivate, ahk_class Notepad2U
					DropFiles("N:\����\autohotkey ����\v2\docs\" SelectedPath, "ahk_class Notepad2U")
				return
				}
			else
				run "%notepad2%" "N:\����\autohotkey ����\v2\docs\%SelectedPath%"
			return
			}
		}

		Default:
		{
			SelectedPath := LTrim(SelectedPath,"\")
			if FileExist("N:\����\autohotkey ����\v1\" SelectedPath)
			{
				if WinExist("ahk_class Notepad3U")
				{
					WinActivate, ahk_class Notepad3U
					DropFiles("N:\����\autohotkey ����\v1\" SelectedPath, "ahk_class Notepad3U")
				}
				else
				{
					run "%notepad3%" "N:\����\autohotkey ����\v1\%SelectedPath%"
					sleep, 200
					WinSet, AlwaysOnTop,, ahk_class Notepad3U
				}
			}
			sleep 1000
			if FileExist("N:\����\autohotkey ����\v2\" SelectedPath)
			{
				if WinExist("ahk_class Notepad2U")
				{
					WinActivate, ahk_class Notepad2U
					DropFiles("N:\����\autohotkey ����\v2\" SelectedPath, "ahk_class Notepad2U")
				}
				else
				{
					run "%notepad2%" "N:\����\autohotkey ����\v2\%SelectedPath%"
					sleep, 200
					WinSet, AlwaysOnTop,, ahk_class Notepad2U
				}
			}
		return
		}
	}
return