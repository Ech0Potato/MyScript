1010:
	SetTimer,������ʾ��,-200
Return

7PlusMenu_Open_Cmd_Here()
{
	section = Open_Cmd_Here
	defaultSet=
	( LTrim
ID = 1010
Name = Open CMD Here
Description = CMD�򿪶�λ�����ļ���
SubMenu = 7plus
FileTypes =
SingleFileOnly = 0
Directory =0
DirectoryBackground = 1
Desktop = 1
showmenu = 1
	)
IniWrite, % defaultSet, % 7PlusMenu_ProFile_Ini, % section
return
}