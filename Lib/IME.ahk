; �����õģ�win8���µ�ϵͳһЩAPIֻ�Ե������Ľ�����Ч
;Gui, Add, Edit, r9 vMyEdit w135, Text to appear 
;gui,show
;return

;^space::
; �Լ��õĿ�ݼ�����ֻ�������ѹ����������������뷨��ɾ����
;if zhcn_sougou
;{
;IME_SetConvMode(0)
;zhcn_sougou:=0
;}
;else
;{
;IME_SetConvMode(1025)
;zhcn_sougou:=1
;}
;sleep ,200
;send {Shift}
;return


IME_Switch_QQPinYin()
{
static i:=0
if !i   ; �����Ѱ�װ��QQƴ�����뷨
{
RegWrite,REG_DWORD, HKCU, Software\Microsoft\CTF\TIP\{AE51F1C0-807F-4A64-AC55-F2ADF92E2603}\LanguageProfile\0x00000804\{96EC4774-55A1-498B-827F-E95D5445B6C1}, Enable,1
i:=1
}
else   ; ��ϵͳ��ɾ��������ʾ��QQƴ�����뷨
{
RegWrite,REG_DWORD, HKCU, Software\Microsoft\CTF\TIP\{AE51F1C0-807F-4A64-AC55-F2ADF92E2603}\LanguageProfile\0x00000804\{96EC4774-55A1-498B-827F-E95D5445B6C1}, Enable,0
i:=0
}
;DllCall("shell32\ShellExecute", uint, 0, str, "RunAs", str, "regsvr32", str, """" A_WinDir (A_PtrSize=8 ? "QQPinyinTsf_x64.dll" : "\system32\ime\QQPinyinTSF\QQPinyinTsf.dll") """", str, A_ScriptDir, int, 1)
return
}

IME_IsENG()
{
temp_Val:=IME_GetConvMode(_mhwnd())
if temp_Val=0
return true
else if (temp_Val=1024)
return true
else 
return false
}

/*
q::
msgbox % IME_GetKeyboardLayoutList()
return
*/

IME_GetKeyboardLayoutList()
{
	if count := DllCall("GetKeyboardLayoutList", "UInt", 0, "Ptr", 0)
		VarSetCapacity(hklbuf, count*A_PtrSize, 0)
	DllCall("GetKeyboardLayoutList", "UInt", count, "UPtr", &hklbuf)
	Loop, %count%
	{
		HKL := NumGet(hklbuf, A_PtrSize*(A_Index-1), "UPtr")   ;  ԭ�ű�Ϊ Ptr  ��Ϊ UPtr
		HKL := Hex2Str(HKL, 8, true)
		HKLList .= A_Index ": " HKL "`n"
	}
return HKLList
}

IME_SwitchToEng()
{
    ; �·������ֻ����һ��
    IME_Switch(0x04090409) ; Ӣ��(����) ��ʽ����
    IME_Switch(0x08040804) ; ����(�й�) ��������-��ʽ����
}

IME_Switch(dwLayout)
{
    HKL := DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
    ControlGetFocus, ctl, A
    SendMessage, 0x50, 0, HKL, %ctl%, A
}

/*
q::
IME_SetLayout("E01F0804")
return
*/
; dwLayout ����Ϊ�ַ��� ���� "E01F0804"
IME_SetLayout(dwLayout,WinTitle="A"){
ControlGet,hwnd,HWND,,,%WinTitle%
    DllCall("SendMessage", "UInt", hwnd, "UInt", "80", "UInt", "1", "UInt", (DllCall("LoadKeyboardLayout", "Str", dwLayout, "UInt", "257")))
}

IME_SwitchLayout(WinTitle="A")
{
ControlGet,hwnd,HWND,,,%WinTitle%
DllCall("SendMessage", UInt, HWND, UInt, 80, UInt, 1, UInt, DllCall("ActivateKeyboardLayout", UInt, 1, UInt, 256))
return
}

/*
q::
IME_UnloadLayout(0xE01F0804)
IME_UnloadLayout(0x08040804)
return
*/
; dwLayout ����Ϊ���� ���� 0xE01F0804
IME_UnloadLayout(dwLayout)
{
DllCall("UnloadKeyboardLayout", "uint",dwLayout)
return
}

_mhwnd()
{
	;background test
	;MouseGetPos,x,,hwnd
	Hwnd := WinActive("A")
Return "ahk_id " . hwnd
}

	; ===============================================================================================================================
; Function......: GetKeyboardLayout
; DLL...........: User32.dll
; Library.......: User32.lib
; U/ANSI........:
; Author........: jNizM
; Modified......:
; Links.........: https://msdn.microsoft.com/en-us/library/ms646296.aspx
;                 https://msdn.microsoft.com/en-us/library/windows/desktop/ms646296.aspx
; ===============================================================================================================================

/* C++ ==========================================================================================================================
HKL WINAPI GetKeyboardLayout(               // Ptr
    _In_  DWORD idThread                   // UInt
);
============================================================================================================================== 
*/
/*
q::
msgbox % IME_GetKeyboardLayout()
return
*/
;                          Ptr       UPtr
; Ӣ������ ��ʽ����    0x4090409    0x4090409
; ���ļ��� ��ʽ����    0x8040804    0x8040804
; ����ABC             -0x1FE0F7FC   0xE01F0804
; �ѹ�ƴ��            -0x1FDDF7FC   0xE0220804
IME_GetKeyboardLayout(WinTitle="A")
{
	ControlGet,hwnd,HWND,,,%WinTitle%
	ThreadID := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "Ptr", 0 )
	; ThreadID ָ���߳�id��0 ��ʾ������
	HKL := DllCall("GetKeyboardLayout", "UInt", ThreadID, "UPtr") ; UPtr ��Ϊ Ptr �õ���һ����ֵ
	HKL := dec2hex(HKL)

Return HKL
}


/*
q::
msgbox % Get_ime_file("E0220804")
return
*/

Get_ime_file(dwLayout){
    ;; ImmGetIMEFileName ����
    ;; http://msdn.microsoft.com/ja-jp/library/cc448001.aspx
    SubKey := Get_reg_Keyboard_Layouts(dwLayout)
    RegRead, ime_file_name, HKEY_LOCAL_MACHINE, %SubKey%, Ime File
    return ime_file_name
}

/*
q::
msgbox % Get_Layout_Text("E01F0804")
return
*/

Get_Layout_Text(dwLayout){
    SubKey := Get_reg_Keyboard_Layouts(dwLayout)
    RegRead, layout_text, HKEY_LOCAL_MACHINE, %SubKey%, Layout Text
    return layout_text
}

Get_reg_Keyboard_Layouts(dwLayout){
    hKL := RegExReplace(dwLayout, "0x", "")
    return "System\CurrentControlSet\control\keyboard layouts\" . hKL ;"
}

/*
w::
tooltip % IME_GetKeyboardLayoutName()
return
*/

; win8֮ǰֻ�Ե��õ����̻߳�ǰ������Ч��
; ��ֻ�Ա��ű���Ч ����ű���Gui�����edit����ؼ����л���������������Ч��
; win7 ���� �ѹ� E0220804 ����ABC E01F0804
IME_GetKeyboardLayoutName()
{
	VarSetCapacity(Str, 16)
	 DllCall("GetKeyboardLayoutName", "Str", Str)
Return Str
}

/*
q::
yy:=DllCall("LoadKeyboardLayout","Str","E01F0804","uint",1, "Int")
IME_ActivateKeyboardLayout(yy)
;DllCall("SystemParametersInfo", "UInt", 0x005A, "UInt", 0, "UPtr", yy, "UInt", 2)
return
*/

; Ϊ�����̻߳�ǰ�������������������ñ�ʶ��(��ǰ��Ϊ���̲��־��)��
; win8֮ǰֻ�Ե��õ����̻߳�ǰ������Ч����ֻ�Ա��ű���Ч��gui����������������Ч��
; �����������ñ�ʶ��ָ�����������Լ����̵������֡�
IME_ActivateKeyboardLayout(HKL)   
{
	; �����ɹ�������ֵ��֮ǰ�������������ñ�ʶ�� HKL
	T := DllCall("ActivateKeyboardLayout", "Int", HKL, "UInt", 0x100, "UInt")
tooltip % T
	If (!T)
	{
		MsgBox, Error.
	}
}

/******************************************************************************
  Name:       IME.ahk
  Language:   Japanease
  Author:     eamat.
  URL:        http://www6.atwiki.jp/eamat/

ԭ��ע��Ϊ���ģ���ҳ���������
�����ű���������ҳ��github����������
*****************************************************************************
��ʷ
    2008.07.11 v1.0.47����߰汾��������������ű�
    2008.12.10 ע������
    2009.07.03 ��� IME_GetConverting()  �����ű�����ɾ���ú�����
               �޸���Last Found Windowδ���õ����⡣
    2009.12.03
      IME ״̬���ʹ��GUIThreadInfo�汾
       ��IE������8��IME״̬Ҳ���Ըı䣩
        http://blechmusik.xrea.jp/resources/keyboard_layout/DvorakJ/inc/IME.ahk
      �ȸ���������µ���
        �ƺ��޷�ȡ������ģʽ��ת��ģʽ
        IME_GET/SET() �� IME_GetConverting()��Ч

    2012.11.10 x64 & Unicode����
      ִ�л�����AHK_L U64 (������Basic��A32,U32��ļ�����)
      LongPtr���������ָ���С��A_PtrSize����

                ;==================================
                ;  GUIThreadInfo 
                ;=================================
                ; ������ GUITreadInfo
            ;typedef struct tagGUITHREADINFO {(x86) (x64)
                ;	DWORD   cbSize;               0     0
                ;	DWORD   flags;                4     4   ��
                ;	HWND	hwndActive;             8     8
                ;	HWND	hwndFocus;             12    16  ��
                ;	HWND	hwndCapture;           16    24
                ;	HWND	hwndMenuOwner;         20    32
                ;	HWND	hwndMoveSize;          24    40
                ;	HWND	hwndCaret;             28    48
                ;	RECT	rcCaret;               32    56
                ;} GUITHREADINFO, *PGUITHREADINFO;

      ������WinTitle����ʵ���Ϻ������������
        ����Ŀ���ǻ����ʱ��ʹ��GetGUIThreadInfo
        ����ʹ��Control���
        �Ұ����Ż�ȥ���Ա��ҿ��Ի�ú�̨IME��Ϣ
        (���������֮�⣬ͨ������ȡ�����Window����ΪControl��ʵ��
        ��Ӧ�ó��������ں�̨��ȷ��ȡֵ
        ����ʹ�������ϵͳ�У����ֻʹ�û����Ҳû�����⣬Ҳ��)
*****************************************************************************
*/
;---------------------------------------------------------------------------
;  ͨ�ú��� (�����IME����ʹ��)

;-----------------------------------------------------------
; IME״̬�Ļ�ȡ
;  WinTitle="A"    ����Window
;  ����ֵ          1:ON / 0:OFF
;-----------------------------------------------------------
IME_GET(WinTitle="A")  {
    hwnd :=GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , Ptr, DllCall("imm32\ImmGetDefaultIMEWnd", Ptr,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          , UPtr, 0x0005  ;wParam  : IMC_GETOPENSTATUS
          ,  Ptr, 0)      ;lParam  : 0
}

;-----------------------------------------------------------
; IME״̬������
;   SetSts          1:ON / 0:OFF
;   WinTitle="A"    ����Window
;   ����ֵ          0:�ɹ� / 0����:ʧ��
;-----------------------------------------------------------
IME_SET(SetSts, WinTitle="A")    {
    hwnd :=GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , Ptr, DllCall("imm32\ImmGetDefaultIMEWnd", Ptr, hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          , UPtr, 0x006   ;wParam  : IMC_SETOPENSTATUS
          ,  Ptr, SetSts) ;lParam  : 0 or 1
}


;===========================================================================
;    0000xxxx    ��������
;    0001xxxx    ���������뷽ʽ
;    xxxx0xxx    ���
;    xxxx1xxx    ȫ��
;    xxxxx000    Ӣ��
;    xxxxx001    ƽ����
;    xxxxx011    Ƭ����

; IME����ģʽ(����IME����)
;   DEC  HEX    BIN
;     0 (0x00  0000 0000)  ����   ��Ӣ��
;     3 (0x03  0000 0011)         �����
;     8 (0x08  0000 1000)         ȫӢ��
;     9 (0x09  0000 1001)         ȫ��ĸ����
;    11 (0x0B  0000 1011)         ȫƬ����
;    16 (0x10  0001 0000)   �����ְ�Ӣ��
;    19 (0x13  0001 0011)         �����
;    24 (0x18  0001 1000)         ȫӢ��
;    25 (0x19  0001 1001)         ƽ����
;    27 (0x1B  0001 1011)         ȫƬ����

;  �� ���������ѡ�� - [��ϸ��Ϣ] - �߼�����
;     - ���߼����ַ���֧��Ӧ�������г���
;    ����ʱ�ƺ��޷���ȡ��ֵ
;    (�ȸ���������±����ڴ˴򿪣������޷����ֵ)

;-------------------------------------------------------
; ��ȡIME����ģʽ
;   WinTitle="A"    ����Window
;   ����ֵ          ����ģʽ
;--------------------------------------------------------

; ����ʱ win10 x64 �Դ����뷨 ���ķ��� 1, Ӣ�ķ��� 0.
; win7 x32
; ���ļ��� ��ʽ����  ���� 0��
; 
;               QQƴ�����뷨��������ģʽ   QQƴ��Ӣ������ģʽ     �ѹ����뷨����      �ѹ����뷨Ӣ��
; ���+���ı��        1025                                        268436481(1025)
; ���+Ӣ�ı��           1��                    1024              268435457(1)        268435456(0)
; ȫ��+���ı��        1033                                        268436489(1033)
; ȫ��+Ӣ�ı��           9                      1032              268435465(9)        268435464(8)

;                ����ABC���������׼ģʽ    ����ABC��������˫��ģʽ    ����ABCӢ�ı�׼   ����ABCӢ��˫��
; ���+���ı��        1025                   -2147482623(1025)          1024               -2147482624
; ���+Ӣ�ı��           1                   -2147483647(1)                0               -2147483648
; ȫ��+���ı��        1033                   -2147482615(1033)          1032               -2147482616
; ȫ��+Ӣ�ı��           9                   -2147483639(9)                8               -2147483640

/*
q::
tooltip % IME_GetConvMode()
return
*/

IME_GetConvMode(WinTitle="A")   {
    hwnd :=GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd)
          , "UInt", 0x0283  ;Message : WM_IME_CONTROL
          ,  "Int", 0x001   ;wParam  : IMC_GETCONVERSIONMODE
          ,  "Int", 0) & 0xffff     ;lParam  : 0 �� & 0xffff ��ʾֻȡ��16λ
}

/*
; ����ʱ �ѹ���ȫ����л���ݼ��ر�ʱ,�����л����ѹ���ȫ��
w::
tooltip % IME_SetConvMode(1)
return
*/

;-------------------------------------------------------
; IME����ģʽ����
;   ConvMode        ����ģʽ
;   WinTitle="A"    ����Window
;   ����ֵ          0:�ɹ� / 0����:ʧ��
;--------------------------------------------------------
IME_SetConvMode(ConvMode, WinTitle="A")   {
    hwnd :=GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd)
          , "UInt", 0x0283      ;Message : WM_IME_CONTROL
          , "UPtr", 0x002       ;wParam  : IMC_SETCONVERSIONMODE
          ,  "Ptr", ConvMode)   ;lParam  : CONVERSIONMODE
}

;===========================================================================
; IME ת��ģʽ(ATOK��ver.16���ԣ����ܻ����в�ͬ������ȡ���ڰ汾)

;   MS-IME  0:��ת�� / 1:����/����                    / 8:ͨ��    /16:����
;   ATOKϵ  0:�̶�   / 1:���ϴ�              / 4:�Զ� / 8:����
;   WXG              / 1:���ϴ�  / 2:�ޱ任  / 4:�Զ� / 8:����
;   SKKϵ            / 1:����(����������ģʽ?)
;   Google��                                          / 8:����
;------------------------------------------------------------------
; IME ת��ģʽ��ȡ
;   WinTitle="A"    ����Window
;   ����ֵ MS-IME  0:��ת�� 1:����/����               8:һ��    16:����
;          ATOKϵ  0:�̶�   1:���ϴ�           4:�Զ� 8:����
;          WXG4             1:���ϴ�  2:��ת�� 4:�Զ� 8:����
;------------------------------------------------------------------
; ����Ϣ��Ӧ�ó����͵����뷨�༭��(IME)���ڣ��Ի�õ�ǰ����ģʽ��
; ����IME���ģʽֵ����ϡ�
; ����ʱ��WIN7 ���л��� �ѹ�ƴ��/����ABC/QQƴ�� ʱ����ֵ��Ϊ0��Ӣ�ļ��̷���ֵΪ8
IME_GetSentenceMode(WinTitle="A")   {
    hwnd :=GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd)
          , "UInt", 0x0283  ;Message : WM_IME_CONTROL
          , "UPtr", 0x003   ;wParam  : IMC_GETSENTENCEMODE
          ,  "Ptr", 0)      ;lParam  : 0
}

;----------------------------------------------------------------
; IME ת��ģʽ����
;   SentenceMode
;       MS-IME  0:�o��Q 1:����/����               8:һ��    16:Ԓ�����~
;       ATOKϵ  0:�̶�   1:�}���Z           4:�Ԅ� 8:�B�Ĺ�
;       WXG              1:�}���Z  2:�o��Q 4:�Ԅ� 8:�B�Ĺ�
;   WinTitle="A"    ����Window
;   ����ֵ          0:�ɹ� / 0����:ʧ��
;-----------------------------------------------------------------
IME_SetSentenceMode(SentenceMode,WinTitle="A")  {
    hwnd :=GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd)
          , "UInt", 0x0283          ;Message : WM_IME_CONTROL
          , "UPtr", 0x004           ;wParam  : IMC_SETSENTENCEMODE
          ,  "Ptr", SentenceMode)   ;lParam  : SentenceMode
}

GetGUIThreadInfo_hwndActive(WinTitle="A")
{
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
	  ptrSize := !A_PtrSize ? 4 : A_PtrSize
	  VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
	  NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
	return  hwnd := DllCall("GetGUIThreadInfo", "Uint", 0, "Ptr", &stGTI)
	             ? NumGet(stGTI, 8+PtrSize, "Ptr") : hwnd
  }
  else
  return  hwnd
}

#include *i %A_ScriptDir%\Lib\����ת��.ahk
#include *i ����ת��.ahk