; ע����ʱ��ת����Ӧ��Ŀ ������_OpenButton.ahk
; ����ע�����Ӧ��Ŀ·��  ע���.ahk

;TVPath_Get()      Written By wz520 [wingzero1040~gmail.com]
;��ȡ���� TreeView �ؼ���ѡ����Ŀ��·������ʽ�� Root\Parent\SelectedItem
;������
;hTreeView: SysTreeView32�ľ��(HWND)����ControlGet, hwndȡ��
;outPath: ������������ս����
;����ֵ: �ַ�����ָʾ������ֵ�λ�á��޴��󷵻ؿմ���
TVPath_Get(hTreeView, ByRef outPath)
{
	;��Ϣ����Ϣ��������
	TVM_GETITEM = 0x110C
	TVM_GETNEXTITEM = 0x110A
	TVGN_CARET = 0X09
	TVGN_PARENT = 0x03
	TVIF_TEXT = 0x01
	NULL = 0
	;����
	cchTextMax=512
	sizeof_TVITEM=40
	outPath=
	VarSetCapacity(szText, cchTextMax, 0)
	VarSetCapacity(tvitem, sizeof_TVITEM, 0)

	;��ȡѡ����Ŀ��HTREEITEM
	SendMessage, TVM_GETNEXTITEM, TVGN_CARET, 0, ,ahk_id %hTreeView%
	if(errorlevel=NULL) ;û��ѡ����Ŀ
		return "selection"
	Else
		hSelItem:=errorlevel

	;����Processϵ������
	;��������
	PROCESS_VM_OPERATION=0x8
	PROCESS_VM_WRITE=0x20
	PROCESS_VM_READ=0x10

	MEM_COMMIT=0x1000
	MEM_FREE=0x10000
	PAGE_READWRITE=0x4
	;������������

	;������ʼ��
	hProcess=0
	ret=0
	HasError:=""
	;������ʼ������

	ControlGet, hwnd, HWND, , ,ahk_id %hTreeView%
	WinGet, pid, PID, ahk_id %hwnd%
	if (!pid)
		return "pid"

	hProcess:=DllCall("OpenProcess"
		, uint, PROCESS_VM_OPERATION | PROCESS_VM_WRITE | PROCESS_VM_READ
		, int, 0, uint, pid, uint)
	if (hProcess)
	{
		pTVItemRemote:=DllCall("VirtualAllocEx"
			, uint, hProcess
			, uint, 0
			, uint, sizeof_TVITEM
			, uint, MEM_COMMIT
			, uint, PAGE_READWRITE)
		pszTextRemote:=DllCall("VirtualAllocEx"
			, uint, hProcess
			, uint, 0
			, uint, cchTextMax
			, uint, MEM_COMMIT
			, uint, PAGE_READWRITE)
		if (pszTextRemote && pTVItemRemote)
		{
			while hSelItem != 0 ;�����ڵ����
			{
				;дtvitem�ṹ��
				NumPut(TVIF_TEXT, tvitem, 0) ;mask
				NumPut(hSelItem, tvitem, 4) ;hItem
				NumPut(pszTextRemote, tvitem, 16) ;szText
				NumPut(cchTextMax, tvitem, 20) ;cchTextMax

				ret := DllCall("WriteProcessMemory"
					, uint, hProcess
					, uint, pTVItemRemote
					, uint, &tvitem
					, uint, sizeof_TVITEM
					, uint, 0)
				if (ret)
				{
					;��ȡ����
					SendMessage, TVM_GETITEM, 0, pTVItemRemote, , ahk_id %hTreeView%
					if(errorlevel) ;��ȡ���ֳɹ�
					{
						ret := DllCall("ReadProcessMemory"
							, uint, hProcess
							, uint, pszTextRemote
							, str,  szText
							, uint, cchTextMax
							, uint, 0)
						if (ret)
						{
							outPath := (outPath="") ? szText : szText . "\" . outPath
							;��ȡ���ڵ�
							SendMessage, TVM_GETNEXTITEM, TVGN_PARENT, hSelItem, , ahk_id %hTreeView%
							hSelItem:=errorlevel ;����NULL������
					    }
					else
					   {
							HasError:="read"
							break
						}
				   }
				   else
				      {
						HasError:="gettext"
						break
					  }
			    }
				  else
				     {
					HasError:="write"
					break
				      }
			}
	    }
	else
	HasError:="alloc"
   }
    else
	HasError:="process"


	;�ͷ��ڴ�
	if(pszTextRemote)
		DllCall("VirtualFreeEx"
			,uint, hProcess
			,uint, pszTextRemote
			,uint, cchTextMax
			,uint, MEM_FREE)
	if(pTVItemRemote)
		DllCall("VirtualFreeEx"
			,uint, hProcess
			,uint, pTVItemRemote
			,uint, sizeof_TVITEM
			,uint, MEM_FREE)
	if(hProcess)
		DllCall("CloseHandle", uint, hProcess)

	return HasError
}


;TVPath_Set()      Written By wz520 [wingzero1040~gmail.com]
;ѡ������ TreeView �ؼ��Ľڵ㡣��ʽ�� Root\Parent\Item
;������
;hTreeView: SysTreeView32�ľ��(HWND)����ControlGet, hwndȡ��
;inPath: ��Ҫ���õ�·������"\"�ָ���
;outMatchPath: �������������ʵ��ѡ����Ŀ��·����
;����ֵ: �ַ�����ָʾ������ֵ�λ�á��޴��󷵻ؿմ���
TVPath_Set(hTreeView, inPath, ByRef outMatchPath)
{
	;��Ϣ����Ϣ��������
	TVM_GETITEM = 0x110C
	TVM_GETNEXTITEM = 0x110A

	TVGN_CARET = 0X09
    TVGN_CHILD = 0x04
    TVGN_NEXT = 0x01
    TVGN_ROOT = 0

	TVIF_TEXT = 0x01
	NULL = 0
	;����
	cchTextMax=512
	sizeof_TVITEM=40
	VarSetCapacity(szText, cchTextMax, 0)
	VarSetCapacity(tvitem, sizeof_TVITEM, 0)

	;��ȡ���ڵ��HTREEITEM
	SendMessage, TVM_GETNEXTITEM, TVGN_ROOT, 0, ,ahk_id %hTreeView%
	if(errorlevel=NULL) ;û�и��ڵ�
		return "root"
	Else
		hSelItem:=errorlevel

	;����Processϵ������
	;��������
	PROCESS_VM_OPERATION=0x8
	PROCESS_VM_WRITE=0x20
	PROCESS_VM_READ=0x10

	MEM_COMMIT=0x1000
	MEM_FREE=0x10000
	PAGE_READWRITE=0x4
	;������������

	;������ʼ��
	hProcess=0
	ret=0
	HasError:=""
	;������ʼ������

	ControlGet, hwnd, HWND, , ,ahk_id %hTreeView%
	WinGet, pid, PID, ahk_id %hwnd%
	if (!pid)
		return "pid"

	hProcess:=DllCall("OpenProcess"
		, uint, PROCESS_VM_OPERATION | PROCESS_VM_WRITE | PROCESS_VM_READ
		, int, 0, uint, pid, uint)
	if (hProcess)
	{
		pTVItemRemote:=DllCall("VirtualAllocEx"
			, uint, hProcess
			, uint, 0
			, uint, sizeof_TVITEM
			, uint, MEM_COMMIT
			, uint, PAGE_READWRITE)
		pszTextRemote:=DllCall("VirtualAllocEx"
			, uint, hProcess
			, uint, 0
			, uint, cchTextMax
			, uint, MEM_COMMIT
			, uint, PAGE_READWRITE)
		if (pszTextRemote && pTVItemRemote)
			__dummySetPathToTreeView(hProcess, hTreeView, hSelItem, inPath, tvitem, szText, pszTextRemote, pTVItemRemote, inPath, outMatchPath, HasError)
		else
			HasError:="alloc"
	} else
		HasError:="process"

	;�ͷ��ڴ�
	if(pszTextRemote)
		DllCall("VirtualFreeEx"
			,uint, hProcess
			,uint, pszTextRemote
			,uint, cchTextMax
			,uint, MEM_FREE)
	if(pTVItemRemote)
		DllCall("VirtualFreeEx"
			,uint, hProcess
			,uint, pTVItemRemote
			,uint, sizeof_TVITEM
			,uint, MEM_FREE)
	if(hProcess)
		DllCall("CloseHandle", uint, hProcess)

	return HasError
}

;�� TVPath_Set �������ã���ֱ�ӵ��ô˺�����
__dummySetPathToTreeView(hProcess, hTreeView, hItem, RestPath, ByRef tvitem, ByRef szText, pszTextRemote, pTVItemRemote, ByRef FullPath, ByRef MatchPath, ByRef HasError)
{
	if RestPath=
		return
	FindText:=RegExReplace(RestPath, "\\.*$")
	StringTrimLeft, RestPath, RestPath, % StrLen(FindText)+1

 	;��Ϣ����Ϣ��������
	TVM_EXPAND = 0x1102
	TVM_GETITEM = 0x110C
	TVM_GETNEXTITEM = 0x110A
    TVM_SELECTITEM = 0x110B

	TVGN_CARET = 0X09
    TVGN_CHILD = 0x04
    TVGN_NEXT = 0x01

    TVE_EXPAND = 0x02
	TVIF_TEXT = 0x01
	;����
	cchTextMax=512
	sizeof_TVITEM=40
	while hItem != 0
	{
		;дtvitem�ṹ��
		NumPut(TVIF_TEXT, tvitem, 0) ;mask
		NumPut(hItem, tvitem, 4) ;hItem
		NumPut(pszTextRemote, tvitem, 16) ;szText
		NumPut(cchTextMax, tvitem, 20) ;cchTextMax

		;׼����ȡ����
		ret := DllCall("WriteProcessMemory"
			, uint, hProcess
			, uint, pTVItemRemote
			, uint, &tvitem
			, uint, sizeof_TVITEM
			, uint, 0)
		if (ret)
		{
			;��ȡ����
			SendMessage, TVM_GETITEM, 0, pTVItemRemote, , ahk_id %hTreeView%
			if(errorlevel) ;��ȡ���ֳɹ�
			{
				ret := DllCall("ReadProcessMemory"
					, uint, hProcess
					, uint, pszTextRemote
					, str,  szText
					, uint, cchTextMax
					, uint, 0)
				if (ret)
				{
					if (szText=FindText) ;����Ҫ������·��
					{
						StringTrimRight, MatchPath, FullPath, % StrLen(RestPath)
						;ѡ�нڵ�
						SendMessage, TVM_SELECTITEM, TVGN_CARET, hItem, , ahk_id %hTreeView%
						;չ��
						SendMessage, TVM_EXPAND, TVE_EXPAND, hItem, , ahk_id %hTreeView%
						if errorlevel ;չ���ɹ�
						{
							;��ȡ��һ���ӽڵ�
							SendMessage, TVM_GETNEXTITEM, TVGN_CHILD, hItem, , ahk_id %hTreeView%
							hItem:=errorlevel
							;�ݹ������һ��
							__dummySetPathToTreeView(hProcess, hTreeView, hItem, RestPath, tvitem, szText, pszTextRemote, pTVItemRemote, FullPath, MatchPath, HasError)
						}
						break
					}
				} else {
					HasError:="read"
					break
				}
			} else {
				HasError:="gettext"
				break
			}
		} else {
			HasError:="write"
			break
		}
		;��ȡ��һ��ͬ���ڵ�
		SendMessage, TVM_GETNEXTITEM, TVGN_NEXT, hItem, , ahk_id %hTreeView%
		hItem:=errorlevel
	}
}