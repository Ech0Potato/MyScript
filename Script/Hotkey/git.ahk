; ����·�����Զ��򿪱����ļ�(����github �ϰ����ļ�����ʱ�Զ��򿪱����ļ�ͬ������)
git:
if !SelectedPath
	SelectedPath := GetSelText()
SelectedPath := StrReplace(SelectedPath, "/", "\")
SetTitleMatchMode, 2
if WinExist("N:\����\autohotkey ����\v1\docs ahk_class CabinetWClass") && FileExist("N:\����\autohotkey ����\v1\" SelectedPath)
{
	if WinExist("ahk_class Notepad3U")
	{
		if !WinActive("ahk_class Notepad3U")
			WinActivate, ahk_class Notepad3U
		DropFiles("N:\����\autohotkey ����\v1\" SelectedPath, "ahk_class Notepad3U")
	}
	else
	{
		run "%notepad3%" "N:\����\autohotkey ����\v1\%SelectedPath%"
		sleep, 200
		WinSet, AlwaysOnTop,, ahk_class Notepad3U
	}
	;return
}
sleep 1000
if WinExist("N:\����\autohotkey ����\v2\docs ahk_class CabinetWClass") && FileExist("N:\����\autohotkey ����\v2\" SelectedPath)
{
	if WinExist("ahk_class Notepad2U")
	{
		if !WinActive("ahk_class Notepad2U")
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