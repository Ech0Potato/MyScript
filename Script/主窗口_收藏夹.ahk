addfavorites:
Loop, parse, A_GuiEvent, `n, `r
{
   Gui, Submit, NoHide
   tempworkdir:=A_WorkingDir

   w = %A_ScriptDir%\favorites
   SetWorkingDir, %w%
   ifNotExist, %Dir%
   {
   msgbox,û��ѡ���ļ����ļ��С�
   SetWorkingDir,%tempworkdir%
   ;tooltip, % A_WorkingDir
   return
   }

   SplitPath,Dir, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
   InputBox,shortName,,�������ݷ�ʽ������?,,,,,,,,%OutNameNoExt%
   if ErrorLevel{
   SetWorkingDir,%tempworkdir%
   ;tooltip, % A_WorkingDir
   return
   }
   else
   {
   IfExist,%w%\%shortName%.lnk
   {
   msgbox,4,,ͬ���Ŀ�ݷ�ʽ�Ѿ����ڣ��Ƿ��滻?
   IfMsgBox No
   {
   SetWorkingDir,%tempworkdir%
   ;tooltip, % A_WorkingDir
   return
   }
   else{
   FileCreateShortcut,%dir%,%shortName%.lnk,%w%
   return
   }
   }
   FileCreateShortcut,%dir%,%shortName%.lnk,%w%
   SetWorkingDir,%tempworkdir%
   ;tooltip, % A_WorkingDir
   return
}
return
}
return

showfavorites:
   tempworkdir:=A_WorkingDir
   w2 = %A_ScriptDir%\favorites
   SetWorkingDir, %w2%
   kShortcutExt = lnk

FileCount := 0
Loop, %A_WorkingDir%\*.%kShortcutExt%,,   ; for each shortcut in the directory, add a menu item for it
{
   FileCount++
   SplitPath,A_LoopFileName, , , , menuName2
   Menu, mymenu2, Add, %menuName2%, RunThisMenuItem
}

if(FileCount != 0)
Menu, mymenu2, Add

FileCount := 0
Loop, %A_ScriptDir%\Favorites\*, 2    ;��ȡ�ļ���
{
FileCount := 0
Filename_%FileCount%:=A_LoopFileName
fname:=Filename_%FileCount%

FileList =
   Loop, %A_ScriptDir%\Favorites\%fname%\*.lnk  ;������Ĭ��˳��  ntfs ��ĸ   fat32  ������ʱ������
    FileList = %FileList%%A_LoopFileName%`n
      Sort, FileList     ;����  ntfs ��ĸ   fat32  ������ʱ������
      Loop, parse, FileList, `n
      {
      if A_LoopField =  ; Ignore the blank item at the end of the list.
      continue
      FileCount++
      SplitPath,A_LoopField, , , , pos
      Menu, %fname%, add, %pos%, MenuHandler   ; �����Ӳ˵��
       }
if(FileCount != 0)                          ;���Կյ����ļ��У��������
Menu,mymenu2, add, %fname%, :%fname%  ; �������˵��
}
 Menu, mymenu2, Add
 Menu, mymenu2, Add,�����ղ�,o
Menu,mymenu2,show
Menu,mymenu2,deleteall
SetWorkingDir,%tempworkdir%
;tooltip, % A_WorkingDir
/*
Loop, %w2%\*.*, 2, 0
{
    FileCount := 0
     Foldname := A_LoopFileName
     Loop, %w2%\%Foldname%\*.lnk, 0, 0
     {
        FileCount++
     }
     if(FileCount != 0)
     Menu,%Foldname%,Deleteall
}
*/
return

o:
run %A_ScriptDir%\favorites
return

RunThisMenuItem:
; Runs the shortcut corresponding to the last selected tray meny item
    Run %A_ThisMenuItem%.%kShortcutExt%
    return

MenuHandler:   ;���г���
RunFileName = %A_ScriptDir%\favorites\%A_ThisMenu%\%A_ThisMenuItem%.lnk
run, %RunFileName%,,UseErrorLevel
        if ErrorLevel
        MsgBox,,,ϵͳ�Ҳ���ָ�����ļ���,3
Return    ;����