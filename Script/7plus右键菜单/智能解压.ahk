1006:
	SetTimer,smartunrar,-200
Return

;���ܽ�ѹ
;1).ѹ�������ж���ļ������ļ��У�ʱ����ѹ���ļ���ѹ��������Ŀ¼�ġ���ѹ����ͬ�����ļ��С���
;A.rar--------Folds/Files/Folds+Files/Fold+Files/File+Folds��Fold(name:A)
;2).ѹ��������ֻ��1���ļ����У�ʱ����ѹ���ļ���ѹ��������Ŀ¼�ġ���ѹ�����ڵ��ļ����У�ͬ�����ļ������ڣ���
;A.rar--------File��File/Fold��Fold
smartunrar:
sleep,200
Critical,On
Files := GetSelectedFiles()
If !Files
{
	MsgBox,,,��ȡ�ļ�·��ʧ�ܡ�,3
Return
}

Loop Parse, Files, `n, `r ;�� Files �������ȡѹ����·�����������ָ���������ͷβ�س���
	7z_smart_Unarchiver(A_LoopField)
Return

7PlusMenu_���ܽ�ѹ()
{
	section = ���ܽ�ѹ
	defaultSet=
	( LTrim
ID = 1006
Name = ���ܽ�ѹ����ǰ�ļ���
Description = ���ܽ�ѹ����ǰ�ļ���(֧�ֶ��ļ�)
SubMenu = 7plus
FileTypes = rar,zip,7z
SingleFileOnly = 0
Directory = 0
DirectoryBackground = 0
Desktop = 0
showmenu = 1
	)
IniWrite, % defaultSet, % 7PlusMenu_ProFile_Ini, % section
return
}