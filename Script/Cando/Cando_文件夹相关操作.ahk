Cando_ͬ���հ��ļ�:
FileCreateDir, %CandySel_ParentPath%\%CandySel_FileNameWithExt%_��
Loop, Files, %CandySel%\*.*, DR
{
	StringReplace, _temp, A_LoopFileLongPath, %CandySel%\, ,All
	FileCreateDir, %CandySel_ParentPath%\%CandySel_FileNameWithExt%_��\%_temp%
}
Loop, Files, %CandySel%\*.*, FR
{
	StringReplace, _temp, A_LoopFileLongPath, %CandySel%\, ,All
	FileAppend, , %CandySel_ParentPath%\%CandySel_FileNameWithExt%_��\%_temp%
}
return

Cando_����Ŀ¼�ṹ:
Files:= CandySel . "\"
CopyDirStructure(Files, CandySel_ParentPath "\" CandySel_FileNameWithExt "_��", 0)
Return