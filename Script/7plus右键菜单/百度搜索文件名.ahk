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