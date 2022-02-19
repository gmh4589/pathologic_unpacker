
#include <File.au3>
#include <Array.au3>
#include <Binary.au3>

MorUnpacker()

Func MorUnpacker()
	$sFileName = FileOpenDialog ('', " ", "Pathologic Files (*.vfs)|All Files (*.*)", 1+4)
		If @error = 1 then Return
	
		Local $iDrive, $iDir, $iName, $iExp
		_PathSplit ($sFileName, $iDrive, $iDir, $iName, $iExp)
	
		$iFile = FileOpen($sFileName, 16)
		FileSetPos ($iFile, 8, 0)
		
		$iFileC = _BinaryToInt32(FileRead($iFile, 4))
	
	ProgressOn('', 'Wait...', '', (@DesktopWidth/2)-150, (@DesktopHeight/2)-62, 18)
		For $i = 1 to $iFileC
			$iNameLong = FileRead($iFile, 1)
			$iNameFile = BinaryToString(FileRead($iFile, $iNameLong))
			$iPos = FileGetPos ($iFile)
			$iFileSize = _BinaryToInt32(FileRead($iFile, 4))
			$iFileOffset = _BinaryToInt32(FileRead($iFile, 4))
			;MsgBox (0, '', $iNameFile & @CRLF & _BinaryFromInt32($iFileSize) & @CRLF & _BinaryFromInt32($iFileOffset))
			FileSetPos ($iFile, $iFileOffset, 0)
			$iData = FileRead($iFile, $iFileSize)
			$iNewFile = FileOpen($iDrive & '\' & $iDir & '\' & $iName & '\' & $iNameFile, 26)
			FileWrite ($iNewFile, $iData)
			FileClose ($iNewFile)
			FileSetPos ($iFile, $iPos + 16, 0)
			ProgressSet((100/$iFileC) * $i, 'Saved: ' & @TAB & $iNameFile & @CRLF & $i & "/" & $iFileC)
		Next
	ProgressSet(100, 'Done!')
		
EndFunc
