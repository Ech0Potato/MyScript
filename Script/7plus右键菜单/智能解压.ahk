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
	MsgBox,,,��ȡ�ļ�·��ʧ��6��,3
Return
}

Loop Parse, Files, `n, `r ;�� Files �������ȡѹ����·�����������ָ���������ͷβ�س���
	7z_smart_Unarchiver(A_LoopField)
Return