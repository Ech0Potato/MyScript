1009:
	sPara=/DES
	SetTimer,����Ŀ¼����,-200
Return

7PlusMenu_�ڵ�ǰĿ¼�д���ָ������Ŀ¼������()
{
	section = �ڵ�ǰĿ¼�д���ָ������Ŀ¼������
	defaultSet=
	( LTrim
ID = 1009
Description = �ڸ��ļ����д��������ļ��е�Ŀ¼����(����)
Name = �ڴ��ļ����д���Ŀ¼����(����)
SubMenu = 7plus
FileTypes =
SingleFileOnly = 0
Directory = 0
DirectoryBackground = 1
Desktop = 0
showmenu = 1
	)
IniWrite, % defaultSet, % 7PlusMenu_ProFile_Ini, % section
return
}