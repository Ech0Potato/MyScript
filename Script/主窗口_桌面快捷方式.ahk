;�����ݷ�ʽ
Desktoplnk:
kShortcutDir = %A_desktop%
tempworkdir:=A_WorkingDir
SetWorkingDir, %kShortcutDir%
kShortcutExt = lnk
Loop, %A_WorkingDir%\*.%kShortcutExt%,,   ; for each shortcut in the directory, add a menu item for it
{
    SplitPath, A_LoopFileName, , , , menuName,      ; remove extension
    Menu, mymenu, Add, %menuName%, RunThisMenuItem
}

Menu,mymenu, add

Loop, %A_desktop%\����\*.lnk
   {
        SplitPath, A_LoopFileName, , , , menuName,      ; remove extension
        Menu, ����, add, %menuName%, RunThisMenuItem2  ; �����Ӳ˵��
    }
Menu,mymenu, add, ����, :����  ; �������˵��

Menu,mymenu,show
Menu,mymenu,deleteall
Menu, ����,deleteall
   SetWorkingDir,%tempworkdir%
   ;tooltip, % A_WorkingDir
return

RunThisMenuItem2:
RunFileName = %A_desktop%\����\%A_ThisMenuItem%.lnk
run, %RunFileName%
Return    ;����




