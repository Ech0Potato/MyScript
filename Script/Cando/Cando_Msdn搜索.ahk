Cando_msdn����:
funct_string=https://www.bing.com/search?q=%candysel%+msdn
a := URLDownloadToVar(funct_string,"utf-8")
RegExmatch(a,"m)(*ANYCRLF).*href\=""(https://msdn.*\(v=vs.85\).aspx)"".*",m)   ;ƥ���������������    ���������ƥ�䵽
dizhi:= m1
if dizhi=
{
run https://social.msdn.microsoft.com/search/en-us/windows?query=%candysel%&Refinement=183
return
}
else
run %dizhi%
return