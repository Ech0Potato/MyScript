;Cando �ű��еĽ���ͳһʹ�ñ��66
66GuiClose:
66Guiescape:
	Gui,66:Destroy
Return

Cando_���浽����:
	FileAppend,%CandySel%,%A_Desktop%\%A_Now%.txt
return

Cando_���沢����:
	FileDelete,%A_Desktop%\temp.ahk
	FileAppend,%CandySel%`r`n,%A_Desktop%\temp.ahk
	Run,%A_Desktop%\temp.ahk,%A_Desktop%
Return

Cando_10��A��U�������򽻻�:
FileMove,D:\Program Files\AutoHotkey\AutoHotkey_La.exe,D:\Program Files\AutoHotkey\AutoHotkey-La.exe
sleep,500
FileMove,D:\Program Files\AutoHotkey\AutoHotkey_Lu.exe,D:\Program Files\AutoHotkey\AutoHotkey_La.exe
tooltipnum=10
loop,10{
toolTip,%tooltipnum%s
tooltipnum--
sleep,1000
toolTip
}
tooltipnum=
FileMove,D:\Program Files\AutoHotkey\AutoHotkey_La.exe,D:\Program Files\AutoHotkey\AutoHotkey_Lu.exe
sleep,500
FileMove,D:\Program Files\AutoHotkey\AutoHotkey-La.exe,D:\Program Files\AutoHotkey\AutoHotkey_La.exe
return

Cando_10��A��Basic�������򽻻�:
FileMove,D:\Program Files\AutoHotkey\AutoHotkey_La.exe,D:\Program Files\AutoHotkey\AutoHotkey-La.exe
sleep,800
FileMove,D:\Program Files\AutoHotkey\AutoHotkey.exe,D:\Program Files\AutoHotkey\AutoHotkey_La.exe
tooltipnum=10
loop,10{
toolTip,%tooltipnum%s
tooltipnum--
sleep,1000
toolTip
}
tooltipnum=
FileMove,D:\Program Files\AutoHotkey\AutoHotkey_La.exe,D:\Program Files\AutoHotkey\AutoHotkey.exe
sleep,800
FileMove,D:\Program Files\AutoHotkey\AutoHotkey-La.exe,D:\Program Files\AutoHotkey\AutoHotkey_La.exe
return

cando_Ѹ������:
StringGetPos,zpos,CandySel,/,R
zpos++
StringTrimLeft,sFile,CandySel,%zpos%
try {
	thunder := ComObjCreate("ThunderAgent.Agent")
	thunder.AddTask( CandySel ;���ص�ַ
			       , sFile  ;����ļ���
			       , "N:\"  ;����Ŀ¼
			       , sFile  ;����ע��
			       , ""  ;���õ�ַ
			       , 1 ;��ʼģʽ
			       , true  ;ֻ��ԭʼ��ַ����
			       , 10 )  ;��ԭʼ��ַ�����߳���
	thunder.CommitTasks()
}
Return

Cando_�鿴Dll�ں���:
msgbox,,Dll�ļ��ں����б�, % DllListExports(CandySel)
return
