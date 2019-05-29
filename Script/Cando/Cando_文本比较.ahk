Cando_�ı��Ƚ�:
	IfWinExist,���ֱȽ� ahk_class AutoHotkeyGUI
	{
		Gui,66:Default 
		if Candy_isFile
		{
			FileEncoding, % File_GetEncoding(CandySel)
			fileread,default2,%CandySel%
			FileEncoding
			GuiControl,, textfile2,%CandySel%
			if (strlen(default2) > 10000)
				GuiControl,Disable,compmode
			t2.SetText(default2)
		}
		else
		{
			if (strlen(CandySel) > 10000)
			GuiControl,Disable,compmode
			t2.SetText(CandySel)
		}
		WinActivate,���ֱȽ� ahk_class AutoHotkeyGUI
		SetTimer, WatchScrollBar, 100
	}
	else
	{
		Gui,66:Destroy
		Gui,66:Default 
		gui +ReSize +hwndGuiID
		if Candy_isFile
		{
			FileEncoding, % File_GetEncoding(CandySel)
			fileread,default1,%CandySel%
			FileEncoding
			textfile1:=CandySel
		}
		else
			textfile1:=""
		twidth := 600, bwidth := 150, bwidth2 := 100, opts := "x5 y30 r40  0x100000"
		Gui, Add,text ,,%textfile1%
		Gui, Add,text,x600 yp w600 vtextfile2, 
		t1 := new RichEdit(66, opts " w" twidth)
		t2 := new RichEdit(66, opts " w" twidth " xp" twidth)
		Gui, Add, Button, Default w%bwidth% x520 gcompare, �Ƚ�/����
		Gui, Add,text, x700 yp+10 h25,ģʽ��
		Gui, Add, Radio,  x740 yp-8 h25 gsub Group vcompmode,��
		Gui, Add, Radio,  x790 yp h25 gsub, ����
		Gui, Add, Radio,  x860 yp h25 gsub Checked,��
		gui show,,���ֱȽ�
		if Candy_isFile
		{
			if (strlen(default1) > 10000)
				GuiControl,Disable,compmode
			t1.SetText(default1)
		}
		else
		{
			if (strlen(CandySel) > 10000)
				GuiControl,Disable,compmode
			t1.SetText(CandySel)
		}
	}
return

sub:
	Gui Submit, NoHide
	if (strlen(t1.GetText()) < 10000) && (strlen(t2.GetText()) < 10000)
		GuiControl,enable,compmode
	else
		GuiControl,Disable,compmode
return

; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=59029
; https://github.com/oif2003/RichEditBox/blob/master/textCompare.ahk
; �޸�Ϊ v1 �汾  �����ִ�Сд
compare()
{
	global t1, t2, compmode, c:= [], t1Arr := [], t2Arr := []
	t1text:=t1.GetText(), t1.SetText(t1text)
	t2text:=t2.GetText(), t2.SetText(t2text)
	t1.WordWrap("on"), t2.WordWrap("on")
	ToolTip,���ڱȽ��ı�����ȴ�...
	StartTime:=A_TickCount

	if (compmode=1) && ((strlen(t1text) > 10000) or (strlen(t2text) > 10000))
		compmode=2
	compmode := strlen(t1text) > 20000 ? 3 : compmode

	if (compmode=1) 
		de := ""
	else if (compmode=2)
		de := ["��" , "��", " ", "`n", "`r"]
	else
		de := ["`n", "`r"]

	a := strsplit(t1text, de), b := strsplit(t2text, de), c := lcs(a, b)
	t1s := 1, t1e := 1, t2s := 1, t2e := 1, t1m := [], t2m := []
	for _, v in c 
	{
		;Deleted
		while (a[t1e] != v)
		{
			t1e++
		}
		if (t1e > t1s)
		{
			t1m.push([t1s, t1e-1])
		}
		t1s := ++t1e

		;Inserted
		while (b[t2e] != v)
			t2e++
		if (t2e > t2s)
			t2m.push([t2s, t2e-1])
		t2s := ++t2e
	}
	consolidate(t1m, a)
	for _, v in t1m 
	{
		if (compmode=1)
			start := v[1] - 1, end := v[2]
		else if (compmode=2)
			start := wordStart(a, v[1]), end := wordStart(a, v[2]) + StrLen(a[v[2]])
		else
			start := lineStart(a, v[1]), end := lineStart(a, v[2]) + StrLen(a[v[2]])
		t1.SetSel(start, end), t1.SetFont({BkColor:"RED", Color:"WHITE"})
		,t1Arr.Push(SubStr(t1text, start + 1, end - start))
	}
	
	consolidate(t2m, b)
	for _, v in t2m
	{
		if (compmode=1)
			start := v[1] - 1, end := v[2]
		else if (compmode=2)
			start := wordStart(b, v[1]), end := wordStart(b, v[2]) + StrLen(b[v[2]])
		else
			start := lineStart(b, v[1]), end := lineStart(b, v[2]) + StrLen(b[v[2]])
		t2.SetSel(start, end), t2.SetFont({BkColor:"GREEN", Color:"WHITE"})
		,t2Arr.Push(SubStr(t2text, start + 1, end - start))
	}
	
	;Leftovers
	if (compmode=1)
		start1 := t1s - 1, start2 := t2s - 1
	else if (compmode=2)
		start1 := wordStart(a, t1s), start2 := wordStart(b, t2s)
	else
		start1 := lineStart(a, t1s), start2 := lineStart(b, t2s)
	t1.SetSel(start1, -1), t1.SetFont({BkColor:"RED", Color:"WHITE"})
	,t1.SetSel(0, 0), t1.ScrollCaret(), t1Arr.Push(SubStr(t1text, start1 + 1))
	,t2.SetSel(start2, -1), t2.SetFont({BkColor:"GREEN", Color:"WHITE"})
	,t2.SetSel(0, 0), t2.ScrollCaret(), t2Arr.Push(SubStr(t2text, start2 + 1))
	WinActivate,���ֱȽ� ahk_class AutoHotkeyGUI
	ElapsedTime := (A_TickCount - StartTime) / 1000
	ElapsedTime := ZTrim(ElapsedTime)
	CF_ToolTip("�Ƚ���ɡ���ʱ: " ElapsedTime "�롣",3000)
return
}

consolidate(tm, t) 
{
	if tm.Length() > 1 
	{
		loop 
		{
			skip := false
			for k, v in tm
			if (k > 1) && (tm[k-1][2] + 1 = v[1])
			{
				tm[k-1][2] := v[2], skip := k
				break
			}
			if !skip 
			{
				for k, v in tm 
				{
					if (t[v[2]] = t[v[1]-1])
					{
						tm[k][1] := v[1]-1, tm[k][2] := v[2]-1
						break
					}
					if (k = tm.Length())
					break 2
				}
			}
			else 
				tm.RemoveAt(skip)
		}
	}
}

	lineStart(lineArr, index) {		;find line start position
		len := 0
		loop % index - 1
			_len := StrLen(lineArr[A_Index]) ,len += _len + 1
		return len
	}

	wordStart(wordArr, index) { ;find word start position
		len := 0
		loop % index - 1
			len += StrLen(wordArr[A_Index]) + 1
		return len
	}

	lcs(a, b) { ; Longest Common Subsequence of strings, using Dynamic Programming
				; https://rosettacode.org/wiki/Longest_common_subsequence#AutoHotkey
				; https://en.wikipedia.org/wiki/Longest_common_subsequence_problem
				; modified to accept array of strings. Comparison is CASE SENSITIVE.

		len := [], t:= []

		Loop % a.Length() + 2 {   	; Initialize
			i := A_Index - 1
 
			Loop % b.Length() + 2 
{
				j := A_Index - 1, len[i, j] := 0

}

		}
		
		for i, va in a {			; scan a
			i1 := i + 1, x := va
			for j, vb in b {		; scan b
				j1 := j + 1, y := vb
				,len[i1, j1] := x = y ? len[i, j] + 1
							 : (u := len[i1, j]) > (v := len[i, j1]) ? u : v
			}
		}

		x := a.Length() + 1, y := b.Length() + 1
		While x * y {            	; construct solution from lengths
			x1 := x - 1, y1 := y - 1
			If (len[x, y] = len[x1, y])
				x := x1
			Else If  (len[x, y] = len[x, y1])
				y := y1
			Else
				x := x1, y := y1, t.InsertAt(1, a[x])
		}
		Return t
	}

WatchScrollBar:
ActiveWindow := WinExist("A")
if not ActiveWindow  ; û�л����.
    return
ControlGetFocus, FocusedControl, ahk_id %ActiveWindow%
if not FocusedControl  ; û�н���ؼ�.
    return
IfWinActive,���ֱȽ� ahk_class AutoHotkeyGUI
{
t1ScrollPos:=t1.GetScrollPos()
t2ScrollPos:=t2.GetScrollPos()
if (FocusedControl="RICHEDIT50W2")
t1.SetScrollPos(0,t2ScrollPos.Y)
}
IfWinNotExist,���ֱȽ� ahk_class AutoHotkeyGUI
SetTimer, WatchScrollBar, off
return