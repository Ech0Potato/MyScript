;#IfWinActive,ahk_class RegEdit_RegEdit
;!x::
ע�����·��:
ControlGet, hwnd, hwnd, , SysTreeView321,ע���༭��
ret:=TVPath_Get(hwnd, outPath)
if( ret = "")
{
StringGetPos,hpos,outPath,HKEY
StringTrimLeft, OutputVar, outPath, hpos
clipboard := OutputVar
CF_Traytip("������", OutputVar " �Ѿ����Ƶ������塣", 2500)
}
Return
;#IfWinActive

/*
q::
ControlGet, hwnd, hwnd, , SysTreeView321,A
ret:=TVPath_Get(hwnd, outPath)
if( ret = "")
{
StringGetPos,hpos,outPath,HKEY
StringTrimLeft, OutputVar, outPath, hpos
clipboard := OutputVar
CF_Traytip("������", OutputVar "�Ѿ����Ƶ������塣", 2500)
}
return
*/