Cando_��ӵ��ʵ������ļ�:
	Gui,66:Default
	Gui,Destroy
	Gui, add, text,x5 ,Ӣ�ĵ���:
	Gui, Add, edit, x+10 Veword  w250,%CandySel%
	Gui, add, text,x5 ,���ķ���:
	Gui, Add, edit, x+10 Vctrans  w250,% json(YouDaoApi(CandySel), "basic.explains")
	Gui, Add, Button,x250  w65 h20 -Multi Default gwtranslist,ȷ��д��
	Gui, Show, ,���ʷ���д���ļ�
return

wtranslist:
	Gui,Submit,NoHide
	if ctrans
		IniWrite,% ctrans,%A_ScriptDir%\settings\translist.ini,����,% eword
	Gui,Destroy
return