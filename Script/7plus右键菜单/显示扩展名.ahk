1002:
	f_ToggleFileExt(1)
Return

7PlusMenu_��ʾ��չ��()
{
	section = ��ʾ��չ��
	defaultSet=
	( LTrim
ID = 1002
Name = �л�"��ʾ/����"�ļ���չ��
Description = ��ʾ(����)�ļ���չ��
SubMenu = 7plus
FileTypes =
SingleFileOnly = 1
Directory = 0
DirectoryBackground = 1
Desktop = 1
showmenu = 1
	)
IniWrite, % defaultSet, % 7PlusMenu_ProFile_Ini, % section
return
}