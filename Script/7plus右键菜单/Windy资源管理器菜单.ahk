1013:
SetTimer,Windy,-200
Return

7PlusMenu_Windy��Դ�������˵�()
{
	section = Windy��Դ�������˵�
	defaultSet=
	( LTrim
ID = 1013
Name = Windy
Description = Windy �Ҽ��˵�
SubMenu =
FileTypes =
SingleFileOnly = 0
Directory = 0
DirectoryBackground = 1
Desktop = 1
showmenu = 0
	)
IniWrite, % defaultSet, % 7PlusMenu_ProFile_Ini, % section
return
}