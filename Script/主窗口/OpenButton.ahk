; �����ڴ򿪰�ť��������������ַ������
openbutton:
	Gui, Submit, NoHide

	If !dir  ; dirΪ�շ���
		Return

	if changeComboBox=1
	{
		GuiControl, , dir, |%ComboBoxShowItems%
		GuiControl,text,Dir,%dir%
		changeComboBox=0
	}

	If(RegExMatch(dir,"i)^(\[|HKCU|HKCR|HKCC|HKU|HKLM|HKEY_)"))
	{
		f_OpenReg(dir)
	Return
	}

	OpenButton_All_cmd:="@Cmd@|@ExeAhk@|@Proxy@|@regedit@|@ת��@UrlDecode@|@ת��@UrlEncode@|@ת��@10��16@|@ת��@16��10@|@ת��@ũ��������@|@ת��@������ũ��@|@ת��@�����@|@ת��@������@"
	If RegExMatch(dir,"i)^\s*(" OpenButton_All_cmd ")\s*")
	{
		StringTrimLeft,dir,dir,1
		arrOpenButton_Cmd_Str:=StrSplit(dir,"@"," `t")
		;msgbox % Array_ToString(arrOpenButton_Cmd_Str)
		OpenButton_Cmd_Str1:=arrOpenButton_Cmd_Str[1]
		OpenButton_Cmd_Str2:=arrOpenButton_Cmd_Str[2]
		OpenButton_Cmd_Str3:=arrOpenButton_Cmd_Str[3]
		If (OpenButton_Cmd_Str1="Cmd")
		{
			Run, %comspec% /k "%OpenButton_Cmd_Str2%"
		Return
		}
		Else If (OpenButton_Cmd_Str1="ExeAhk")  
		{
			if !OpenButton_Cmd_Str2
			return
			else
			{
				RunNamedPipe(OpenButton_Cmd_Str2)
			return
			}
		}
		Else If (OpenButton_Cmd_Str1="Proxy")  
		{
			If OpenButton_Cmd_Str2
			{
				CF_RegWrite("REG_SZ","HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer",OpenButton_Cmd_Str2)
				If CF_regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 1
				{
					CF_RegWrite("REG_DWORD","HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable",0)
					MsgBox,��ȡ��IE����
				}
				Else If CF_regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 0
				{
					CF_RegWrite("REG_DWORD","HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable",1)
					MsgBox, IE����������Ϊ ��%OpenButton_Cmd_Str2%����Ҫȡ���������ٴ����б����
				}
				dllcall("wininet\InternetSetOptionW","int","0","int","39","int","0","int","0")
				dllcall("wininet\InternetSetOptionW","int","0","int","37","int","0","int","0")
			Return
			}
			Else
			{
				If CF_regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 1
				{
					CF_RegWrite("REG_DWORD","HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable",0)
					MsgBox,��ȡ��IE����
				}
				Else If CF_regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 0
				{
					ProxyServer := CF_regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer")
					if ProxyServer
					{
						CF_RegWrite("REG_DWORD","HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable",1)
						MsgBox, IE����������Ϊ��%ProxyServer%����Ҫȡ���������ٴ����б����
					}
					else
					{
						MsgBox,��������������IP:�˿ںš�
					}
				}
				dllcall("wininet\InternetSetOptionW","int","0","int","39","int","0","int","0")
				dllcall("wininet\InternetSetOptionW","int","0","int","37","int","0","int","0")
			Return
			}
		}
		Else If (OpenButton_Cmd_Str1="regedit")  
		{
			f_OpenReg(OpenButton_Cmd_Str2)
		return
		}
		Else If (OpenButton_Cmd_Str1="ת��")  
		{
			If (OpenButton_Cmd_Str2="UrlDecode")
			{
				If OpenButton_Cmd_Str3
				{
					q:=% UrlDecode(OpenButton_Cmd_Str3)          ;Ĭ��ʹ��UTF-8����ת��
					settimer,sendq,-1000
				Return
				}
				Else
				{  ;���Ƶ���������ַ���ʹ��GBK����ת��
					If Clipboard
					{
						q:=% UrlDecode(Clipboard,CP936)
						settimer,sendq,-1000
					Return
					}
					Return
				}
			}
			Else If (OpenButton_Cmd_Str2="UrlEncode")
			{
				If OpenButton_Cmd_Str3
				{
					q:=% UrlEncode(OpenButton_Cmd_Str3)      ;Ĭ��ʹ��UTF-8����ת��
					settimer,sendq,-1000
				Return
				}
				Else
				{  ;���Ƶ���������ַ���ʹ��GBK����ת��
					If Clipboard
					{
						q:=% UrlEncode(Clipboard,CP936)
						settimer,sendq,-1000
					Return
					}
					Return
				}
			}
			Else If (OpenButton_Cmd_Str2="10��16")
			{
				q:=% dec2hex(OpenButton_Cmd_Str3)
				settimer,sendq,-1000
			Return
			}
			Else If (OpenButton_Cmd_Str2="16��10")
			{
				q:=% hex2dec(OpenButton_Cmd_Str3)
				settimer,sendq,-2000
			Return
			}
			Else If (OpenButton_Cmd_Str2="ũ��������")
			{
				q:=% Date_GetDate(OpenButton_Cmd_Str3)
				settimer,sendq,-1000
			Return
			}
			Else If (OpenButton_Cmd_Str2="������ũ��")
			{
				q:=% Date_GetLunarDate(OpenButton_Cmd_Str3?OpenButton_Cmd_Str3:A_YYYY A_MM A_DD)
				settimer,sendq,-1000
			Return
			}
			Else If (OpenButton_Cmd_Str2="�����")
			{
				q:=% jzf(OpenButton_Cmd_Str3)
				settimer,sendq,-1000
			Return
			}
			Else If (OpenButton_Cmd_Str2="������")
			{
				q:=% fzj(OpenButton_Cmd_Str3)
				settimer,sendq,-1000
			Return
			}
		}
	}

	if (favorites_link=1)
	{
		favorites_link=0
		RunFileName=%dir%.lnk
		run, % RunFileName,%A_ScriptDir%\favorites\ , UseErrorLevel
		if ErrorLevel
		{
			Loop, Files, %A_ScriptDir%\favorites\*.*,D
			{
				If fileexist(A_LoopFileFullPath "\" RunFileName)
				{
					temp_runhistory=1
					run, % A_LoopFileFullPath "\" RunFileName, ,UseErrorLevel
					return
				}
			}
		return
		}
		else 
			{
				temp_runhistory=1
				return
			}
	}

	Transform,dir,Deref,%Dir%
	Run,%Dir%,,UseErrorLevel
	If ErrorLevel
	{
		If dir contains +,~,!,^,=,(,),{,},[,],/,<,>,|,;,:,*,%A_Space%,\,.
			goto g_search
		ErrorLevel = 0
		If % %dir%<>""
		{
			Run,% %Dir%,,UseErrorLevel
			If ErrorLevel
				temp_Error = 1
		}
		Else 
			temp_Error = 1
	}
	if temp_Error
		gosub g_search
Return

g_search:
	temp_Error = 0
	msgbox,3,��������ѡ��,�ٶ�������"��"��google��"��"
	Ifmsgbox yes     
		Run http://www.baidu.com/s?wd=%Dir% 
	Ifmsgbox no
		Run https://www.google.com.hk/search?hl=zh-CN&q=%Dir%
return

sendq:
	WinActivate,%apptitle%
	GuiControl,text,Dir,
	GuiControl,text,Dir,%q%
	q=
Return