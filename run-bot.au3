;~ Opt("MustDeclareVars", 1)
;~ #AutoIt3Wrapper_UseX64=y
;~ #AutoIt3Wrapper_Change2CUI=y
#RequireAdmin

#include "_ImageSearch_UDF.au3"

HotKeySet("{Esc}", "_Exit") ; Press ESC for exit
Func _Exit()
    Exit 0
EndFunc   ;==>_Exit

;~ Global Const $Ask_On_Found = 0
;~ Global Const $Mouse_Move_On_Found = 1
;~ Global Const $Mouse_Click_On_Found = 0

;~ Global Const $iSleep_Time=500

;~ Global $sCount = 0, $_Image_1 = @ScriptDir & "\myHeroes.bmp"

;~ ; First, use this function to create a file bmp, maybe a desktop icon for example')
;~ MsgBox(64 + 262144, 'ImageSearch', 'At first, create a file bmp,' & @CRLF & 'photos that will search on the screen!')
;~ _ImageSearch_Create_BMP($_Image_1)

;~ ConsoleWrite("! Search for images: " & $_Image_1 & @CRLF & '! Searching on the screen ...' & @CRLF)

;~ While 1
;~     ToolTip('(Press ESC for EXIT) Searching ...', 1, 1)
;~ 	Sleep($iSleep_Time)
;~ 	$sCount += 1
;~     Local $return = _ImageSearch($_Image_1)
;~     If $return[0] = 1 Then
;~         ConsoleWrite('- [' & $sCount & '] Image found:' & " X=" & $return[1] & " Y=" & $return[2] & @CRLF)
;~         If $Mouse_Move_On_Found Then
;~ 			MouseMove($return[1], $return[2])
;~ 			Sleep($iSleep_Time)
;~ 		EndIf
;~         If $Mouse_Click_On_Found Then MouseClick("left", $return[1], $return[2])
;~         ToolTip('(Press ESC for EXIT) - [' & $sCount & "] Image found:" &  " X=" & $return[1] & " Y=" & $return[2], 1, 1)
;~         If $Ask_On_Found Then
;~             Local $ask = MsgBox(6 + 262144, 'Success [' & $sCount & ']', 'Image found:' & " X=" & $return[1] & " Y=" & $return[2])
;~             If $ask = 2 Or $ask = 3 Or $ask = 5 Or $ask = 7 Then Exit ;No, Abort, Cancel, and Ignore
;~             If $ask = 10 Then _ImageSearch_Create_BMP($_Image_1) ; Continue       ;Try Again
;~         EndIf
;~     EndIf
;~     Sleep(200)
;~ WEnd
Global $state = 0
$myHeroes = @ScriptDir & "\myHeroes.bmp"
$heroCanFight1 = @ScriptDir & "\heroCanFight1.bmp"
$heroCanFight2 = @ScriptDir & "\heroCanFight2.bmp"
$heroCanFight3 = @ScriptDir & "\heroCanFight3.bmp"
$heroCanFight4 = @ScriptDir & "\heroCanFight4.bmp"
$backFromMyHeroes = @ScriptDir & "\backFromMyHeroes.bmp"
$goToMage = @ScriptDir & "\goToMage.bmp"
$fightMage = @ScriptDir & "\fightMage.bmp"
$checkGasOk1 = @ScriptDir & "\checkGasOk1.bmp"
$checkGasOk2 = @ScriptDir & "\checkGasOk2.bmp"
$reject = @ScriptDir & "\reject.bmp"
$confirm = @ScriptDir & "\confirm.bmp"
$closeResult = @ScriptDir & "\closeResult.bmp"
$backToHome = @ScriptDir & "\backToHome.bmp"

Global $state5cout = 0;
While 1
   ;~ state 0, searching my heroes
   if $state = 0 Then
	  Local $return = _ImageSearch($myHeroes)
	  If $return[0] = 1 Then
		 MouseMove($return[1], $return[2])
		 MouseClick("left", $return[1], $return[2])
		 $state = 1
	  EndIf
   EndIf

   ;~ state 1, searching hero which can fight
   if $state = 1 Then
	  Sleep(2000)
	  Local $return = _ImageSearch($heroCanFight1)
	  Local $return2 = _ImageSearch($heroCanFight2)
	  Local $return3 = _ImageSearch($heroCanFight3)
	  Local $return4 = _ImageSearch($heroCanFight4)
	  If $return[0] = 1 Then
		 MouseClick("left", $return[1], $return[2])
		 $state = 2
	  ElseIf $return2[0] = 1 Then
		 MouseClick("left", $return2[1], $return2[2])
		 $state = 2
	  ElseIf $return3[0] = 1 Then
		 MouseClick("left", $return3[1], $return3[2])
		 $state = 2
	  ElseIf $return4[0] = 1 Then
		 MouseClick("left", $return4[1], $return4[2])
		 $state = 2
	  Else
;~ 		 MouseMove(50, 150)
		 MouseClick("left", 50, 150)
;~ 		 Local $return = _ImageSearch($backFromMyHeroes)
;~ 		 If $return[0] = 1 Then
;~ 			MouseMove($return[1], $return[2])
;~ 			MouseClick("left", $return[1], $return[2])
			$state = 0
;~ 		 EndIf
	  EndIf
   EndIf

   if $state = 2 Then
	  Local $return = _ImageSearch($goToMage)
	  If $return[0] = 1 Then
		 MouseMove($return[1], $return[2])
		 MouseClick("left", $return[1], $return[2])
		 $state = 3
	  EndIf
   EndIf

   if $state = 3 Then
	  Local $return = _ImageSearch($fightMage)
	  If $return[0] = 1 Then
		 MouseMove($return[1], $return[2])
		 MouseClick("left", $return[1], $return[2])
		 $state = 4
	  EndIf
   EndIf

   if $state = 4 Then
	  Sleep(2000)
	  Local $return = _ImageSearch($checkGasOk1)
	  Local $return2 = _ImageSearch($checkGasOk2)
	  If $return[0] = 1 Then
		 Local $imgConfirm = _ImageSearch($confirm)
		 If $imgConfirm[0] = 1 Then
			MouseMove($imgConfirm[1], $imgConfirm[2])
			MouseClick("left", $imgConfirm[1], $imgConfirm[2])
			$state = 5
			$state5cout = 0
		 EndIf
;~ 	  ElseIf $return2[0] = 1 Then
;~ 		 Local $imgConfirm = _ImageSearch($confirm)
;~ 		 If $imgConfirm[0] = 1 Then
;~ 			MouseMove($imgConfirm[1], $imgConfirm[2])
;~ 			MouseClick("left", $imgConfirm[1], $imgConfirm[2])
;~ 			$state = 5
;~ 			$state5cout = 0
;~ 		 EndIf
	  Else
		 Local $imgReject = _ImageSearch($reject)
		 If $imgReject[0] = 1 Then
			MouseMove($imgReject[1], $imgReject[2])
			MouseClick("left", $imgReject[1], $imgReject[2])
			$state = 6
		 EndIf
	  EndIf
   EndIf

   if $state = 5 Then
	  $state5cout = $state5cout + 1
	  Local $return = _ImageSearch($closeResult)
	  If $return[0] = 1 Then
		 MouseClick("left", $return[1], $return[2])
		 $state = 6
   	  ElseIf $state5cout = 600 Then
		 $state = 6
	  EndIf
   EndIf

   if $state = 6 Then
	  MouseClick("left", 50, 150)
	  $state = 0
   EndIf

   Sleep(1000)
WEnd