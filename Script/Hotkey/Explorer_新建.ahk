;#include COM.ahk
;Explorer Windows Manipulations - Sean
;http://www.autohotkey.com/forum/topic20701.html
;7plus - fragman
;http://code.google.com/p/7plus/

�½��ļ���:
IfWinActive,ahk_group ccc
{

   if(A_OSVersion="Win_XP" && !IsRenaming())
	   CreateNewFolder()
   else if !IsRenaming()
 Send ^+n
}
Return

�½��ı��ĵ�:
IfWinActive,ahk_group ccc
{
if !IsRenaming()
CreateNewTextFile()
}
return