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