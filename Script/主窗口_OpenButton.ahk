;��������������ַ������
openbutton:
   Gui, Submit, NoHide
   if (Substr(dir,1,5) ="@Cmd@")
   {
    dir:=SubStr(dir,6)
    run, %comspec% /k "%dir%"
   Return
   }
   if (Substr(dir,1,7) ="@Proxy@")
   {
   dir:=SubStr(dir,8)
   if dir<>
   {
   regwrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyServer,%dir%
   if regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 1
   {
   regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,0
   MsgBox,��ȡ��IE����
   }
   else if regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 0
   {
   regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,1
   MsgBox, IE����������Ϊ��%dir%����ȡ�����ٴ����б����
   }
   dllcall("wininet\InternetSetOptionW","int","0","int","39","int","0","int","0")
   dllcall("wininet\InternetSetOptionW","int","0","int","37","int","0","int","0")
   Return
   }
   else
   {
   if regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 1
   {
   regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,0
   MsgBox,��ȡ��IE����
   }
   else if regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 0
   {
   regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,1
   dir :=% regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer")
   MsgBox, IE����������Ϊ��%dir%����ȡ�����ٴ����б����
   }
   dllcall("wininet\InternetSetOptionW","int","0","int","39","int","0","int","0")
   dllcall("wininet\InternetSetOptionW","int","0","int","37","int","0","int","0")
   Return
   }
   }

   if (Substr(dir,1,11) ="@UrlDecode@")
   {
   dir:=SubStr(dir,12)

   if dir<>
   {
GuiControl,text,Dir,
q:=% UrlDecode(dir)          ;Ĭ��ʹ��UTF-8����ת��
GuiControl,text,Dir,%q%
q:=
Return
}
else
{                   ;���Ƶ���������ַ���ʹ��GBK����ת��
   if Clipboard<>
  {
 q:=% UrlDecode(Clipboard,CP936)
 GuiControl,text,Dir,%q%
q:=
Return
}
else
return
}
}

   if (Substr(dir,1,11) ="@UrlEncode@")
   {
   dir:=SubStr(dir,12)
      if dir<>
   {
GuiControl,text,Dir,
 q:=% UrlEncode(dir)      ;Ĭ��ʹ��UTF-8����ת��
GuiControl,text,Dir,%q%
q:=
Return
}
else
{               ;���Ƶ���������ַ���ʹ��GBK����ת��
  if Clipboard<>
  {
 q:=% UrlEncode(Clipboard,CP936)
 GuiControl,text,Dir,%q%
q:=
Return
}
else
return
}
}

 if(RegExMatch(dir,"i)^(HKCU|HKCR|HKCC|HKU|HKLM|HKEY_)"))
{
gosub regedit
return
}

   if (Substr(dir,1,8) ="@ExeAhk@")
   {
    dir:=SubStr(dir,9)
    pipe_name := "����Ahk����"
; Before reading the file, AutoHotkey calls GetFileAttributes(). This causes
; the pipe to close, so we must create a second pipe for the actual file contents.
; Open them both before starting AutoHotkey, or the second attempt to open the
; "file" will be very likely to fail. The first created instance of the pipe
; seems to reliably be "opened" first. Otherwise, WriteFile would fail.
pipe_ga := CreateNamedPipe(pipe_name, 2)
pipe    := CreateNamedPipe(pipe_name, 2)
if (pipe=-1 or pipe_ga=-1) {
    MsgBox CreateNamedPipe failed.
    ExitApp
}

Run, %A_AhkPath% "\\.\pipe\%pipe_name%"

; Wait for AutoHotkey to connect to pipe_ga via GetFileAttributes().
DllCall("ConnectNamedPipe","uint",pipe_ga,"uint",0)
; This pipe is not needed, so close it now. (The pipe instance will not be fully
; destroyed until AutoHotkey also closes its handle.)
DllCall("CloseHandle","uint",pipe_ga)
; Wait for AutoHotkey to connect to open the "file".
DllCall("ConnectNamedPipe","uint",pipe,"uint",0)

; AutoHotkey reads the first 3 bytes to check for the UTF-8 BOM "???". If it is
; NOT present, AutoHotkey then attempts to "rewind", thus breaking the pipe.
dir := chr(239) chr(187) chr(191) dir

if !DllCall("WriteFile","uint",pipe,"str",dir,"uint",StrLen(dir)+1,"uint*",0,"uint",0)
    MsgBox WriteFile failed: %ErrorLevel%/%A_LastError%

DllCall("CloseHandle","uint",pipe)
return
}

   Transform,dir,Deref,%Dir%
   run,%Dir%,,UseErrorLevel
     if ErrorLevel
     {
        ErrorLevel = 0
        if dir contains +,~,!,^,=,(,),{,},[,],/,<,>,|,;,:,*,%A_Space%,\,
          {
          msgbox,4,��������ѡ��,�ٶ�������"��"��google��"��"
                ifmsgbox yes     
               run http://www.baidu.com/s?wd=%Dir% 
               ifmsgbox no
               run https://www.google.com.hk/search?hl=zh-CN&q=%Dir%
          return
          }
        if % %dir%
          {
          return 
          run,% %Dir%,,UseErrorLevel
              if ErrorLevel
                {
                msgbox,4,��������ѡ��,�ٶ�������"��"��google��"��"
                  ifmsgbox yes     
                  run http://www.baidu.com/s?wd=%Dir% 
                  ifmsgbox no
                 run https://www.google.com.hk/search?hl=zh-CN&q=%Dir%
                return
               }
          }
        else 
        {
          msgbox,4,��������ѡ��,�ٶ�������"��"��google��"��"
            ifmsgbox yes     
              run http://www.baidu.com/s?wd=%Dir% 
            ifmsgbox no
              run https://www.google.com.hk/search?hl=zh-CN&q=%Dir%
        }
      }
Return

CreateNamedPipe(Name, OpenMode=3, PipeMode=0, MaxInstances=255) {
    return DllCall("CreateNamedPipe","str","\\.\pipe\" Name,"uint",OpenMode
        ,"uint",PipeMode,"uint",MaxInstances,"uint",0,"uint",0,"uint",0,"uint",0)
}

RegRead(RootKey, SubKey, ValueName = "") {
   RegRead, v, %RootKey%, %SubKey%, %ValueName%
   Return, v
}

regedit:
Loop, parse, A_GuiEvent, `n, `r
{
   Gui, Submit, NoHide
If(ErrorLevel = 1)
           ExitApp
;�滻�ִ��е�һ������ ��Ϊ"\"
StringReplace,dir,dir,`,%A_Space%,\
;�滻�ִ��е�һ��������Ϊ"\"
StringReplace,dir,dir,`, ,\
IfInString, dir,HKLM
{
   StringTrimLeft, cutdir, dir, 4
   dir := "HKEY_LOCAL_MACHINE" . cutdir
}
IfInString, dir,HKCR
{
   StringTrimLeft, cutdir, dir, 4
   dir := "HKEY_CLASSES_ROOT" . cutdir
}
IfInString, dir,HKCC
{
   StringTrimLeft, cutdir, dir, 4
   dir := "HKEY_CURRENT_CONFIG" . cutdir
}
IfInString, dir,HKCU
{
   StringTrimLeft, cutdir, dir, 4
   dir := "HKEY_CURRENT_USER" . cutdir
}
IfInString, dir,HKU
{
   StringTrimLeft, cutdir, dir, 3
   dir := "HKEY_USERS" . cutdir
}
;���ִ��е����С��ܡ�(ȫ��)�滻Ϊ��\������ǣ�
StringReplace,dir,dir,��,\,All
StringReplace,dir,dir,%A_Space%\,\,All
StringReplace,dir,dir,\%A_Space%,\,All

;���ִ��е����С�\\���滻Ϊ��\��
StringReplace,dir,dir,\\,\,All

IfWinExist, ע���༭�� ahk_class RegEdit_RegEdit
{
IfNotInString, dir, �����\
dir := "�����\" . dir
WinActivate, ע���༭��
ControlGet, hwnd, hwnd, , SysTreeView321, ע���༭��
TVPath_Set(hwnd, dir, matchPath)
}
Else
{
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %dir%
Run, regedit.exe -m
}
}
Return