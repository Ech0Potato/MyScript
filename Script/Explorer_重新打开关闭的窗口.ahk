
; recieve window message about windows creation and etc
ShellWM(wp,lp)
{
	;static wm := {1:"CREATED",2:"DESTROYED",4:"ACTIVATED",6:"REDRAW"}
	if (wp = 1 || wp = 4)
	{
if folder.HasKey(lp)
return
WinGet,ProcessName,ProcessName,ahk_id %lp%
if ProcessName = explorer.exe
{
;Clipboard := GetShellFolderPath()
folder.InsertAt(lp,{cmd:GetShellFolderPath()})
;msgbox % GetShellFolderPath()
}
}
	else if (wp = 2)
	{
if folder.HasKey(lp)
{
if folder[lp].cmd
{
if CloseWindowList.Length() = 9
CloseWindowList.RemoveAt(1)
CloseWindowList.Push(folder[lp].cmd)
IniWrite,% folder[lp].cmd, %run_iniFile%,����, LastClosewindow
}
folder.Remove(lp)
}
}
 else if (wp = 6)
    {
if folder.HasKey(lp)
{
folder[lp].cmd := GetShellFolderPath(lp)
;Clipboard := folder[lp].cmd
}
}
}

; retrieve folder path in the specified shell browser. If hwnd is omitted, get hwnd of activated window
GetShellFolderPath(hwnd=0)
{
	static shell := ComObjCreate("Shell.Application")
	if !hwnd
		hwnd := WinExist("A")
	for k in shell.windows
	{
		if (k.hwnd = hwnd)
		{
			if (k.Document.Folder.Self)
				return k.Document.Folder.Self.Path
		}
	}
return explorer.exe
}

!/::   ;������
tooltip % ShutdownBlock  ;������
CloseWindowListMenuShow:
menu,CloseWindowListMenu,add,����رմ����б�,nul
Menu, CloseWindowListMenu, disable, ����رմ����б�
Menu, CloseWindowListMenu, add
loop, % CloseWindowList.Length()
{
AddItem("CloseWindowListMenu",CloseWindowList[CloseWindowList.Length() +1 - a_index],CloseWindowList.Length() +1 - a_index)
}
menu CloseWindowListMenu, show
Menu, CloseWindowListMenu, DeleteAll
return

AddItem(argMenu, argPath,index)
{
MenuArray := {"::{645FF040-5081-101B-9F08-00AA002F954E}":"����վ","::{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}":"����","::{20D04FE0-3AEA-1069-A2D8-08002B30309D}":"�����","::{26EE0668-A00A-44D7-9371-BEB064C98683}":"�������","::{031E4825-7B94-4DC3-B131-E946B44C8DD5}":"��","Documents.library-ms":"�ĵ���","Music.library-ms":"���ֿ�","Pictures.library-ms":"ͼƬ��","Videos.library-ms":"��Ƶ��","::{7B81BE6A-CE2B-4676-A29E-EB907A5126C5}":"����͹���","::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{7007ACC7-3202-11D1-AAD2-00805FC1270E}":"��������","::{8E908FC9-BECC-40F6-915B-F4CA0E70D03D}":"����͹�������","::{BB06C0E4-D293-4F75-8A90-CB05B6477EEE}":"ϵͳ","::{60632754-C523-4B62-B45C-4172DA012619}":"�û��ʻ�","::{78F3955E-3B90-4184-BD14-5397C15F1EFC}\PerfCenterAdvTools":"�߼�����","::{ED834ED6-4B5A-4BFE-8F11-A626DCB6A921}":"���Ի�","::{05D7B0F4-2121-4EFF-BF6B-ED3F69B894D9}":"֪ͨ����ͼ��","::{78F3955E-3B90-4184-BD14-5397C15F1EFC}":"������Ϣ�͹���","::{C555438B-3C23-4769-A71F-B6D3D9B6053A}":"��ʾ","::{BB64F8A7-BEE7-4E1A-AB8D-7D8273F7FDB6}":"��������","::{025A5937-A6BE-4686-A844-36FE4BEC8B6D}":"��Դѡ��"}
IfInString, argPath, ::{
{
StringReplace, argPath, argPath, ::{26EE0668-A00A-44D7-9371-BEB064C98683}\0\
StringReplace, argPath, argPath,::{031E4825-7B94-4DC3-B131-E946B44C8DD5}\
temp_key:= MenuArray[ argPath ]
MenuItemName := temp_key ? temp_key : argPath
}
else
MenuItemName:=Strlen(argPath)>20 ? SubStrW(argPath,1,10) . "..." . SubStrW(argPath,-10) : argPath
MenuItemName := index ". " MenuItemName
menu, %argMenu%, add, %MenuItemName%, ItemRun
}
 
ItemRun:
run % "explorer.exe " CloseWindowList[CloseWindowList.Length() + 3 - A_ThisMenuItemPos]
CloseWindowList.RemoveAt(CloseWindowList.Length() + 3 - A_ThisMenuItemPos)
return