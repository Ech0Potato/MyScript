;LAlt & MButton::  ; һ���򿪵�ǰ����ڵ�����Ŀ¼
���ڳ�������Ŀ¼:
Sleep,100
WinGet,ProcessPath,ProcessPath,A
Run,% "explorer.exe /select," ProcessPath 
sleep,500
Send,{Alt Down}
sleep,500
Send,{Alt Up}
Return

;RAlt & MButton::
���ĵ�����Ŀ¼:
WinGet pid, PID, A 
WinGetActiveTitle _Title
WinGet,ProcessPath,ProcessPath,A 

;���ڱ�����·���Ĵ���ֱ�ӻ�ȡ���ڱ�������
IfInString,_Title,:\ 
{  
; ƥ��Ŀ¼����ƥ���ļ�
;FullNamell:=RegExReplace(_Title,"^.*(.:(\\)?.*)\\.*$","$1")
; �༭���ļ��޸ĺ���⿪ͷ����*��
RegExMatch(_Title, "i)^\*?\K.*\..*(?= [-*] )", FileFullPath)
If FileFullPath
  goto OpenFileFullPath
}

/*
; ��ʽһ
; ·�������ſ�ʶ��  �������Ų���
RegExMatch(CMDLine, "Ui) ""([^""]+)""", ff_)
*/

/*
; ��ʽ��
RegExMatch(CMDLine, "i).*exe.*?\s+(.*)", ff_)   ; ����ƥ�������в���
; �������������в��ܵõ�·��  ���� a.exe /resart "D:\123.txt"
startzimu:=RegExMatch(ff_1, "i)^[a-z]")

 if !startzimu
{
RegExMatch(ff_1, "i).*?\s+(.*)", fff_)
StringReplace,FullName,fff_1,`",,All
}
else
StringReplace,FullName,ff_1,`",,All

if FullName<>
run % "explorer.exe /select,"  FullName 
*/

/*
;��ʽ��
;FullName:=RegExReplace(CMDLine,"^.*(.:(\\)?.*)\\.*$","$1",6)      ;ֱ�ӵõ��������ļ�����·��
;Run,%FullName%
*/

;tooltip % FullName

;tooltip % Ff_1 "-" CMDLine
;if ff_1<>
;Run, % "explorer.exe /select,"  ff_1

;;;;;;;;;;;;;;��ȡ������;;;;;;;;;
;WMI_Query("\\.\root\cimv2", "Win32_Process")
CMDLine:= WMI_Query(pid)

RegExMatch(CMDLine, "i).*exe.*?\s+(.*)", ff_)   ; ����ƥ�������в���
; �������������в��ܵõ�·��  ���� a.exe /resart "D:\123.txt"
; �����в����д򿪵��ļ���Щ�����  ��"������"���ļ�·��"�� ��Щ���򲻴� ��"�������ļ�·����
StringReplace,FileFullPath,ff_1,`",,All
startzimu:=RegExMatch(FileFullPath, "i)^[a-z]")

 if !startzimu
{
RegExMatch(FileFullPath, "i)([a-z]:\\.*\.\S*)", fff_)
FileFullPath:=fff_1
}

if FileFullPath<>
 goto OpenFileFullPath

; RealPlayer
IfInString,_Title,RealPlayer
{
DetectHiddenText, On
SetTitleMatchMode, Slow
WinGetText, _Title, %_Title%
IfInString,_Title,:/
{
;RealPlayerʽ����file://N:/��Ӱ/С��Ƶ/���ٲ�¥���ؿ�����ȷ�ĵ�����Ȧ�ռ����� ����.flv
StringReplace,_Title,_Title,/,\,1
Loop, parse, _Title, `n, `r
 {
	StringTrimLeft,FileFullPath,A_LoopField,7
  If FileFullPath
  gosub OpenFileFullPath
 }
}
DetectHiddenText,Off
SetTitleMatchMode,fast
Return
}

; Word��WPS��Excel��et����
FileFullPath:=getDocumentPath(ProcessPath)  
if FileFullPath<>
  goto OpenFileFullPath

; ֱ�Ӵ򿪼��±�����Ȼ����ı��ļ���������û���ļ�·����ʹ�ö�ȡ�ڴ�ķ����õ�·��
IfInString,_Title,���±�
{
If(_Title="�ޱ��� - ���±�")
{
FileFullPath:=_Title:=pid:=ProcessPath:=startzimu:=ff_:=ff_1:=fff_:=fff_1=""
Return
}
WinGet, hWnd, ID, A
FileFullPath := JEE_NotepadGetPath(hWnd)
if FileFullPath<>
 gosub OpenFileFullPath
}

; ��������
FileFullPath:=_Title:=pid:=ProcessPath:=startzimu:=ff_:=ff_1:=fff_:=fff_1=""
Return

OpenFileFullPath:
	;QQ Ӱ��  �ļ�·��ĩβ����*����
	FileFullPath:=Trim(FileFullPath,"`*")
	If Fileexist(FileFullPath)
	{
		Run,% "explorer.exe /select," FileFullPath
		FileFullPath:=_Title:=pid:=ProcessPath:=""
		Return
	}
	else
	{
		RegExMatch(FileFullPath, "i)^\*?\K.*\..*(?= [-*] )", FileFullPath)
		If Fileexist(FileFullPath)
		{
			Run,% "explorer.exe /select," FileFullPath
			FileFullPath:=_Title:=pid:=ProcessPath:=""
			Return
		}
		Splitpath,FileFullPath,,Filepath
		If Fileexist(Filepath)
		{
			Msgbox,% "Ŀ���ļ������� " FileFullPath "��`r`n" "���ļ�����Ŀ¼ " Filepath "��"
			Run,% Filepath
			FileFullPath:=_Title:=pid:=ProcessPath:=""
			Return
		}
	}
Return

getDocumentPath(_ProcessPath)  
  {  
SplitPath,_ProcessPath,,,,Process_NameNoExt  
    value:=Process_NameNoExt  
      
    If IsLabel( "Case_" . value)  
        Goto Case_%value%  

Case_WINWORD:  ;Word OpusApp
  Application:= ComObjActive("Word.Application") ;word
  ActiveDocument:= Application.ActiveDocument ;ActiveDocument
Return  % ActiveDocument.FullName
Case_EXCEL:  ;Excel XLMAIN
  Application := ComObjActive("Excel.Application") ;excel
  ActiveWorkbook := Application.ActiveWorkbook ;ActiveWorkbook
Return % ActiveWorkbook.FullName
Case_POWERPNT:  ;Powerpoint PPTFrameClass
  Application:= ComObjActive("PowerPoint.Application") ;Powerpoint
  ActivePresentation := Application.ActivePresentation ;ActivePresentation
Return % ActivePresentation.FullName
Case_WPS:
Application := ComObjActive("kWPS.Application")
if !Application
Application := ComObjActive("WPS.Application")
ActiveDocument:= Application.ActiveDocument
Return  % ActiveDocument.FullName
Case_ET:
Application := ComObjActive("ket.Application")
if !Application
Application := ComObjActive("et.Application")
  ActiveWorkbook := Application.ActiveWorkbook ;ActiveWorkbook
Return % ActiveWorkbook.FullName
Case_WPP:
Application := ComObjActive("kWPP.Application")
if !Application
Application := ComObjActive("wpp.Application")
  ActivePresentation := Application.ActivePresentation ;ActivePresentation
Return % ActivePresentation.FullName
}