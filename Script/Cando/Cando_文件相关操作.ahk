Cando_С˵����:
FileReadLine,x,%CandySel%,1
FileMove,%CandySel%,%CandySel_ParentPath%\%x%.txt
Return

Cando_�ϲ��ı��ļ�:
	loop, parse, CandySel, `n,`r
	{
		SplitPath, A_LoopField, , , ext, ,
		If(ext="txt"||ext="ahk"||ext="ini")
		{
			Fileread, text, %A_loopfield%
			all_text=%all_text%%A_loopfield%`r`n`r`n%text%`r`n`r`n
		}
	}
	FileAppend, %all_text%, %A_Desktop%\�ϲ�.txt
Return

Cando_�ļ��б�:
   ; dateCut := A_Now
   ; EnvAdd, dateCut, -1, days       ; sets a date -24 hours from now
   �б�������ļ�=%A_Temp%\���������ļ��б���ʱ�ļ�_%A_now%.txt
;    MsgBox %CandySel%
   loop, %CandySel%\*.*, 1, 1   ; change the folder name
   {
   ;    if (A_LoopFileTimeModified >= dateCut)
         str .= A_LoopFileFullPath "`n"
   }
   FileAppend,%str%,%�б�������ļ�%
;    Sleep,50
   Run,notepad.exe %�б�������ļ�%
   Return

Cando_�����ļ���:
SwapName(CandySel)
Return

Swapname(Filelist)
{
	StringSplit,File_,Filelist,`n
	SplitPath,File_1,FN1,Dir
	SplitPath,File_2,FN2
	RunWait,%ComSpec% /c ren `"%File_1%`" `"temp`",,Hide
	RunWait,%ComSpec% /c ren `"%File_2%`" `"%FN1%`",,Hide
	RunWait,%ComSpec% /c ren `"%Dir%\temp`" `"%FN2%`",,Hide
	return,0
	}

cando_���ļ������ļ���:
clip := ""
Loop, Parse, CandySel, `n,`r 
{
SplitPath, A_LoopField,outfilename
clip .= (clip = "" ? "" : "`r`n") outfilename
}
clipboard:=clip
	return

cando_���ļ�����·��:
clip := ""
Loop, Parse, CandySel, `n,`r 
{
SplitPath, A_LoopField,outfilename
clip .= (clip = "" ? "" : "`r`n") outfilename
}
clipboard:=clip
	return

Cando_���ɿ�ݷ�ʽ:
FileCreateShortcut,%CandySel%,%CandySel_ParentPath%\%CandySel_FileNameNoExt% .lnk
    Return