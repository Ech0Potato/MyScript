cliphistoryPI:
!`::
	Gui,66:Destroy
	Gui,66:Default
	IniRead, CHPIF, %run_iniFile%, ����, CHPIF   ; ������Ԥ����Ŀ�ղؼ�(���5��)
	CHPIFArray := StrSplit(CHPIF, ",")
	Loop, % CHPIFNo := CHPIFArray.Length()
	{
		button_y:=(A_index-1)*40+5
		button_y2:= button_y + 15
		Gui, Add, Button, x5 y%button_y% w400 h40 vCHPIF_%A_index% gcopycliphistoryPIF, % getFromTable("history", "data", "id=" CHPIFArray[A_index])[1]
		Gui, Add, Text, Cyellow x410 y%button_y2% w20 vDCHPIF_%A_index% h20 gDCHPIF, ��
	}
	Num := 15 - CHPIFNo
	ReadcliphistoryPI(Num)
	Loop, % Num
	{
		button_y:=(A_index + CHPIFNo - 1)*40 + 5
		button_y2:= button_y + 15
		If (StrLen(cliphistoryPI[A_index]) < 80)
			tempV := cliphistoryPI[A_index]
		else
		{
			n_Count=0
			tempV := LTrim(cliphistoryPI[A_index], "`r`n")
			tempV := StrReplace(tempV, "`r`n", "`n", n_Count)
			if (n_Count>=1)
			{
				n_pos := InStr(cliphistoryPI[A_index], "`n", 0, 1)
				tempV := SubStr(tempV, 1, n_pos) "........"
			}
		}
		Gui, Add, Button, x5 y%button_y% w400 h40 vCHPI_%A_index% gcopycliphistoryPI, % tempV
		Gui, Add, Text, x410 y%button_y2% w20 h20 vSCHPIF_%A_index% gSCHPIF, ��
	}
	Gui,show,,�������������Ŀ
return

ReadcliphistoryPI(Num)  ; �Ӽ��������ݿ��ж�ȡ���µ�N����Ŀ
{
	local result, Row
	q := "select * from history order by id desc limit " Num
	result := ""
	cliphistoryPI := []
	cliphistoryPI_ID :=[]
	if !DB.GetTable(q, result)
		msgbox error
	loop % result.RowCount
	{
		result.Next(Row)
		cliphistoryPI_ID[A_index]:= Row[1]
		cliphistoryPI[A_index]:= Row[2]
	}
return
}

copycliphistoryPIF:  ; ���Ƽ�����Ԥ����Ŀ�ղؼ��е���Ŀ��������
	WB_id := StrReplace(A_GuiControl , "CHPIF_", "")
	temp_read := getFromTable("history", "data", "id=" CHPIFArray[WB_id])[1]
	monitor=0
	try Clipboard := temp_Read
	sleep,300
	monitor=1
return

copycliphistoryPI:  ; ���Ƽ�����Ԥ����Ŀ�е���Ŀ��������
	WB_id := StrReplace(A_GuiControl , "CHPI_", "")
	temp_read := getFromTable("history", "data", "id=" cliphistoryPI_ID[WB_id])[1]
	monitor=0
	try Clipboard := temp_Read
	sleep,300
	monitor=1
return

DCHPIF:  ; ɾ��������Ԥ����Ŀ�ղؼ��е���Ŀ
	WB_id := StrReplace(A_GuiControl , "DCHPIF_", "")
	CHPIFArray.RemoveAt(WB_id)
	i:=""
	for k,v in CHPIFArray
		i .= v ","
	CHPIF :=  Trim(i, ",")
	IniWrite, % CHPIF, %run_iniFile%, ����, CHPIF
	Gosub cliphistoryPI
return

SCHPIF:  ; ��Ӽ�����Ԥ����Ŀ�ղؼ��е���Ŀ
	WB_id := StrReplace(A_GuiControl , "SCHPIF_", "")
	CHPIF := cliphistoryPI_ID[WB_id] "," CHPIF
	CHPIF :=  Trim(CHPIF, ",")
	CHPIFArray := StrSplit(CHPIF, ",")
	if (CHPIFArray.Length() > 5)
		CHPIF := CHPIFArray[1] "," CHPIFArray[2] "," CHPIFArray[3] "," CHPIFArray[4] "," CHPIFArray[5] 
	IniWrite, % CHPIF, %run_iniFile%, ����, CHPIF
	Gosub cliphistoryPI
return