GetClipboardFormat(type=1)  ;Thanks nnnik
{
	Critical, On
	DllCall("OpenClipboard", "int", "")
	while c := DllCall("EnumClipboardFormats","Int",c?c:0)
		x .= "," c
	DllCall("CloseClipboard")

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

GetSelText(pram:=0, ByRef _isFile:="", ByRef _ClipAll:="")
{
	Saved_ClipBoard := ClipboardAll    ; ���ݼ�����
	Clipboard=    ; ��ռ�����
	SendInput, ^c
	ClipWait, 0.5
	If(ErrorLevel) ; ���ճ��������û�����ݣ���ԭ������
	{
		Clipboard:=Saved_ClipBoard
	Return
	}
	if pram
 {
	_isFile:=DllCall("IsClipboardFormatAvailable","UInt",15) ; �Ƿ����ļ�����
	_ClipAll := ClipboardAll
 }
	else
		_isFile := _ClipAll := ""
	ClipSel := Clipboard
	Clipboard := Saved_ClipBoard  ;��ԭճ����
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