Cando_FileToHttpServer:
	HttpServer_File     := CandySel
	HttpServer_FileName := CandySel_FileNameWithExt
	CF_ToolTip("�ļ�������Ϊ�������ļ���`n�����ֻ�(/PC)��ʹ��Tasker����������ء�", 5000)
return

Cando_FileToFlaskandTasker:
	HttpServer_File     := CandySel
	HttpServer_FileName := CandySel_FileNameWithExt
	WinHttp.URLGet("http://192.168.1.214:10000/ahkhttpupload")
return