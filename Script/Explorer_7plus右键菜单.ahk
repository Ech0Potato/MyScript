TriggerFromContextMenu(wParam, lParam){
	Gosub % wparam
	}
Return

regsvr32dll:
	RegisterShellExtension(0)
	gosub savetoreg
Return

unregsvr32dll:
	Msgbox, 4, ע�������չ��?, ����: �����ע�������չ, 7plus ���޷���ʾ`n �����Ĳ˵���. ֻ���������չ������ʱ��������.`n�Ƿ�ȷ��ж�������չ?
	IfMsgbox Yes
	{
		UnregisterShellExtension(0)
		RegDelete, HKCU, Software\7plus\ContextMenuEntries
	}
Return

savetoreg:
	; ����ɾ�����в˵���ע����е���Ŀ
	RegDelete, HKCU, Software\7plus\ContextMenuEntries

	Loop, %A_ScriptDir%\Script\7plus�Ҽ��˵�\*.ahk
	{
		StringTrimRight, FileName, A_LoopFileName, 4
		IniRead,showmenu,%7PlusMenu_ProFile_Ini%,%FileName%,showmenu
		IniRead,7Plus_id,%7PlusMenu_ProFile_Ini%,%FileName%,id
		If (showmenu = 1) && 7Plus_id/7Plus_id
		{
			IniRead,name,%7PlusMenu_ProFile_Ini%,%FileName%,name
			IniRead,Description,%7PlusMenu_ProFile_Ini%,%FileName%,Description
			IniRead,Submenu,%7PlusMenu_ProFile_Ini%,%FileName%,Submenu
			IniRead,Extensions,%7PlusMenu_ProFile_Ini%,%FileName%,FileTypes
			IniRead,SingleFileOnly,%7PlusMenu_ProFile_Ini%,%FileName%,SingleFileOnly,0
			IniRead,Directory,%7PlusMenu_ProFile_Ini%,%FileName%,Directory,0
			IniRead,DirectoryBackground,%7PlusMenu_ProFile_Ini%,%FileName%,DirectoryBackground,0
			IniRead,Desktop,%7PlusMenu_ProFile_Ini%,%FileName%,Desktop,0

			RegWrite, REG_DWORD, HKCU, Software\7plus\ContextMenuEntries\%7Plus_id%, ID, %7Plus_id%
			RegWrite, REG_SZ, HKCU, Software\7plus\ContextMenuEntries\%7Plus_id%, Name,% name
			RegWrite, REG_SZ, HKCU, Software\7plus\ContextMenuEntries\%7Plus_id%, Description, % Description
			RegWrite, REG_SZ, HKCU, Software\7plus\ContextMenuEntries\%7Plus_id%, Submenu, % Submenu
			RegWrite, REG_SZ, HKCU, Software\7plus\ContextMenuEntries\%7Plus_id%, Extensions, % Extensions
			RegWrite, REG_DWORD, HKCU, Software\7plus\ContextMenuEntries\%7Plus_id%, SingleFileOnly, % SingleFileOnly
			RegWrite, REG_DWORD, HKCU, Software\7plus\ContextMenuEntries\%7Plus_id%, Directory, % Directory
			RegWrite, REG_DWORD, HKCU, Software\7plus\ContextMenuEntries\%7Plus_id%, DirectoryBackground, % DirectoryBackground
			RegWrite, REG_DWORD, HKCU, Software\7plus\ContextMenuEntries\%7Plus_id%, Desktop, % Desktop
		}
	}
Return

RegisterShellExtension(Silent=1)
{
	If(Vista7)
	{
		uacrep := DllCall("shell32\ShellExecute", uint, 0, str, "RunAs", str, "regsvr32", str, "/s """ A_ScriptDir "\" (A_PtrSize=8 ? "ShellExtension_x64.dll" : "ShellExtension_x32.dll") """", str, A_ScriptDir, int, 1)
		If(uacrep = 42) ; UAC Prompt confirmed, application may run as admin
		{
			If(!Silent)
				MsgBox �����չ�ѳɹ���װ. ����Ӧ������Դ�������п��Կ��� 7plus �ж�����Ҽ��˵���.
		}
		Else ; Always show error  
			MsgBox , % "�޷���װ�Ҽ��˵������չ," (A_PtrSize=8 ? "ShellExtension_x64.dll" : "ShellExtension_x32.dll") "�ļ��޷�ע��. ���������ԱȨ��!"
	}
	Else ; XP
		run regsvr32 "%A_ScriptDir%\ShellExtension_x32.dll"
}

UnregisterShellExtension(Silent=1)
{
	If(Vista7)
{
		uacrep := DllCall("shell32\ShellExecute", uint, 0, str, "RunAs", str, "regsvr32", str, "/s /u """ A_ScriptDir "\" (A_PtrSize=8 ? "ShellExtension_x64.dll" : "ShellExtension_x32.dll") """", str, A_ScriptDir, int, 1)
		If(uacrep = 42) ;UAC Prompt confirmed, application may run as admin
		{
			If(!Silent)
				MsgBox �����չ�ѳɹ�ж��. ������Դ�������� 7plus �ж�����Ҽ��˵�Ӧ����ʧ��.
		}
		Else ;Always show error
			MsgBox % "�޷�ж���Ҽ��˵������չ," (A_PtrSize=8 ? "ShellExtension_x64.dll" : "ShellExtension_x32.dll") "�ļ��޷�ж��. ���������ԱȨ��!"
}
	Else
		run regsvr32 /u "%A_ScriptDir%\ShellExtension_x32.dll"
}