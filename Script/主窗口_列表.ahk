;Ŀ���ļ��е��ļ��б�
liebiao:
/*
Loop, parse, A_GuiEvent, `n, `r
{
   Gui, Submit, NoHide
SetBatchLines, 3000
ifNotExist, %Dir%
{
msgbox,û������Ŀ���ļ��У�����ק�ļ��е����ڻ�ѡ��һ���ļ���.
return
}
*/
if !TargetFolder or !FileExist(TargetFolder)
{
TargetFolder=
IniWrite,%TargetFolder%, %run_iniFile%,����, TargetFolder
msgbox,û������Ŀ���ļ��У�����ק�ļ��е����ڻ�ѡ��һ���ļ��С�
return
}

rootdir := TargetFolder       ;��ݷ�ʽĿ¼
updatealways =1      ;1�Զ�ˢ�£�0��ֹ�Զ�ˢ��
SetTimer,ini,500
TrayTip,Ŀ¼�˵�,��ʼ��������,
ifnotexist %A_ScriptDir%\settings\tmp\folderlist.txt
   gosub, createdatabase
Menu,DirMenu,add,%rootdir%,godir
Menu,DirMenu,disable,%rootdir%
Menu,DirMenu,add,-`:`:�� Ŀ¼`:`:-,godir
if updatealways = 1
   gosub createdatabase
goto createmenu
return

CreateMenu:
Loop, Read, %A_ScriptDir%\settings\tmp\folderlist.txt
{

   isfile = 0
   StringReplace,Line,A_LoopReadLine,%rootdir%\,
   ifinstring Line,.
      isfile = 1

   if isfile = 0
   {
      StringGetPos,pos,Line,\,R
      StringLeft,pardir,Line,%pos%
      StringReplace,dir,Line,%pardir%,
      StringReplace,dir,dir,\
      Menu,%Line%,add,-`:`:�� Ŀ¼`:`:-,godir

      if pardir =
         pardir = DirMenu
      Menu,%pardir%,add,%dir%,:%Line%
   }
   else
   {
      StringGetPos,pos,Line,\,R
      StringLeft,pardir,Line,%pos%
      StringReplace,file,Line,%pardir%,
      StringReplace,file,file,\
      if pardir =
         pardir = DirMenu
      Menu,%pardir%,add,%file%,go

   }
}
SetTimer,ini,off
TrayTip
Menu,DirMenu,show
Menu,DirMenu,Deleteall
return


go:
   if A_ThisMenu = DirMenu
      run %rootdir%\%A_ThisMenuItem%
   else
      run %rootdir%\%A_ThisMenu%\%A_ThisMenuItem%
return

godir:
if A_ThisMenu = DirMenu
      run %rootdir%
   else
      run %rootdir%\%A_ThisMenu%
return

createdatabase:
   runwait, %comspec% /c dir /s /b /os /a:d "%rootdir%" > "%A_ScriptDir%\settings\tmp\folderlist.txt",,hide
   runwait, %comspec% /c dir /s /b /os /a:-d "%rootdir%" >> "%A_ScriptDir%\settings\tmp\folderlist.txt",,hide
return

ini:
   TrayTip,Ŀ¼�˵�,��ʼ��������,30
return

