;~ �� Explorer ��ģ�� TC ��ȡ�ļ����ļ���·���Ĺ��ܡ�
����·��:
IfWinActive,ahk_Group ccc
{
Gui,3:Destroy
;Hotkey, IfWinActive,ahk_Group ccc
;hotkey,^+c,����·��
;^+c �ᴥ���л����뷨,  �ȼ�����Ϊ  k-hook   c���ͷ�  ��ס��������Ctrl+Shift  Ȼ���ɿ�
;^+c��Ϊȫ���ȼ����ȼ�����Ϊ reg����������һ�нű�����һ���ᴥ��
keywait LShift

    Clipboard =
    Send, ^c    ;����� c ����д�ɴ�д C  ��дC Ϊ����^+c
    ClipWait, 1

Loop, Parse, Clipboard, `n, `r
FileFullPath=%A_LoopField%
Splitpath,FileFullPath,Filename,Filepath

Gui,3:Add, Button, gexit3 x0 y0  w490 h28 +Left,����·����������                                                            �˳�
Gui,3:Add, Button, gCopyPath x0 y28 w490 h28 +Left,�ļ�����: %Filename%
Gui,3:Add, Button, gCopyPath x0 y56 w490 h28 +Left,�ļ�Ŀ¼: %Filepath%\
Gui,3:Add, Button, gCopyPath x0 y84 w490 h34 +Left,����·��: %FileFullPath%

Gui,3:Show, w485 h92
Gui,3:+AlwaysOnTop -Caption -Border +AlwaysOnTop
Gui,3:Show
Gui,3:Flash
}
Return

;������Դ��7plus
;����lnk�ļ�ֻ�ܻ���ļ��������ܻ��lnk��չ��
;CTRL+ALT+C:�����ļ�·����������
;Shift+ALT+C:׷���ļ����������壬ԭ���������ݲ����
�����ļ���:
if !IsRenaming()
CopyFilenames()
Return

CopyFilenames()
{
	global PasteFileClipboardBackup
	files := GetSelectedFiles()
	if(files)
	{
		clip:=ReadClipboardText()
		if(!GetKeyState("Shift")) ;Shift=append to clipboard
			clip := ""
		if (GetKeyState("Control")) ; use control to save paths too
		{
				Loop, Parse, files, `n,`r  ; Rows are delimited by linefeeds (`r`n).
					clip .= (clip = "" ? "" : "`r`n") A_LoopField
				PasteFileClipboardBackup:="" ;Clear clipboard backup so it won't be restored when another program gets activated, since clipboard gets changed now
				clipboard:=clip
		}
		else
		{
				Loop, Parse, files, `n,`r  ; Rows are delimited by linefeeds (`r`n).
				{
					SplitPath, A_LoopField, file
					clip .= (clip = "" ? "" : "`r`n") file
				}
				PasteFileClipboardBackup:="" ;Clear clipboard backup so it won't be restored when another program gets activated, since clipboard gets changed now
				clipboard:=clip
		}
	}
	else
		SendInput !{c}
	return
}

CopyPath:
GuiControlGet,whichbutton, Focus
GuiControlGet,copypath,,%whichbutton%
StringLeft,copypath2,copypath,9
StringTrimLeft, copypath, copypath, 9
Clipboard = %copypath%
TrayTip, ������,%copypath2%" %copypath% "�Ѿ����Ƶ������塣
Gui,3:Destroy
SetTimer, RemoveTrayTip, 2500
return

exit3:
3GuiEscape:
Gui,3:Destroy
return

;Read real text (=not filenames, when CF_HDROP is in clipboard) from clipboard
ReadClipboardText()
{
	if(DllCall("IsClipboardFormatAvailable", "Uint", 1))
	{
		DllCall("OpenClipboard", "Uint", 0)
		htext:=DllCall("GetClipboardData", "Uint", 1)
		ptext := DllCall("GlobalLock", "uint", htext)
		text:=PointerToString(pText)
		text:=ExtractData(ptext)
		DllCall("GlobalUnlock", "uint", htext)
		DllCall("CloseClipboard")
	}
	return text
}

PointerToString(string)
{
	return DllCall("MulDiv", int, &sTest, int, 1, int, 1, str)
}

;get data starting from pointer up to 0 char
ExtractData(pointer) {
Loop {
       errorLevel := ( pointer+(A_Index-1) )
       Asc := *( errorLevel )
       IfEqual, Asc, 0, Break ; Break if NULL Character
       String := String . Chr(Asc)
     }
Return String
}