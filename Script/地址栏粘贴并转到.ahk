; http://www.autohotkey.com/forum/topic68446.html

#ifwinexist, ahk_class #32768   ;�Ҽ��˵�
~lbutton::
	sleep,1000
	SetTimer,Monitormenuclick,off
return
#ifwinexist

Monitormenuclick:
	ContextMenCnt := DllCall("GetMenuItemCount", "Uint", hMenu)

	loop, %ContextMenCnt%
	{
		idx :=A_Index-1
		state := MenuState(hMenu,idx)
		if (state = 128)  ; �����˵� MFS_HILITE 0x00000080
		{
			;IsEnabled := GetContextMenuState(hMenu, idx)
			idn := DllCall("GetMenuItemID", "Uint", hMenu, "int", idx)
			nSize++ := DllCall("GetMenuString", "Uint", hMenu, "int", idx, "Uint", 0, "int", 0, "Uint", 0x400)
			nSize := (nSize * (A_IsUnicode ? 2 : 1))
			VarSetCapacity(sString, nSize)
			DllCall("GetMenuString", "Uint", hMenu, "int", idx, "str", sString, "int", nSize, "Uint", 0x400)   ; MF_BYPOSITION
			if (current_id <> IDn)
				current_id := IDn
		}
		; �򿪲˵����һ�ε�� ճ������ ����Ч
		; ����Ҫ�ٴδ򿪲˵�
		;tooltip % current_id "-" sString
		If (current_id <> 0)
		{
			; If mouse clicked or Enter pressed       
			If (_IsPressed("01") || _IsPressed("0D") || GetKeyState("Enter","P") || GetKeyState("LButton","P"))
			{
				While, (_IsPressed("0D") || _IsPressed("01"))
					Sleep 10

				If (current_id = 4097) & (sString="ճ������"){
					sleep,200
					sendevent,{del}{ctrldown}v{ctrlup}{enter}
					sleep,200
					sString =
					current_id := 0
					keystate := ""   
				}     
			}
		}
	}
return

addmenuitem:
	;settimer, reactivate, -300
	clsn:=WinGetClass(hWndnow)
	WinGet, active_id, ID, A
	wingetclass, act_class,ahk_id %active_id%
	if act_class in CabinetWClass,IEframe
	{
		if(clsn="edit"){
			;tooltip % act_class
			STR_TEST := "ճ������"
			Position=1 ; top position
			uFlags:=0x40 ;pop menu
			uIDNewItem=0x1001
			WinWait, ahk_class #32768
			SendMessage, 0x1E1, 0, 0      ; MN_GETHMENU
			hMenu := ErrorLevel
			;Result := DllCall("AppendMenu", Int,hMenu, Int,uFlags, Int,uIDNewItem, Str,STR_TEST)
			hMenuItem := DllCall("GetMenuItemID", "uint", hMenu, "int", MenuItemIndex - 1)
			DllCall("InsertMenu", "int", hMenu, "int", Position - 1 , "int", 0x400, "int", uIDNewItem, "int", &STR_TEST)
			SetTimer,Monitormenuclick,300
		}
	}
return

HookProcMenu( hWinEventHook, Event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime )
{
	global namcls, hwndNow
	wingetclass, namcls, ahk_id %hwnd%
	if (Event=0x4 )     {
		hwndNow:=hwnd
		gosub,addmenuitem
	}
}

HookProc(hWinEventHook2, Event, hWnd)
{
	global ShutdownBlock
	static hShutdownDialog
	Event += 0
	if Event = 8 ; EVENT_SYSTEM_CAPTURESTART
	{
		WinGetClass, Class, ahk_id %hWnd%
		WinGetTitle, Title, ahk_id %hWnd%
		if (Class = "Button" and Title = "ȷ��")
		{
			ControlGet, Choice, Choice, , ComboBox1, ahk_id %hShutdownDialog%
			if Choice in ע��,��������,�ػ�,Install updates and shut down
				ShutdownBlock := false
		}
	}
	else if Event = 16 ; EVENT_SYSTEM_DIALOGSTART
	{
		WinGetClass, Class, ahk_id %hWnd%
		WinGetTitle, Title, ahk_id %hWnd%
		If (Class = "#32770" and Title = "�ر� Windows")
			hShutdownDialog := hWnd
	}
	else if Event = 17 ; EVENT_SYSTEM_DIALOGEND
		hShutdownDialog =
}

WinGetClass( hwnd )
{
	WinGetClass, wclass, ahk_id %hwnd%
	Return wclass
}

SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags)
{
	return DllCall("SetWinEventHook"
	, Uint,eventMin
	, Uint,eventMax
	, Uint,hmodWinEventProc
	, Uint,lpfnWinEventProc
	, Uint,idProcess
	, Uint,idThread
	, Uint,dwFlags)
}

UnhookWinEvent()
{
	Global
	QQ:=DllCall( "UnhookWinEvent", Uint,hWinEventHook )
	qw:=DllCall( "GlobalFree", UInt,HookProcAdr ) ; free up allocated memory for RegisterCallback
	; tooltip % "�ɹ�Ϊ0��" qw
	;DllCall( "UnhookWinEvent", Uint,hWinEventHook2 )
	;DllCall( "GlobalFree", UInt,&HookProcAdr2 )  
	; &HookProcAdr ���������쳣�˳�  ��Ϊ HookProcAdr��֪���Ƿ���ͬ��Ч��
}



/***************************************************************
* returns the state of a menu entry
***************************************************************
*/
GetContextMenuState(hMenu, Position)
{
	; We need to allocate a struct
	VarSetCapacity(MenuItemInfo, 60, 0)
	; Set Size of Struct to the first member
	NumPut(A_PtrSize=8?80:48, MenuItemInfo, 0, "UInt")
	; Get only Flags from dllcall GetMenuItemInfo MIIM_TYPE = 1
	NumPut(1, MenuItemInfo, 4, "UInt")

	; GetMenuItemInfo: Handle to Menu, Index of Position, 0=Menu identifier / 1=Index
	InfoRes := DllCall("user32.dll\GetMenuItemInfo",Ptr,hMenu, Uint, Position, uint, 1, Ptr, &MenuItemInfo)

	InfoResError := errorlevel
	LastErrorRes := DllCall("GetLastError")
	if InfoResError <> 0
		return -1
	if LastErrorRes != 0
		return -1

	; Get Flag from struct
	GetMenuItemInfoRes := NumGet(MenuItemInfo, 12, "UInt")
	/*
	IsEnabled = 1
	if GetMenuItemInfoRes > 0
	IsEnabled = 0
	return IsEnabled
	*/
return GetMenuItemInfoRes
}

_IsPressed(sHexKey)
{
	; $hexKey must be the value of one of the keys.
	; _Is_Key_Pressed will return 0 if the key is not pressed, 1 if it is.
	Rt := DllCall("GetAsyncKeyState", "int", "0x" . sHexKey)
	Return (RT & 0x8000) <> 0
}

MenuState(hSubMenu, index)
{
VarSetCapacity(mii,48,0)
NumPut(48, mii, 0)
; Set the mask to whatever you want to retrieve.
; In this case I set it to MIIM_STATE=1.
NumPut(1, mii, 4)
; Note that menu item positions are zero-based.
DllCall("GetMenuItemInfo", "UInt", hSubMenu, "UInt", index, "UInt", true, "UInt", &mii)
; Get the state field out of the struct.
fState := NumGet(mii, 12)
return fState
}