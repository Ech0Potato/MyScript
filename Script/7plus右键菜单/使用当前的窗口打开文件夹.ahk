1012:
	SetTimer,�˸��ղص��ļ��в˵�,-200
Return

7PlusMenu_ʹ�õ�ǰ�Ĵ��ڴ��ļ���()
{
	section = ʹ�õ�ǰ�Ĵ��ڴ��ļ���
	defaultSet=
	( LTrim
ID = 1012
Name = �ղؼ�
Description = ʹ�õ�ǰ�Ĵ��ڴ��ղص��ļ���
SubMenu =
FileTypes =
Directory =
DirectoryBackground = 1
Desktop = 1
SingleFileOnly = 0
showmenu = 0
	)
IniWrite, % defaultSet, % 7PlusMenu_ProFile_Ini, % section
return
}