1015:
	SetTimer,CopyPathToClip,-200
Return

CopyPathToClip:
	sleep, 200
	Critical, On
	Files := GetSelectedFiles()
	If !Files
	{
		CF_ToolTip("�޷���ȡ���ļ�·����", 3000)
	return
	}
	Clipboard := Files
	if !Auto_Clip
	CF_ToolTip("�Ѹ����ļ�·�����ؼ����塣", 3000)
Return

7PlusMenu_�����ļ�·��()
{
	section = �����ļ�·��
	defaultSet=
	( LTrim
		ID = 1015
		Name = �����ļ�·��
		Description = �����ļ�·������(֧�ֶ��ļ�)
		SubMenu =
		FileTypes = *
		SingleFileOnly = 0
		Directory = 1
		DirectoryBackground = 0
		Desktop = 0
		showmenu = 1
	)
IniWrite, % defaultSet, % 7PlusMenu_ProFile_Ini, % section
return
}