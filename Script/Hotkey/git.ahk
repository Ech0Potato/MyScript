; github �ϰ����ļ�����ʱ����·�����Զ��򿪱����ļ�
git:
SelectedPath := Clipboard
if !SelectedPath
SelectedPath := GetSelText()
SelectedPath := StrReplace(SelectedPath, "/", "\")
SetTitleMatchMode, 2
;tooltip % SelectedPath
if WinExist("N:\����\autohotkey ����\v2\docs")
{
	if WinExist("ahk_class Notepad2U")
	DropFiles("N:\����\autohotkey ����\v2\" SelectedPath, "ahk_class Notepad2U")
	else
	{
		run "%notepad2%" "N:\����\autohotkey ����\v2\%SelectedPath%"
		sleep,200
		WinSet,AlwaysOnTop,,ahk_class Notepad2U
	}
}
else if WinExist("N:\����\autohotkey ����\v1\docs")
{
	if WinExist("ahk_class Notepad2U")
	DropFiles("N:\����\autohotkey ����\v1\" SelectedPath, "ahk_class Notepad2U")
	else
	{
		run "%notepad2%" "N:\����\autohotkey ����\v1\%SelectedPath%"
		sleep,200
		WinSet,AlwaysOnTop,,ahk_class Notepad2U
	}
}
return