; ���ܽ�ѹ
; 1).ѹ�������ж���ļ������ļ��У�ʱ����ѹ���ļ���ѹ��������Ŀ¼�ġ���ѹ����ͬ�����ļ��С���
; A.rar-------- Files / Folds / File+Fold / File+Folds / Files+Fold / Files+Folds  �� Fold(name:A)
; 2).ѹ��������ֻ��1���ļ����У�ʱ����ѹ���ļ���ѹ����������Ŀ¼
; A.rar-------- File��File / Fold��Fold
7z_smart_Unarchiver(S_File:="", S_tooltip:= 0)
{
	global 7Z, 7ZG
	if !7z
	{
		msgbox, δ���ñ���7z��7zg���޷���ѹ��
	return
	}
	SmartUnZip_�ײ����ļ���־ := SmartUnZip_�ײ����ļ��б�־ := SmartUnZip_�Ƿ�����ļ� := 0
	SmartUnZip_�ײ��ļ�����:= SmartUnZip_�ļ�����A := SmartUnZip_�ļ�����B := ""
	��_�б�=%A_Temp%\wannianshuyaozhinengjieya_%A_Now%.txt

	; ��ѹ����·���ָ�Ϊ��������Ŀ¼�Ͳ�����չ�����ļ���
	SplitPath S_File, ��_�����ļ���, ��_Ŀ¼, , ��_�ļ���, ��_����
	DriveSpaceFree, IntUnZip_FreeSpace, %��_����%
	FileGetSize, IntUnZip_FileSize, %S_File%, M
	If (IntUnZip_FileSize > IntUnZip_FreeSpace)
	{
		MsgBox ���̿ռ䲻��,�޷���ѹ�ļ���`n------------`nѹ������%IntUnZip_FileSize%M`nʣ�� ��%IntUnZip_FreeSpace%M
	Return
	}
	RunWait, %comspec% /c ""%7Z%" l "%S_File%"`>"%��_�б�%"",,hide
	loop, read, %��_�б�%
	{
		If(RegExMatch(A_LoopReadLine, "^(\d\d\d\d-\d\d-\d\d)"))
		{
			SmartUnZip_�Ƿ�����ļ� := 1
			If( InStr(A_loopreadline, "D") = 21 Or InStr(A_loopreadline, "\"))  ;�����������\������D��־�����ж�Ϊ�ļ���
			{
				SmartUnZip_�ײ����ļ��б�־ = 1
			}

			If InStr(A_loopreadline, "\")
				StringMid, SmartUnZip_�ļ�����A, A_LoopReadLine, 54, InStr(A_loopreadline, "\")-54
			Else
				StringTrimLeft, SmartUnZip_�ļ�����A, A_LoopReadLine, 53

			If((SmartUnZip_�ļ�����B != SmartUnZip_�ļ�����A) And (SmartUnZip_�ļ�����B!=""))
			{
				SmartUnZip_�ײ����ļ���־ = 1
				Break
			}
			SmartUnZip_�ļ�����B := SmartUnZip_�ļ�����A
		}
	}
	;FileDelete, %��_�б�%
	if !SmartUnZip_�Ƿ�����ļ�
	{
		msgbox ��ѹ�������޷���ȡѹ������
	return
	}

	; ������������������������������������������������������������������������������������������������������������
; -o���������пո�
	If(SmartUnZip_�ײ����ļ���־=0 && SmartUnZip_�ײ����ļ��б�־ = 0)   ; ѹ���ļ��ڣ��ײ����ҽ���һ���ļ�
	{
		Run, %7ZG% x "%S_File%" -o"%��_Ŀ¼%"    ; ���ҽ���һ���ļ�ֱ�ӽ�ѹ�����ǻ��Ǹ���������7z
	}

	Else If(SmartUnZip_�ײ����ļ���־=0 && SmartUnZip_�ײ����ļ��б�־ = 1)   ; ѹ���ļ��ڣ��ײ����ҽ���һ���ļ���
	{
		IfExist, %��_Ŀ¼%\%SmartUnZip_�ļ�����A%   ;�Ѿ��������ԡ��ײ��ļ������������ļ��У���ô�죿
		{
			Loop
			{
				SmartUnZip_NewFolderName = %��_Ŀ¼%\%SmartUnZip_�ļ�����A%(%A_Index%)
				If !FileExist(SmartUnZip_NewFolderName)
				{
					Run, %7ZG% x "%S_File%" -o"%SmartUnZip_NewFolderName%"
				break
				}
			}
		}
		Else  ;û�С��ײ��ļ������������ļ��У��Ǿ�̫����
		{
			Run, %7ZG% x "%S_File%" -o"%��_Ŀ¼%"
		}
	}
	Else  ;ѹ���ļ��ڣ��ײ��ж���ļ���
	{
		IfExist %��_Ŀ¼%\%��_�ļ���%  ;�Ѿ��������ԡ����ļ��������ļ��У���ô�죿
		{
			Loop
			{
				SmartUnZip_NewFolderName = %��_Ŀ¼%\%��_�ļ���%(%A_Index%)
				If !FileExist(SmartUnZip_NewFolderName)
				{
					Run, %7ZG% x "%S_File%" -o"%SmartUnZip_NewFolderName%"
				break
				}
			}
		}
		Else ;û�У��Ǿ�̫����
		{
			Run, %7ZG% x "%S_File%" -o"%��_Ŀ¼%\%��_�ļ���%"
		}
	}
	if S_tooltip
		CF_ToolTip("�ļ�%��_�����ļ���%��ѹ��ɣ�", 2000)
Return
}