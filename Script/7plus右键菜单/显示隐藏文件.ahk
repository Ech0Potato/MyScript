1001:
	f_ToggleHidden(1)
Return

7PlusMenu_��ʾ�����ļ�()
{
	section = ��ʾ�����ļ�
	defaultSet=
	( LTrim
ID = 1001
Name = �л�"��ʾ/����"�����ļ�
Description = �л���ʾ�����ļ�
SubMenu = 7plus
FileTypes =
SingleFileOnly = 0
Directory = 0
DirectoryBackground = 1
Desktop = 1
showmenu = 1
	)
IniWrite, % defaultSet, % 7PlusMenu_ProFile_Ini, % section
return
}