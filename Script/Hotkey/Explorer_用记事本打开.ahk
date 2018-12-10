�ü��±���:
EditSelectedFiles()
Return

EditSelectedFiles()
{
	global TextEditor,ImageEditor,DefaultPlayer
	ImageExtensions = jpg,png,bmp,gif,tga,tif,ico,jpeg
	audioExtensions = wma,mp3,wav,mdi
	files:=GetSelectedFiles()
	SplitByExtension(files, Imagesplitfiles, ImageExtensions)
	SplitByExtension(files, audiosplitfiles, audioExtensions)
	files:=RemoveLineFeedsAndSurroundWithDoubleQuotes(files)
	Imagesplitfiles:=RemoveLineFeedsAndSurroundWithDoubleQuotes(Imagesplitfiles)
	audiosplitfiles:=RemoveLineFeedsAndSurroundWithDoubleQuotes(audiosplitfiles)
	x:=ExpandEnvVars(TextEditor)
	y:=ExpandEnvVars(ImageEditor)
	z:=% %DefaultPlayer%
	if(!FileExist(x))
{
		TrayTip,���ô���,Ĭ���ı��༭����·������,3
return
}
	if(!FileExist(y))
{
		TrayTip,���ô���,Ĭ��ͼƬ�༭����·������,3
return
}
	if(!FileExist(z))
{
		TrayTip,���ô���,Ĭ����Ƶ��������·������,3
return
}
	if (files || Imagesplitfiles ||audiosplitfiles)
	{
		if files
			run %x% %files%
		if Imagesplitfiles
			run %y% %Imagesplitfiles%
		if audiosplitfiles
		{
			if (DefaultPlayer != "AhkPlayer")
				Run "%z%" %audiosplitfiles%
			else
				run %A_AhkPath% "%z%" %audiosplitfiles%
		}
	}
	else
		SendInput {F6}
	return
}

SplitByExtension(ByRef files, ByRef SplitFiles,extensions)
{
	;Init string incase it wasn't resetted before or so
	Splitfiles:=""
	Loop, Parse, files, `n,`r  ; Rows are delimited by linefeeds ('r`n).
	{
		SplitPath, A_LoopField , , , OutExtension
	  if (InStr(extensions, OutExtension) && OutExtension!="")
	  {
	  	Splitfiles .= A_LoopField "`n"
	  }
	  else
	  {
	  	newFiles .= A_LoopField "`n"
	  }
	}
	files:=strTrimRight(newFiles,"`n")
	SplitFiles:=strTrimRight(SplitFiles,"`n")
	return
}

RemoveLineFeedsAndSurroundWithDoubleQuotes(files)
{
	result:=""
	Loop, Parse, files, `n,`r  ; Rows are delimited by linefeeds ('r`n).
   {
      if !InStr(FileExist(A_LoopField), "D")
   			result=%result% "%A_LoopField%"
   }
   return result
}