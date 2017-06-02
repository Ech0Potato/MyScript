; wString	ת����õ���unicode�ִ�
; sString		��ת���ִ�
; CP					��ת���ִ�sString�Ĵ���ҳ
; ����ֵ		ת����õ���unicode�ִ�,wString�ĵ�ַ
Ansi2Unicode(ByRef wString,ByRef sString,  CP = 0)
;cp=65001 UTF-8   cp=0 default to ANSI code page
{
; �ú���ӳ��һ���ַ��� (MultiByteStr) ��һ�����ַ� (unicode UTF-16) ���ַ��� (WideCharStr)��
; �ɸú���ӳ����ַ���û��Ҫ�Ƕ��ֽ��ַ��顣
; &sString ������ǵ�ַ������ sString ��������ֱ�Ӵ����ַ
/* 
; A����������
pp=����
Ansi2Unicode(qq,pp,936) ; ��ȷ
Ansi2Unicode(qq,&pp,936) ; ����
*/
     nSize := DllCall("MultiByteToWideChar"
      , "Uint", CP
      , "Uint", 0
      , "Uint", &sString   ; ��������ִ��ĵ�ַ
      , "int",  -1
      , "Uint", 0
      , "int",  0)

   VarSetCapacity(wString, nSize * 2,0)

   DllCall("MultiByteToWideChar"
      , "Uint", CP
      , "Uint", 0
      , "Uint", &sString
      , "int",  -1
      , "Uint", &wString
      , "int",  nSize)
Return	&wString
}

; wString	��ת����unicode�ִ�  
; sString		ת����õ����ִ�
; CP					ת����õ����ִ�sString�Ĵ���ҳ������ CP=65001��ת���õ����ִ�����UTF8���ַ���
; ����ֵ		ת����õ����ִ�sString
Unicode2Ansi(ByRef wString,ByRef sString,  CP = 0)
{
; �ú���ӳ��һ�����ַ��� (unicode UTF-16) ��һ���µ��ַ���
; �ѿ��ַ��� (unicode UTF-16) ת����ָ������ҳ�����ַ���
; &wString ������ǵ�ַ������wString��������ֱ�Ӵ����ַ
/* 
; U����������
qq=����
Unicode2Ansi(qq,pp,936) ; ��ȷ
Unicode2Ansi(&qq,pp,936) ; ����
*/
	nSize:=DllCall("WideCharToMultiByte", "Uint", CP, "Uint", 0, "Uint", &wString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)

	VarSetCapacity(sString, nSize)
	DllCall("WideCharToMultiByte", "Uint", CP, "Uint", 0, "Uint", &wString, "int", -1, "str", sString, "int", nSize, "Uint", 0, "Uint", 0)
	Return	sString
}

; Unicode2Ansi pString �� sString
Ansi4Unicode(pString, nSize = "")
{
; pString �ǵ�ַ��������ֱ�Ӵ����ַ
/* 
; ��
pp=����
Ansi4Unicode(&pp)
*/
	If (nSize = "")
		nSize:=DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
	VarSetCapacity(sString, nSize)
	DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize + 1, "Uint", 0, "Uint", 0)
	Return	sString
}

; Ansi2Unicode  sString �� wString
Unicode4Ansi(ByRef wString, sString, nSize = "")
{
	If (nSize = "")
	    nSize:=DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2 + 1)
	DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize + 1)
	Return	&wString
}

UrlEncode(Url, Enc = "UTF-8")
{
StrPutVar(Url, Var, Enc)
f := A_FormatInteger
SetFormat, IntegerFast, H
Loop
{
Code := NumGet(Var, A_Index - 1, "UChar")
If (!Code)
Break
If (Code >= 0x30 && Code <= 0x39 ; 0-9
|| Code >= 0x41 && Code <= 0x5A ; A-Z
|| Code >= 0x61 && Code <= 0x7A) ; a-z
Res .= Chr(Code)
Else
Res .= "%" . SubStr(Code + 0x100, -1)
}
SetFormat, IntegerFast, %f%
Return, Res
}
; UrlEncode("���|����", "cp20936")
; GB2312 GBK  936
; cp10002��MAC���ϵ�big5���룬
; 950��ANSI�ı�׼


UrlDecode(Url, Enc = "UTF-8")
{
Pos := 1
Loop
{
Pos := RegExMatch(Url, "i)(?:%[\da-f]{2})+", Code, Pos++)
If (Pos = 0)
Break
VarSetCapacity(Var, StrLen(Code) // 3, 0)
StringTrimLeft, Code, Code, 1
Loop, Parse, Code, `%
NumPut("0x" . A_LoopField, Var, A_Index - 1, "UChar")
StringReplace, Url, Url, `%%Code%, % StrGet(&Var, Enc), All
}
Return, Url
}

StrPutVar(Str, ByRef Var, Enc = "")
{
Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
VarSetCapacity(Var, Len, 0)
Return, StrPut(Str, &Var, Enc),VarSetCapacity(var,-1)
}

; ; �������ģ��������뷨Ӱ��
_SendRaw(Keys)
{
Len := StrLen(Keys) ; �õ��ַ����ĳ��ȣ�ע��һ�������ַ��ĳ�����2
KeysInUnicode := "" ; ��Ҫ���͵��ַ�����
Char1 := "" ; �ݴ��ַ�1
Code1 := 0 ; �ַ�1��ASCII�룬ֵ���� 0x0-0xFF (��1~255)
Char2 := "" ; �ݴ��ַ�2
Index := 1 ; ����ѭ��
Loop
{
Code2 := 0 ; �ַ�2��ASCII��
Char1 := SubStr(Keys, Index, 1) ; ��һ���ַ�
Code1 := Asc(Char1) ; �õ���ASCIIֵ
if(Code1 >= 129 And Code1 <= 254 And Index < Len) ; �ж��Ƿ������ַ��ĵ�һ���ַ�
{
Char2 := SubStr(Keys, Index+1, 1) ; �ڶ����ַ�
Code2 := Asc(Char2) ; �õ���ASCIIֵ
if(Code2 >= 64 And Code2 <= 254) ; ������������˵���������ַ�
{
Code1 <<= 8 ; ��һ���ַ�Ӧ�ŵ���8λ��
Code1 += Code2 ; �ڶ����ַ����ڵ�8λ��
}
Index++
}
if(Code1 <= 255) ; �����ֵ��<=255��˵���Ƿ������ַ������򾭹�����Ĵ����Ȼ����255
Code1 := "0" . Code1
KeysInUnicode .= "{ASC " . Code1 . "}"
if(Code2 > 0 And Code2 < 64)
{
Code2 := "0" . Code2
KeysInUnicode .= "{ASC " . Code2 . "}"
}
Index++
if(Index > Len)
Break
}
Send % KeysInUnicode
}

; http://ahk8.com/thread-5385.html
; �������ģ��������뷨Ӱ��
SendStr(String)
{
    if(A_IsUnicode)
    {
        Loop, Parse, String
            ascString .= (Asc(A_loopfield)>127 )? A_LoopField : "{ASC 0" . Asc(A_loopfield) . "}"
    }
    else     ;�����Unicode
    {
        z:=0
        Loop,parse,String
        {
            if RegExMatch(A_LoopField, "[^x00-xff]")
            {
                if (z=1)
                {
                    x<<= 8
                    x+=Asc(A_loopfield)
                    z:=0
                    ascString .="{ASC 0" . x . "}"
                }
                else
                {
                    x:=asc(A_loopfield)
                    z:=1
                }
            }
            else
            {
                ascString .="{ASC 0" . Asc(A_loopfield) . "}"
            }
        }
    }
    SendInput %ascString%
}