OnTrayIcon(Hwnd, Event)
{
	if (Event != "L")		; �������ֱ�ӷ���
	return

	if Hwnd=101
	{
		gosub cliphistoryPI
	return
	}
	if Hwnd=102
	{
		send ^{F2}
	return
	}
}