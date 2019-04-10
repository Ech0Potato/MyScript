; https://autohotkey.com/board/topic/9529-urldownloadtovar/page-7
; URL,Charset="",URLCodePage="",Proxy="",ProxyBypassList="",Cookie="",Referer="",UserAgent="",EnableRedirects="",Timeout=-1
; http://ahkcn.net/thread-5658.html

/*
������־��
	2018.10.20
	URLDownloadToFile �� URLDownloadToVar  ���ߺϲ�ΪURLGet
	URLPost ���gzip��ѹ���������ع���
	�޸İ汾��Ϊ��1.5

	2015.09.12
	�Ż�����ṹ
	�汾��Ϊ1.4

	2015.09.11
	������ʱ���ڴ���ʱ�䱻��������⡣��http://ahkcn.net/thread-5658-post-33736.html#pid33736��
	������tmplinshi������������ϸ������
	----------------------------------------------------------------------------------------------
	WebRequest.WaitForResponse(��ʱ����)
	Ĭ������£������ʱ����������������Ϊ�վ�һֱ�ȴ������� 60 �͵ȴ� 60 �롣����Ҫ������Ĭ�ϵĳ�ʱ���á�

	Ĭ�ϵĳ�ʱ����Ϊ:
	������ʱ: 0 ��
	���ӳ�ʱ: 60 ��
	���ͳ�ʱ: 30 ��
	���ճ�ʱ: 30 ��

	WaitForResponse Ӧ����ָ���ճ�ʱ�ɡ������أ�Ĭ�ϵĻ���ʹ������ WaitForResponse(60) ʵ���ϻ������͵ȴ� 30 �롣��

	Ĭ��ֵ����ͨ�� WebRequest.SetTimeouts(������ʱ, ���ӳ�ʱ, ���ͳ�ʱ, ���ճ�ʱ) �����ã���� MSDN ��˵��������ѽ��ճ�ʱ�޸�Ϊ 120 �� ���� WebRequest.SetTimeouts(0, 60000, 30000, 120000)

	���û�����׿ɰ��Һ����ˡ����д��һ����ѯ�����������ѯʧ�ܡ���ԭ����Ϊ����վ����Ӧ����Ϊ��û�����ó�ʱ����Ϊ�����һֱ�ȴ�����������˵�ˣ���һֱ�ȴ�����������?Ĭ�ϵ����ʱ����������ϸ��ץ�����ݣ�����ÿ�ζ� 30 �볬ʱ���ء��������������ȴ�������� 40 �����ʱ�򷵻��˽������ŷ�����������Ծ���

	ϣ��������֪�����˵�����п��һ�Ҫ�ٷ���������˵����һ�㡣������@���� ��Ҳ�����޸��´��룬������ݵĳ�ʱ������Ĭ�ϵ� 30 �������һ�� SetTimeouts��
	----------------------------------------------------------------------------------------------
	�汾��Ϊ1.3

	2015.06.05
	��Ӿ�̬����Status��StatusText���÷���ResponseHeadersһ�¡�
	����¹��ܣ���ָ��״̬�������Դ�����������n�Σ�ֱ��״̬����Ԥ��һ�¡�
	�汾��Ϊ1.2

��֪���⣺
	��֧��gzipѹ��������ݡ���������£��㲻�������˵������Ҫgzipѹ��������ݣ������ǲ�����㷢�͵ģ�����ûӰ�졣
	cookieû��ʵ����������������Զ������������������Ҫ��ʱ����ʱȡ�������й���
*/

class WinHttp
{

	static ResponseHeaders:=[],Status:="",StatusText:="",extra:=[]

	/*
	*****************�汾*****************
	URLGet v 1.5

	*****************˵��*****************
	�˺������������� UrlDownloadToFile �����������¼��㣺
	1.�����ٶȸ��죬���100%��
	2.��������ִ��ʱ������AHK�����ǿ���״̬���˺������ᡣ
	3.������������һЩ������վ�����硰ţ��������ʱ����������ý��̻��̳߳����������˺������ᡣ
	4.֧��������ҳ�ַ�����URL�ı��롣�����������ɽ����
	5.֧���������С�Request Header�����������У�Cookie��Referer��User-Agent����վ����������ɽ����
	6.֧�����ó�ʱ���������ȡ�
	7.֧�����ô�����������
	8.֧�������Ƿ��Զ��ض�����ַ��
	9.��RequestHeaders��������ʽ��chrome�Ŀ����߹����еġ�Request Header����ͬ����˿�ֱ�Ӹ��ƹ������ã�������ԡ�
	10.֧�ִ�ȡ��Cookie����������ģ���¼״̬��
	11.֧���ж���ҳ����ʱ��״̬�룬����200��404�ȡ�

	*****************����*****************
	URL ��ַ������������ơ�http://���Ŀ�ͷ����www.�����Ҳ���ϣ���Щ��վ��Ҫ��
	Options��RequestHeaders�ĸ�ʽΪ��ÿ��һ����������������һ��ð��Ϊ��������֮������βΪ����ֵ������������С�����ɲ��ա�������Ϣ������()��ע���е����ӡ�

	*****************Options*****************
	֧������7��(9��)���ã���������ֵ���κ�Ч�����޴�СдҪ��
	Charset ��ҳ�ַ����������ǡ�936��֮������֣������ǡ�gb2312���������ַ���
	URLCodePage URL�ı��룬�ǡ�936��֮������֣�Ĭ���ǡ�65001������Щ��վ��ҪUTF-8����Щ��վ����Ҫgb2312��
	proxy_setting ������������ã�0��ʾʹ�á�Proxycfg.exe�������ã�1��ʾ���ӡ�Proxy��ָ���Ĵ����ֱ�����ӣ�2��ʾʹ�á�Proxy��ָ���Ĵ���
	Proxy ����������������硰http://www.tuzi.com:80�����ַ����������ݴ˴���ֵ�Զ����ú��ʵġ�proxy_setting������ͨ������²��ùܡ�proxy_setting�������������Լ����ơ�
	ProxyBypassList ������������������������硰*.microsoft.com����������������������ַ������ͨ��������������ʡ�
	EnableRedirects �ض���Ĭ�ϻ�ȡ��ת���ҳ����Ϣ��0Ϊ����ת��
	Timeout ��ʱ����λΪ�룬Ĭ�ϲ�ʹ�ó�ʱ��Timeout=-1����
	expected_status	״̬�룬ͨ��200��ʾ��ҳ������404��ʾ��ҳ�Ҳ����ˡ����ú���ҳ���ص�״̬����˴���һ�����׳�������Ϣ��������ʹ�ô˲�������ͬʱʹ��try��䣩��
	number_of_retries	���Դ�������״̬�����ʹ�ã�������ҳ���ص�״̬��������״̬�벻һ��ʱ���������ԵĴ�����

	*****************RequestHeaders*****************
	֧������RequestHeader����Сд�ĸı���ܻ�Ӱ��������������������Щ��
	Cookie �������ڵ�¼��֤��
	Referer ������ַ�������ڷ�������
	User-Agent �û���Ϣ�������ڷ�������
	Content-Type  application/x-www-form-urlencoded

	*****************ע��*****************
	ÿ�����ز����󣬡�ResponseHeaders����������д洢�ľ���ÿ�η�����ַʱ�����������صġ�ResponseHeaders������Ȼ�����Ѿ��������ɶ�����?������ֱ��ʹ�á�
	����Ҫ��ʱ�򣬿��Բ��ù�������Ҫ��ʱ������������ַ�󣬽����Ŷ�ȡ�����������ˡ�
	���硰obj:=WinHttp.ResponseHeaders������ʱobj�оͰ����˸ղŷ�����ַʱ���������ص����С�ResponseHeaders����
	���ǡ�MsgBox, % obj["Content-type"]�����͵õ��ˡ�Content-type����
	���ǡ�MsgBox, % obj["Set-Cookie"]�����͵õ��ˡ�Set-Cookie����
	����ġ�Set-Cookie��������cookie��

	��Ҫע����ǣ����ڡ�Set-Cookie���ܿ���һ�η����˶���������������ڶ�����Set-Cookie�����������á�`r`n���ָ��ġ�
	��Status���͡�StatusText���÷��롰ResponseHeaders��һ�£�����Ϊǰ�����Ǵ�������
	���硰MsgBox, % WinHttp.Status�����͵õ���״̬�롣

	;~ ����������˵����
	WinHttp.UrlDownloadToVar("http://www.baidu.com")
	obj:=WinHttp.ResponseHeaders
	MsgBox, % obj["Set-Cookie"]
	MsgBox, �����Ǹ�����cookie

	��������Ĳ�����Ҫ���뵽��RequestHeaders���У�����ʾ�����֧��gzip����ѹ�����ᵼ�·���������ѹ��������ݹ�����Ҳ�ͻ����
	Accept-Encoding:gzip,deflate,sdch
	*/
	UrlGet(URL, Options:="", RequestHeaders:="", FilePath:="")
	{
		Options:=this.������Ϣ������(Options)
		RequestHeaders:=this.������Ϣ������(RequestHeaders)

		ComObjError(0) 							;���� COM ����ͨ�档���ú󣬼�� A_LastError ��ֵ���ű�����ʵ���Լ��Ĵ�����
		WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")

		if (URL="") 								; ����ȫΪ�� �������õ� WinHttp ����
		return ComObjCreate("WinHttp.WinHttpRequest.5.1")

		if (Options["URLCodePage"]<>"")    							;����URL�ı���
			WebRequest.Option(2):=Options["URLCodePage"]
		if (Options["EnableRedirects"]<>"")							;�����Ƿ��ȡ��ת���ҳ����Ϣ
			WebRequest.Option(6):=Options["EnableRedirects"]
		;proxy_settingûֵʱ������Proxyֵ����������趨�Ƿ�Ҫ���д�����ʡ�
		;�����ĺô��Ƕ����������Ҫ����ʱ��Ȼֻ�ø��������������ַ���ɡ������Ѿ����������������ַ���ֿ��Ժܷ���Ķ��Ƿ����ô�����п��ء�
		if (Options["proxy_setting"]="" and Options["Proxy"]<>"")
			Options["proxy_setting"]:=2										;0��ʾ Proxycfg.exe ����������ѭ Proxycfg.exe �����ã�û������Ч��ͬ����Ϊ1����1��ʾ���Դ���ֱ����2��ʾʹ�ô���
		if (Options["proxy_setting"]="" and Options["Proxy"]="")
			Options["proxy_setting"]:=1
		;���ô����������΢��Ĵ��� SetProxy() �Ƿ��� Open() ֮ǰ�ģ�������Ҳ��ǰ�����ã�������Ч
		WebRequest.SetProxy(Options["proxy_setting"],Options["Proxy"],Options["ProxyBypassList"])
		if (Options["Timeout"]="")											;Options["Timeout"]���������Ϊ-1�������������޳�ʱ��������Ȼ��ѭSetTimeouts��4���������õ����ʱʱ��
			WebRequest.SetTimeouts(0,60000,30000,0)			;0��-1����ʾ��ʱ���޵ȴ������������ʾ���ʱ����λ���룩
		else if (Options["Timeout"]>30)									;�����ʱ���ô���30�룬����Ҫ��Ĭ�ϵ����ʱʱ���޸�Ϊ����30��
			WebRequest.SetTimeouts(0,60000,30000,Options["Timeout"]*1000)
		else
			WebRequest.SetTimeouts(0,60000,30000,30000)	;��ΪSetTimeouts��Ĭ�����á������Բ��ӣ���ΪĬ�Ͼ�������������������Ϊ�˱���������

		WebRequest.Open("GET", URL, true)   						;trueΪ�첽��ȡ��Ĭ����false�����ٵĸ�Դ���������ٵĸ�Դ������

		;SetRequestHeader() ���� Open() ֮�����Ч
		for k, v in RequestHeaders
		{
			if (k="Cookie")
			{
				WebRequest.SetRequestHeader("Cookie","tuzi")    ;������һ��cookie����ֹ����msdn�Ƽ���ô��
				WebRequest.SetRequestHeader("Cookie",v)
			}
			else
				WebRequest.SetRequestHeader(k,v)
		}

		Loop
		{
			WebRequest.Send()
			WebRequest.WaitForResponse(-1)								;WaitForResponse����ȷ����ȡ������������Ӧ��-1��ʾ����ʹ��SetTimeouts���õĳ�ʱ

			;��ȡ״̬�룬һ��statusΪ200˵������ɹ�
			this.Status:=WebRequest.Status()
			this.StatusText:=WebRequest.StatusText()

			if (Options["expected_status"]="" or Options["expected_status"]=this.Status)
				break
			;����ָ��������ҳ�淵�ص�״̬��������Ԥ��״̬�벻һ�£����׳�������ϸ������Ϣ����ʹ������һ����������ר�ż�¼�������ǣ�
			;��ʹnumber_of_retriesΪ�գ����ʽ��Ȼ���������Բ���Ϊnumber_of_retries���ó�ʼֵ��
			else if (A_Index>=Options["number_of_retries"])
			{
				this.extra.URL:=URL
				this.extra.Expected_Status:=Options["expected_status"]
				this.extra.Status:=this.Status
				this.extra.StatusText:=this.StatusText
				throw, Exception("����" Options.number_of_retries "�γ��Ժ󣬷���������״̬������������ֵ��һ��", -1, Object(this.extra))
			}
		}

		if (Options["Charset"]<>"") or (FilePath<>"")						;�����ַ��� �򱣴��ļ�
		{
			this.ResponseHeaders:=this.������Ϣ������(WebRequest.GetAllResponseHeaders())
			ADO:=ComObjCreate("adodb.stream")   		;ʹ�� adodb.stream ���뷵��ֵ���ο� http://bbs.howtoadmin.com/ThRead-814-1-1.html
			ADO.Type:=1														;�Զ����Ʒ�ʽ����
			ADO.Mode:=3 													;��ͬʱ���ж�д
			ADO.Open()  														;�������
			ADO.Write(WebRequest.ResponseBody())
			; д�������ע��û���� WebRequest.ResponseBody() ����һ�����������Ա��������ַ�ʽд�ļ�.
			if(FilePath<>"")
			{
				ADO.SaveToFile(FilePath,2)   						 	;�ļ������򸲸�
				ADO.Close()
			return, 1
			}
			Else
			{
			; ע�� WebRequest.ResponseBody() ��ȡ�������޷��ŵ�bytes��ͨ�� adodb.stream ת�����ַ���string
				ADO.Position:=0 												;��ͷ��ʼ
				ADO.Type:=2 														;������ģʽ����
				ADO.Charset:=Options["Charset"]    				;�趨���뷽ʽ
				ret_var:=ADO.ReadText()   								;������ڵ����ֶ���
				ADO.Close()
			return, ret_var
			}
		}
		Else
		{
			this.ResponseHeaders:=this.������Ϣ������(WebRequest.GetAllResponseHeaders())
		return, WebRequest.ResponseText()
		}
	}

	/*
	*****************�汾*****************
	UrlPost v 1.5

	*****************˵��*****************
	�˺������������� UrlDownloadToFile �����������¼��㣺
	1.ֱ�����ص�������û����ʱ�ļ���
	2.�����ٶȸ��죬���100%��
	3.��������ִ��ʱ������AHK�����ǿ���״̬���˺������ᡣ
	4.������������һЩ������վ�����硰ţ��������ʱ����������ý��̻��̳߳����������˺������ᡣ
	5.֧��������ҳ�ַ�����URL�ı��롣�����������ɽ����
	6.֧���������С�Request Header�����������У�Cookie��Referer��User-Agent��Referer��X-Requested-With����վ����������ɽ����
	7.֧�����ó�ʱ���������ȡ�
	8.֧�����ô�����������
	9.֧�������Ƿ��Զ��ض�����ַ��
	10.��RequestHeaders��������ʽ��chrome�Ŀ����߹����еġ�Request Header����ͬ����˿�ֱ�Ӹ��ƹ������ã�������ԡ�
	11.ʹ�á�POST����������˿��ϴ����ݡ�
	12.֧�ִ�ȡ��Cookie����������ģ���¼״̬��
	13.֧���ж���ҳ����ʱ��״̬�룬����200��404�ȡ�

	*****************����*****************
	URL ��ַ������������ơ�http://���Ŀ�ͷ����www.�����Ҳ���ϣ���Щ��վ��Ҫ��
	Data ���ݣ�Ĭ�����ı����������߹����С�Request Payload�����е����ݡ�
	Options��RequestHeaders�ĸ�ʽΪ��ÿ��һ����������������һ��ð��Ϊ��������֮������βΪ����ֵ������������С�����ɲ��ա�������Ϣ������()��ע���е����ӡ�

	*****************Options*****************
	֧������6�����ã���������ֵ���κ�Ч�����޴�СдҪ��
	Charset ��ҳ�ַ����������ǡ�936��֮������֣������ǡ�gb2312���������ַ���
	URLCodePage URL�ı��룬�ǡ�936��֮������֣�Ĭ���ǡ�65001������Щ��վ��ҪUTF-8����Щ��վ����Ҫgb2312��
	proxy_setting ������������ã�0��ʾʹ�á�Proxycfg.exe�������ã�1��ʾ���ӡ�Proxy��ָ���Ĵ����ֱ�����ӣ�2��ʾʹ�á�Proxy��ָ���Ĵ���
	Proxy ����������������硰http://www.tuzi.com:80�����ַ����������ݴ˴���ֵ�Զ����ú��ʵġ�proxy_setting������ͨ������²��ùܡ�proxy_setting�������������Լ����ơ�
	ProxyBypassList ������������������������硰*.microsoft.com����������������������ַ������ͨ��������������ʡ�
	EnableRedirects �ض���Ĭ�ϻ�ȡ��ת���ҳ����Ϣ��0Ϊ����ת��
	Timeout ��ʱ����λΪ�룬Ĭ�ϲ�ʹ�ó�ʱ��Timeout=-1����
	expected_status	״̬�룬ͨ��200��ʾ��ҳ������404��ʾ��ҳ�Ҳ����ˡ����ú���ҳ���ص�״̬����˴���һ�����׳�������Ϣ��������ʹ�ô˲�������ͬʱʹ��try��䣩��
	number_of_retries	���Դ�������״̬�����ʹ�ã�������ҳ���ص�״̬��������״̬�벻һ��ʱ���������ԵĴ�����

	*****************RequestHeaders*****************

	*****************ע��*****************
	��������Ĳ������뵽��RequestHeaders���У���ʾ�����֧��gzip����ѹ�����ᵼ�·���������ѹ��������ݹ�����
	Accept-Encoding:gzip,deflate,sdch�� ��ӽ�ѹ������δ����ʵ�ʵ�Ч����
	*/

	UrlPost(URL, PostData, Options:="", RequestHeaders:="",FilePath:="")
	{
		Options:=this.������Ϣ������(Options)
		RequestHeaders:=this.������Ϣ������(RequestHeaders)

		ComObjError(0) 														 		;���� COM ����ͨ�档���ú󣬼�� A_LastError ��ֵ���ű�����ʵ���Լ��Ĵ�����
		WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")

		if (Options["URLCodePage"]<>"")    							;����URL�ı���
			WebRequest.Option(2):=Options["URLCodePage"]
		if (Options["EnableRedirects"]<>"")							;�����Ƿ��ȡ��ת���ҳ����Ϣ
			WebRequest.Option(6):=Options["EnableRedirects"]
		;proxy_settingûֵʱ������Proxyֵ����������趨�Ƿ�Ҫ���д�����ʡ�
		;�����ĺô��Ƕ����������Ҫ����ʱ��Ȼֻ�ø��������������ַ���ɡ������Ѿ����������������ַ���ֿ��Ժܷ���Ķ��Ƿ����ô�����п��ء�
		if (Options["proxy_setting"]="" and Options["Proxy"]<>"")
			Options["proxy_setting"]:=2										;0��ʾ Proxycfg.exe ����������ѭ Proxycfg.exe �����ã�û������Ч��ͬ����Ϊ1����1��ʾ���Դ���ֱ����2��ʾʹ�ô���
		if (Options["proxy_setting"]="" and Options["Proxy"]="")
			Options["proxy_setting"]:=1
		;���ô����������΢��Ĵ��� SetProxy() �Ƿ��� Open() ֮ǰ�ģ�������Ҳ��ǰ�����ã�������Ч
		WebRequest.SetProxy(Options["proxy_setting"],Options["Proxy"],Options["ProxyBypassList"])
		if (Options["Timeout"]="")											;Options["Timeout"]���������Ϊ-1�������������޳�ʱ��������Ȼ��ѭSetTimeouts��4���������õ����ʱʱ��
			WebRequest.SetTimeouts(0,60000,30000,0)			;0��-1����ʾ��ʱ���޵ȴ������������ʾ���ʱ����λ���룩
		else if (Options["Timeout"]>30)									;�����ʱ���ô���30�룬����Ҫ��Ĭ�ϵ����ʱʱ���޸�Ϊ����30��
			WebRequest.SetTimeouts(0,60000,30000,Options["Timeout"]*1000)
		else
			WebRequest.SetTimeouts(0,60000,30000,30000)	;��ΪSetTimeouts��Ĭ�����á������Բ��ӣ���ΪĬ�Ͼ�������������������Ϊ�˱���������

		WebRequest.Open("POST", URL, true)   ;trueΪ�첽��ȡ��Ĭ����false�����ٵĸ�Դ���������ٵĸ�Դ������

		;SetRequestHeader() ���� Open() ֮�����Ч
		for k, v in RequestHeaders
		{
			if (k="Cookie")
			{
				WebRequest.SetRequestHeader("Cookie","tuzi")    ;������һ��cookie����ֹ����msdn�Ƽ���ô��
				WebRequest.SetRequestHeader("Cookie",v)
			}
			else
			WebRequest.SetRequestHeader(k,v)
		}
		if (RequestHeaders["Content-Type"]="")
			WebRequest.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
		Loop
		{
			WebRequest.Send(PostData)
			WebRequest.WaitForResponse(-1)								;WaitForResponse����ȷ����ȡ������������Ӧ��-1��ʾ����ʹ��SetTimeouts���õĳ�ʱ

			;��ȡ״̬�룬һ��statusΪ200˵������ɹ�
			this.Status:=WebRequest.Status()
			this.StatusText:=WebRequest.StatusText()

			if (Options["expected_status"]="" or Options["expected_status"]=this.Status)
				break
			;����ָ��������ҳ�淵�ص�״̬��������Ԥ��״̬�벻һ�£����׳�������ϸ������Ϣ����ʹ������һ����������ר�ż�¼�������ǣ�
			;��ʹnumber_of_retriesΪ�գ����ʽ��Ȼ���������Բ���Ϊnumber_of_retries���ó�ʼֵ��
			else if (A_Index>=Options["number_of_retries"])
			{
				this.extra.URL:=URL
				this.extra.Expected_Status:=Options["expected_status"]
				this.extra.Status:=this.Status
				this.extra.StatusText:=this.StatusText
				throw, Exception("����" Options.number_of_retries "�γ��Ժ󣬷���������״̬������������ֵ��һ��", -1, Object(this.extra))
			}
		}
		if (Options["Accept-Encoding"]<>"") && (WebRequest.GetResponseHeader("Content-Encoding") = "gzip")
		{
			this.ResponseHeaders:=this.������Ϣ������(WebRequest.GetAllResponseHeaders())
			body := WebRequest.ResponseBody
			size := body.MaxIndex() + 1
		
			VarSetCapacity(data, size)
			DllCall("oleaut32\SafeArrayAccessData", "ptr", ComObjValue(body), "ptr*", pdata)
			DllCall("RtlMoveMemory", "ptr", &data, "ptr", pdata, "ptr", size)
			DllCall("oleaut32\SafeArrayUnaccessData", "ptr", ComObjValue(body))
			size := GZIP_DecompressBuffer(data, size)
			if(FilePath<>"")
			{
				FileOpen(FilePath, "w").RawWrite(&data, size)
			return 1
			}
			else
			return StrGet(&data, size, Options["Charset"])
		}

		if (Options["Charset"]<>"") or (FilePath<>"")									;�����ַ���
		{
			this.ResponseHeaders:=this.������Ϣ������(WebRequest.GetAllResponseHeaders())
			ADO:=ComObjCreate("adodb.stream") 		 	;ʹ�� adodb.stream ���뷵��ֵ���ο� http://bbs.howtoadmin.com/ThRead-814-1-1.html
			ADO.Type:=1 														;�Զ����Ʒ�ʽ����
			ADO.Mode:=3 													;��ͬʱ���ж�д
			ADO.Open()  														;�������
			ADO.Write(WebRequest.ResponseBody())    	;д�������ע�� WebRequest.ResponseBody() ��ȡ�������޷��ŵ�bytes��ͨ�� adodb.stream ת�����ַ���string
			if(FilePath<>"")
			{
				ADO.SaveToFile( FilePath, 2 )
				oADO.Close()
				return, 1
			}
			else
			{
				ADO.Position:=0 												;��ͷ��ʼ
				ADO.Type:=2 														;������ģʽ����
				ADO.Charset:=Options["Charset"]   				;�趨���뷽ʽ
				ret_var:=ADO.ReadText()   								;������ڵ����ֶ���
				ADO.Close()
				return, ret_var
			}
		}
		else
		{
			this.ResponseHeaders:=this.������Ϣ������(WebRequest.GetAllResponseHeaders())
		return, WebRequest.ResponseText()
		}
	}

	/*
	infos�ĸ�ʽ��ÿ��һ����������������һ��ð��Ϊ��������֮������βΪ����ֵ������������С�
	���仰˵��chrome�Ŀ����߹����С�Request Header���Ƕ�����ֱ�Ӹ��ƹ��������á�
	��Ҫע���һ�С�GET /?tn=sitehao123 HTTP/1.1����ʵ��û���κ����õģ���Ϊû�С�:���������ƹ�����Ҳ������Ӱ������������

	infos=
	(
	GET /?tn=sitehao123 HTTP/1.1
	Host: www.baidu.com
	Connection: keep-alive
	Cache-Control: max-age=0
	Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
	User-Agent: Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36 SE 2.X MetaSr 1.0
	DNT: 1
	Referer: http://www.hao123.com/
	Accept-Encoding: gzip,deflate,sdch
	Accept-Language: zh-CN,zh;q=0.8
	)
	*/
	������Ϣ������(infos)
	{
		if (IsObject(infos)=1)
			return, infos

		;���������ɽ���infos�����з�ͳһΪ`r`n������������ʽ��ȡʱ����
		StringReplace, infos, infos, `r`n, `n, All
		StringReplace, infos, infos, `n, `r`n, All

		infos_temp:=GlobalRegExMatch(infos,"m)(^.*?):(.*$)",1)
		;������ƥ�䵽����Ϣ�����µĶ����У�������{"Connection":"keep-alive","Cache-Control":"max-age=0"}
		infos:=[]
		Loop, % infos_temp.MaxIndex()
		{
			name:=Trim(infos_temp[A_Index].Value[1], " `t`r`n`v`f")						;Trim()�����þ��ǰѡ�abc: haha����haha�Ķ���հ׷�����
			value:=Trim(infos_temp[A_Index].Value[2], " `t`r`n`v`f")

			;��Set-Cookie���ǿ���һ�η��ض����ġ�
			if (name="Set-Cookie")
				infos[name].=value . "`r`n"
			else
				infos[name]:=value
		}

		return, infos
	}

	/*
	�ڡ�GetAllResponseHeaders���У���Set-Cookie������һ�δ��ڶ�������硰Set-Cookie:name=a; domain=xxx.com `r`n Set-Cookie:name=b; domain=www.xxx.com����
	֮�������������cookie��ʱ�򣬻�����֤domain������֤path�����߶��ɹ����ٷ������з���������cookies��
	domain��ƥ�䷽ʽ�Ǵ��ַ�����β����ʼ�Ƚϡ�
	path��ƥ�䷽ʽ�Ǵ�ͷ��ʼ���ַ����Ƚϣ�����/blog��/blog��/blogrool�ȵȶ�ƥ�䣩����Ҫע����ǣ�pathֻ��domain���ƥ���űȽϡ�
	���´η��ʡ�www.xxx.com��ʱ��������2������������cookie�����Է��͸���������cookieӦ���ǡ�name=b; name=a����
	���´η��ʡ�xxx.com��ʱ������ֻ��1������������cookie�����Է��͸���������cookieӦ���ǡ�name=a����
	�����ǣ�pathԽ��ϸ��Խ��ǰ��domainԽ��ϸ��Խ��ǰ��domain��path������������ַ�ˣ���
	������Ҫע����ǣ���Set-Cookie����û��domain����path�Ļ������Ե�ǰurlΪ׼��
	���Ҫ����һ�����е�cookieֵ����ô��Ҫ����һ��name��domain��path����ȫ��ͬ�ġ�Set-Cookie����name���ǡ�cookie:name=value; path=/���е�name����
	��һ��cookie���ڣ����ҿ�ѡ��������Ļ�����cookie��ֵ���ڽ�������ÿ�������б���������������
	��ֵ���洢����ΪCookie��HTTP��Ϣͷ�У�����ֻ������cookie��ֵ��������ѡ��ȫ����ȥ����expires��domain��path��secureȫ��û���ˣ���
	�����ָ�����������ж��cookies����ô���ǻᱻ�ֺźͿո�ֿ������磺��Cookie:value1 ; value2 ; name1=value1��
	��û��expiresѡ��ʱ��cookie�����������ڵ�һ�ĻỰ�С�������Ĺر���ζ��һ�λỰ�Ľ��������ԻỰcookieֻ��������������ִ򿪵�״̬֮�¡�
	���expiresѡ��������һ����ȥ��ʱ��㣬��ô���cookie�ᱻ����ɾ����
	���һ��ѡ����secure����������ѡ���ѡ��ֻ��һ����ǲ���û��������ֵ��
	��http://my.oschina.net/hmj/blog/69638�� �ο��𰸡�
	Ҫ��������ȫ����������Զ�����cookies��ÿ�����ӷ���Ӧ��cookie���Ѷ��Ĵ�ģ���¼ʲô�ģ�����һ��һ����ȡ����cookie�ٷ��͸����������ۺϿ��ǣ���ʱ��д�Զ�����
	*/

	;����cookie(cookie)
	;{
	;	return
	;}
}

GZIP_DecompressBuffer( ByRef var, nSz ) { ; 'Microsoft GZIP Compression DLL' SKAN 20-Sep-2010
; Decompress routine for 'no-name single file GZIP', available in process memory.
; Forum post :  www.autohotkey.com/forum/viewtopic.php?p=384875#384875
; Modified by Lexikos 25-Apr-2015 to accept the data size as a parameter.
	
; Modified version by tmplinshi
	static hModule, _
	static GZIP_InitDecompression, GZIP_CreateDecompression, GZIP_Decompress
     , GZIP_DestroyDecompression, GZIP_DeInitDecompression

	If !hModule {
		If !hModule := DllCall("LoadLibrary", "Str", "gzip.dll", "Ptr")		
		;If !hModule := DllCall(A_ScriptDir "\lib\gzip.dll", "Str", "gzip.dll", "Ptr")
		{			
			MsgBox % "Error: Loading gzip.dll failed! Exiting App."
			ExitApp
		}
		For k, v in ["InitDecompression","CreateDecompression","Decompress","DestroyDecompression","DeInitDecompression"]
			GZIP_%v% := DllCall("GetProcAddress", Ptr, hModule, "AStr", v, "Ptr")
		
		_ := { base: {__Delete: "GZIP_DecompressBuffer"} }
	}
	If !_ 
		Return DllCall("FreeLibrary", "Ptr", hModule)
	
	vSz :=  NumGet( var,nsz-4 ), VarSetCapacity( out,vsz,0 )
	DllCall( GZIP_InitDecompression )
	DllCall( GZIP_CreateDecompression, UIntP,CTX, UInt,1 )
	If ( DllCall( GZIP_Decompress, UInt,CTX, UInt,&var, UInt,nsz, UInt,&Out, UInt,vsz
    , UIntP,input_used, UIntP,output_used ) = 0 && ( Ok := ( output_used = vsz ) ) )
		VarSetCapacity( var,64 ), VarSetCapacity( var,0 ), VarSetCapacity( var,vsz,32 )
    , DllCall( "RtlMoveMemory", UInt,&var, UInt,&out, UInt,vsz )
	DllCall( GZIP_DestroyDecompression, UInt,CTX ),  DllCall( GZIP_DeInitDecompression )
	Return Ok ? vsz : 0
}

;�˺����� RegExMatch() ����������
;1.�� 3 ������,����������Ϊ StartingPosition
;2.����ֵ���������,��ÿ��ֵ����ʹ�� "O" ѡ��ص�ƥ�����
;���� ����ֵ.1.Pos[0] �� ����ֵ[2].Len[1] �ȷ�ʽ��ȡÿ������ĸ�����Ϣ. ������Ի�ȡ��ʲô,��ο� "ƥ�����"
;���� ����ֵ.MaxIndex()="" �ж���ƥ��
GlobalRegExMatch(Haystack,NeedleRegEx,StartingPosition)
  {
    ObjOut:=[]
    NeedleRegEx:=�������Oѡ��(NeedleRegEx)					;Ϊ������� "O" ѡ��
    Loop
      {
        RegExMatch(Haystack,NeedleRegEx,UnquotedOutputVar,StartingPosition)	;ע�����������,��������ȴʵ����������ź��Ч������ ���ҵĸ�Դ������Щ�ط�����
        If (UnquotedOutputVar.Value[0]="")					;����ֱ��ʹ�øú�������ֵ�ж��Ƿ��ҵ�����. �ڱ��ʽΪ "0*$" ,��ƥ���ִ�Ϊ "100.101" ,����ַ��� λ��8 , ����0 �Ĵ���
            break								;ƥ��ֵΪ��(��������ʧ��),���˳�ѭ��������ѭ��
        StartingPosition:=UnquotedOutputVar.Pos[0]+UnquotedOutputVar.Len[0]	;ƥ��ɹ��������´�ƥ�����Ϊ�ϴγɹ�ƥ���ַ�����ĩβ. ��������ʹ���ʽ "ABCABC" ,ƥ���ַ��� "ABCABCABCABC" ʱ���� 2 �ν��
        ObjOut.Insert(UnquotedOutputVar)
      }
    return,ObjOut
  }

;�˺������õ�ͬ RegExMatch() ,��Ҫ������ͳһ����ֵ��ʽ,���ڴ���
RegExMatchLikeGlobal(Haystack,NeedleRegEx,StartingPosition)
  {
    ObjOut:=[]
    NeedleRegEx:=�������Oѡ��(NeedleRegEx)					;Ϊ������� "O" ѡ��
    RegExMatch(Haystack,NeedleRegEx,UnquotedOutputVar,StartingPosition)
    If (UnquotedOutputVar.Value[0]<>"")
        ObjOut.Insert(UnquotedOutputVar)
    return,ObjOut
  }

;�˺������ڸ�������ʽ��� "O" ѡ��,ʹ���������Ϊƥ�����,���ڷ�������
;����ֵ��ȷ�� "O" ѡ����ڲ�����һ��,������� OimO)abc.* �������
;���뵽�˺����е�������ʽΪ�������ŵ�����,�ɰ���ѡ��. ���� im)abc.* ����֧��. "im)123.*" ����֧��
�������Oѡ��(NeedleRegEx)
{
  ѡ��ָ���λ��:=InStr(NeedleRegEx,")")
  If (ѡ��ָ���λ��<>0)
    {
      ����ѡ��:=SubStr(NeedleRegEx,1,ѡ��ָ���λ��)
      ����:=SubStr(NeedleRegEx,ѡ��ָ���λ��+1)
      StringCaseSense, On			;��Сд����
      StringReplace, temp, ����ѡ��, i, , All	;������������ʽѡ���п��ܴ��ڵ��ַ�
      StringReplace, temp, temp, m, , All
      StringReplace, temp, temp, s, , All
      StringReplace, temp, temp, x, , All
      StringReplace, temp, temp, A, , All
      StringReplace, temp, temp, D, , All
      StringReplace, temp, temp, J, , All
      StringReplace, temp, temp, U, , All
      StringReplace, temp, temp, X, , All
      StringReplace, temp, temp, P, , All
      StringReplace, temp, temp, S, , All
      StringReplace, temp, temp, C, , All
      StringReplace, temp, temp, O, , All
      StringReplace, temp, temp, `n, , All
      StringReplace, temp, temp, `r, , All
      StringReplace, temp, temp, `a, , All
      StringReplace, temp, temp, %A_Space%, , All
      StringReplace, temp, temp, %A_Tab%, , All
      StringCaseSense, Off
      If (temp=")")				;���������ʣ������ ")" ,˵��������ŵ�������ѡ��ָ���
        {
          If (InStr(����ѡ��,"O",1)<>0)		;��Сд���еļ��ѡ�����Ƿ���� "O" ѡ��,��ȷ������ڲ�Ψһ
              return,NeedleRegEx		;����ѡ�� "O" ��ֱ�ӷ���
          Else
              return,"O" . ����ѡ�� . ����	;���ѡ�� "O" ������
        }
    }
  return,"O)" . NeedleRegEx
}