1011:
	SetTimer,notepadopen,-200
Return

notepadopen:
sleep,200
Critical,On
Files := GetSelectedFiles()
If !Files
{
	MsgBox,,,��ȡ�ļ�·��ʧ�ܡ�,3
Return
}
run "%TextEditor%" "%files%"
Return

7PlusMenu_���±���()
{
	section = ���±���
	defaultSet=
	( LTrim
ID = 1011
Name = �ü��±���
Description = ʹ�ü��±��򿪵�ǰѡ���ļ�
SubMenu = 7plus
FileTypes = *
SingleFileOnly = 1
Directory = 0
DirectoryBackground = 0
Desktop = 0
showmenu = 1
	)
IniWrite, % defaultSet, % 7PlusMenu_ProFile_Ini, % section
return
}