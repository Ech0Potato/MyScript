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

Cando_�⿪�ļ���:
ErrorCount := MoveFilesAndFolders(CandySel "\*.*", CandySel_ParentPath)
if (ErrorCount != 0)
    MsgBox %ErrorCount% ���ļ�/�ļ����ƶ�ʧ��.
else
    FileRecycle, % CandySel
return

MoveFilesAndFolders(SourcePattern, DestinationFolder, DoOverwrite = false)
; �ƶ�ƥ�� SourcePattern �������ļ����ļ��е� DestinationFolder �ļ�������
; �����޷��ƶ����ļ�/�ļ��е���Ŀ. �˺�����Ҫ [v1.0.38+]
; ��Ϊ��ʹ���� FileMoveDir ��ģʽ 2.
{
    if (DoOverwrite = 1)
        DoOverwrite := 2  ; ����� FileMoveDir �˽�ģʽ 2 ��ģʽ 1 ������.
    ; �����ƶ������ļ�(�����ļ���):
    FileMove, %SourcePattern%, %DestinationFolder%, %DoOverwrite%
    ErrorCount := ErrorLevel
    ; �����ƶ������ļ���:
    Loop, %SourcePattern%, 2  ; 2 ��ʾ "ֻ��ȡ�ļ���".
    {
        FileMoveDir, %A_LoopFileFullPath%, %DestinationFolder%\%A_LoopFileName%, %DoOverwrite%
        ErrorCount += ErrorLevel
        if ErrorLevel  ; ����ÿ������������ļ�������.
            MsgBox Could not move %A_LoopFileFullPath% into %DestinationFolder%.
    }
    return ErrorCount
}
