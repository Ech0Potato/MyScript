GetClipboardFormat(type=1)  ;Thanks nnnik
{
	Critical, On  
	DllCall("OpenClipboard", "int", "")
	while c := DllCall("EnumClipboardFormats","Int",c?c:0)
		x .= "," c
	DllCall("CloseClipboard")
	Critical, OFF    ; �ڿ�ʼִ�ж�ʹ�øú�����ʹ���к����̱߳�Ϊ�����жϣ��ű��Ῠ����������Ҫ�ر�
	if type=1
		if Instr(x, ",1") and Instr(x, ",13")
		return 1
		else If Instr(x, ",15")
		return 2
		else
		return ""
		else
		return x
}

; returnnum = 0 ����ԭ�����壬���ظ��Ƶ����ݣ��¼����壩
; returnnum = 1 ��ԭ������(���������ݲ���)����� _isFile _ClipAll�����ظ��Ƶ�����
; returnnum = 2/3/4.. ��ԭ�����壬��ֵ _isFile _ClipAll�����ظ��Ƶ�����
GetSelText(returnnum:=1, ByRef _isFile:="", ByRef _ClipAll:="",waittime:=2)
{
	global monitor
	monitor := (returnnum = 0) ? 1 : 0
	Saved_ClipBoard := ClipboardAll    ; ���ݼ�����
	Clipboard=    ; ��ռ�����
	Send, ^c
	sleep 200
	ClipWait, % waittime
	If(ErrorLevel) ; ���ճ��������û�����ݣ���ԭ������
	{
		Clipboard:=Saved_ClipBoard
		sleep 100
		monitor := 1
	Return
	}
	If(returnnum=0)
	Return Clipboard
	else If(returnnum=1)
		_isFile := _ClipAll := ""
	else
	{
		_isFile:=DllCall("IsClipboardFormatAvailable","UInt",15) ; �Ƿ����ļ�����
		_ClipAll := ClipboardAll
	}
	ClipSel := Clipboard

	Clipboard := Saved_ClipBoard  ; ��ԭճ����
	sleep 200
	monitor := 1
	return ClipSel
}

;Read real text (=not filenames, when CF_HDROP is in clipboard) from clipboard
ReadClipboardText()
{
	; CF_TEXT = 1 ;CF_UNICODETEXT = 13
	If((!A_IsUnicode && DllCall("IsClipboardFormatAvailable", "Uint", 1)) || (A_IsUnicode && DllCall("IsClipboardFormatAvailable", "Uint", 13)))
	{
		DllCall("OpenClipboard", "Ptr", 0)	
		htext:=DllCall("GetClipboardData", "Uint", A_IsUnicode ? 13 : 1, "Ptr")
		ptext := DllCall("GlobalLock", "Ptr", htext)
		text := StrGet(pText, A_IsUnicode ? "UTF-16" : "cp0")
		DllCall("GlobalUnlock", "Ptr", htext)
		DllCall("CloseClipboard")
	}
	Return text
}

GetClipboardFormatName(nFormat)
{
    VarSetCapacity(sFormat, 255)
    DllCall("GetClipboardFormatName", "Uint", nFormat, "str", sFormat, "Uint", 256)
    Return  sFormat
}