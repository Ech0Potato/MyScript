f_DerefPath(ThisPath)
{
	old:=ThisPath
	StringReplace, ThisPath, ThisPath, ``, ````, All
	StringReplace, ThisPath, ThisPath, `%F_CurrentDir`%, ```%F_CurrentDir```%, All
	Transform, ThisPath, deref, %ThisPath%
	return ThisPath
}

; �����û���ϵͳ��������
; ppath Ϊ �������ŵ��ı���ٷֺŰ�Χ���ı�
ExpandEnvVars(ppath)
{
	VarSetCapacity(dest, 2000)
	DllCall("ExpandEnvironmentStrings", "str", ppath, "str", dest, int, 1999, "Cdecl int")
	Return dest
}