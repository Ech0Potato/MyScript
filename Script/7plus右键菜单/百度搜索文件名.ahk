;����lnk�ļ���Ч(����lnk�ļ�����Ч)
1004:
	SetTimer,searchthefile,-200
Return

; ����lnk�ļ���Ч  Why
; �ٶ������ļ���
searchthefile:
	sleep, 200
	Critical, On
	Files := GetSelectedFiles(0)
	If !Files
	{
		MsgBox,,,��ȡ�ļ�·��ʧ��1��,3
	Return
	}
	Critical, Off

	StrReplace(files, "`n", "`n", tmp_v)
	if tmp_v > 5
	{
		msgbox, 4, �����ļ���, ������5�����ϵ��ļ������Ƿ������
		IfMsgBox Yes
		{
			Loop, Parse, files, `n, `r
				run, http://www.baidu.com/s?wd=%A_LoopField%
		return
		}
		else
		return
	}
	Loop, Parse, files, `n, `r
		run, http://www.baidu.com/s?wd=%A_LoopField%
Return

7PlusMenu_�ٶ������ļ���()
{
	section = �ٶ������ļ���
	defaultSet=
	( LTrim
ID = 1004
Name = �ٶ������ļ���
Description = �ٶ��������ļ�(֧�ֶ��ļ�)
SubMenu = 7plus
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