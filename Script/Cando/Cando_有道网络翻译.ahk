Cando_�е����緭��:
	Gui,66:Default
	Gui,Destroy
	Youdao_keyword=%CandySel%
	Youdao_����:=YouDaoApi(Youdao_keyword)
	Youdao_��������:= json(Youdao_����, "basic.explains")
	Youdao_��������:= json(Youdao_����, "web.value")
	If Youdao_��������<>
	{
		Gui,add,Edit,x10 y10 w260 h80,%Youdao_keyword%
		Gui,add,button,x270 y10 w40 h80 gsoundpaly,����
		Gui,add,Edit,x10 y100 w300 h80,%Youdao_��������%
		Gui,add,Edit,x10 y190 w300 h80,%Youdao_��������%
		Gui,show,,�е����緭��
	}
	else
		MsgBox,,�е����緭��,���������ѯ�����õ��ʵķ��롣
Return

soundpaly:
	spovice:=ComObjCreate("sapi.spvoice")
	spovice.Speak(Youdao_keyword)
Return