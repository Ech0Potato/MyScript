; ��ݼ�.ahk  ��ݼ�ֱ�ӷ���
; Cando_�е����緭��.ahk  candy����

YouDaoApi(KeyWord)
{
    KeyWord:=SkSub_UrlEncode(KeyWord,"utf-8")
	url:="http://fanyi.youdao.com/fanyiapi.do?keyfrom=xxxxxxxx&key=1360116736&type=data&doctype=json&version=1.1&q=" . KeyWord
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WebRequest.Open("GET", url)
    WebRequest.Send()
    result := WebRequest.ResponseText
    Return result
}