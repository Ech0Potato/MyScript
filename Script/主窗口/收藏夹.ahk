addfavorites:
	Loop, parse, A_GuiEvent, `n, `r
	{
		Gui, Submit, NoHide
		myfav = %A_ScriptDir%\favorites
		ifNotExist, %Dir%
		{
			msgbox,û��ѡ���ļ����ļ��С�
		return
		}

		SplitPath,Dir, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		InputBox,shortName,,�������ݷ�ʽ������?,,,,,,,,%OutNameNoExt%
		if ErrorLevel{
		return
		}
		else
		{
			IfExist,%myfav%\%shortName%.lnk
			{
				msgbox,4,,ͬ���Ŀ�ݷ�ʽ�Ѿ����ڣ��Ƿ��滻?
				IfMsgBox No
				return
				else{
					FileCreateShortcut,%dir%,%myfav%\%shortName%.lnk
				return
				}
			}
			FileCreateShortcut,%dir%,%myfav%\%shortName%.lnk
		return
		}
	}
return

showfavorites:
	myfavmenu := FolderMenu(A_ScriptDir "\Favorites", "lnk","�ղؼ�",0,2,1,1)
	Menu, % myfavmenu, show
	Menu, % myfavmenu, delete
return