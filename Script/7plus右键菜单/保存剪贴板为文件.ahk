1014:
SetTimer,���������Ϊ�ļ�,-200
return

���������Ϊ�ļ�:
CurrentFolder:=GetCurrentFolder()
if CurrentFolder
PasteToPath(CurrentFolder)
return

7PlusMenu_���������Ϊ�ļ�()
{
	section = ���������Ϊ�ļ�
	defaultSet=
	( LTrim
ID = 1014
Name = ���������Ϊ�ļ�
Description = ���������Ϊ�ļ�
SubMenu =
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