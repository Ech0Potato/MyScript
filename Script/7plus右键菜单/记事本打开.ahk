1011:
	SetTimer,notepadopen,-200
Return

notepadopen:
sleep,200
Critical,On
Files := GetSelectedFiles()
If !Files
{
	MsgBox,,,��ȡ�ļ�·��ʧ��4��,3
Return
}
run "%TextEditor%" "%files%"
Return