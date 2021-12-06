;~ Opt("MustDeclareVars", 1)
;~ #AutoIt3Wrapper_UseX64=y
;~ #AutoIt3Wrapper_Change2CUI=y
#RequireAdmin

#include "_ImageSearch_UDF.au3"
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>

HotKeySet("{Esc}", "_Exit") ; Press ESC for exit
Func _Exit()
    Exit 0
 EndFunc   ;==>_Exit

HotKeySet("{Enter}", "_Start") ; Press Enter for start
Func _Start()
    $state = 0;
EndFunc   ;==>_Start

Global $enemy = 1 ; 0 = boss, 1 = mage
Global $state = 0
Global $timeForWaitingConfrim = 600;
Global $state5cout = 0;
Global $maxAccout = 3;
Global $currentAccout = 1;
Global $forceAccout = 1;
Global $changeAccoutState = 0;
Global $delayForChangeAccoutTo1 = 3600000 ; 60 minutes

While 1
   Local $return = search("\connectToMetamask")
   If $return[0] = 1 Then
	  MouseClick("left", $return[1], $return[2])
	  Sleep(2000)
   ElseIf $currentAccout <> $forceAccout Then
	  $currentAccout = changeAccout($currentAccout, $forceAccout)
   Else
	  ;~ state 0, searching my heroes
	  if $state = 0 Then
		 resetCss()
		 Local $return = search("\myHeroes")
		 If $return[0] = 1 Then
			MouseClick("left", $return[1], $return[2])
			$state = 1
			Sleep(2000)
		 EndIf
	  EndIf

	  ;~ state 1, searching hero which can fight
	  if $state = 1 Then
		 resetCss()
;~ 		 Local $recruit = search("\recruit")
		 Local $unlock = search("\unlock")
;~ 		 If $recruit[0] = 1 Then
;~ 			MouseClick("left", $recruit[1], $recruit[2])
;~ 			Sleep(5000)
;~ 			Local $recruit = search("\recruit")
;~ 			If $recruit[0] = 1 Then
;~ 			   MouseClick("left", $recruit[1], $recruit[2])
;~ 			   $state = 7
;~ 			   Sleep(2000)
;~ 			EndIf
;~ 		 ElseIf $unlock[0] = 1 Then
		 If $unlock[0] = 1 Then
			MouseClick("left", $unlock[1], $unlock[2])
			$state = 4
			Sleep(2000)
		 Else
			Local $return = search("\heroCanFight")
			If $return[0] = 1 Then
			   MouseClick("left", $return[1], $return[2])
			   $state = 2
			   Sleep(2000)
			Else
			   MouseClick("left", 50, 150)
			   $state = 0
			   Sleep(2000)
			   $forceAccout = $forceAccout + 1
			   If $forceAccout > $maxAccout Then
				  $forceAccout = 1
				  Sleep($delayForChangeAccoutTo1)
				  Send("{F5}")
			   EndIf
			EndIf
		 EndIf
	  EndIf

	  if $state = 2 Then
		 resetCss()
		 If $enemy = 0 Then
			Local $return = search("\goToBoss")
			If $return[0] = 1 Then
			   MouseClick("left", $return[1], $return[2])
			   $state = 3
			   Sleep(2000)
			EndIf
		 ElseIf $enemy = 1 Then
			Local $return = search("\goToMage")
			If $return[0] = 1 Then
			   MouseClick("left", $return[1], $return[2])
			   Sleep(2000)
			   Local $mage = search("\mage")
			   If $mage[0] = 1 Then
				  MouseClick("left", $mage[1], $mage[2])
				  $state = 3
				  Sleep(2000)
			   EndIf
			Else
			   $state = 6
			   Sleep(2000)
			EndIf
		 EndIf
	  EndIf

	  if $state = 3 Then
		 If $enemy = 0 Then
			Local $return = search("\fightBoss")
			If $return[0] = 1 Then
			   MouseClick("left", $return[1], $return[2])
			   $state = 4
			   Sleep(2000)
			Else
			   $state = 6
			   Sleep(2000)
			EndIf
		 ElseIf $enemy = 1 Then
			Local $return = search("\fightMage")
			If $return[0] = 1 Then
			   MouseClick("left", $return[1], $return[2])
			   $state = 4
			   Sleep(2000)
			EndIf
		 EndIf
	  EndIf

	  if $state = 4 Then
		 Local $return = search("\checkGasOk")
		 If $return[0] = 1 Then
			MouseMove($return[1], $return[2])
			Local $return = search("\confirm")
			If $return[0] = 1 Then
			   MouseClick("left", $return[1], $return[2])
			   $state = 5
			   $state5cout = 0
			   Sleep(2000)
			EndIf
		 Else
			Local $return = search("\reject")
			If $return[0] = 1 Then
			   MouseClick("left", $return[1], $return[2])
			   $state = 6
			   Sleep(2000)
			EndIf
		 EndIf
	  EndIf

	  ; confirm transaction
	  if $state = 5 Then
		 $state5cout = $state5cout + 1
		 Local $return = search("\closeResult")
		 Local $return2 = search("\confirmedTransaction")
		 If $return[0] = 1 Then
			MouseClick("left", $return[1], $return[2])
			$state = 6
			Sleep(2000)
		 ElseIf $return2[0] = 1 Then
			$state = 6
			Sleep(2000)
		 ElseIf $state5cout = $timeForWaitingConfrim Then
			$state = -1 ; not confirm in xx minute then pause until press 'Enter'
			MsgBox($MB_SYSTEMMODAL, "Errer network", "Press 'Enter' to start bot again !")
		 EndIf
	  EndIf

	  ; back to home
	  if $state = 6 Then
		 MouseClick("left", 50, 150)
		 Sleep(200)
		 MouseClick("left", 50, 150)
		 $state = 0
	  EndIf

	  ; recruit check gas
	  if $state = 7 Then
		 Local $return = search("\checkGasRecruit")
		 If $return[0] = 1 Then ; if gas is ok
			MouseMove($return[1], $return[2])
			Local $return = search("\confirm")
			If $return[0] = 1 Then
			   MouseClick("left", $return[1], $return[2]) ; confirm then go wait for confirm
			   $state = 5
			   $state5cout = 0
			   Sleep(2000)
			EndIf
		 Else ; if gas not ok, reject
			Local $return = search("\reject")
			If $return[0] = 1 Then
			   MouseClick("left", $return[1], $return[2])
			   Local $return = search("\closeResult") ; if found close button
			   If $return[0] = 1 Then
				  MouseClick("left", $return[1], $return[2])
				  $state = 6
				  Sleep(2000)
			   Else ; else go back
				  $state = 6
				  Sleep(2000)
			   EndIf
			EndIf
		 EndIf
	  EndIf
   EndIf
   Sleep(100)
WEnd

Func changeAccout($_currentAccout, $_forceAccout)
   If $changeAccoutState = 0 Then
	  Local $return = search("\metamask")
	  If $return[0] = 1 Then
		 MouseClick("left", $return[1], $return[2])
		 $changeAccoutState = 1
	  EndIf
   ElseIf $changeAccoutState = 1 Then
	  Local $return = search("\openedMetamask")
	  If $return[0] = 1 Then
		 MouseClick("left", $return[1]+150, $return[2])
		 $changeAccoutState = 2
		 Sleep(1000)
	  EndIf
   ElseIf $changeAccoutState = 2 Then
	  Local $return = searchSpecific("\accout",$_forceAccout)
	  If $return[0] = 1 Then
		 MouseClick("left", $return[1]+150, $return[2])
		 $changeAccoutState = 0
		 Return $_forceAccout
	  Else
		 Local $return = search("\moveDown")
		 If $return[0] = 1 Then
			MouseClick("left", $return[1], $return[2])
			MouseMove($return[1], $return[2]+50)
		 EndIf
	  EndIf
   EndIf
   Return $_currentAccout
EndFunc

Func resetCss()
   Local $return = search("\resetCss")
   If $return[0] = 1 Then
	  MouseClick("left", $return[1], $return[2])
   EndIf
   Sleep(2000)
   Local $return = search("\resetCss")
   If $return[0] = 1 Then
	  MouseClick("left", $return[1], $return[2], 2)
   EndIf
EndFunc

Func search($image)
   For $i = 1 To 20
	  Local $sFilePath = @ScriptDir &$image&$image&$i&".bmp"
	  Local $iFileExists = FileExists($sFilePath)
	  If $iFileExists Then
		 Local $return = _ImageSearch($sFilePath)
		 If $return[0] = 1 Then
			Return $return
		 EndIf
	  EndIf
   Next
   Local $_Return[3] = [0,0,0]
   Return $_Return
EndFunc

Func searchSpecific($image,$number)
   Local $sFilePath = @ScriptDir &$image&$image&$number&".bmp"
   Local $iFileExists = FileExists($sFilePath)
   If $iFileExists Then
	  Local $return = _ImageSearch($sFilePath)
	  If $return[0] = 1 Then
		 Return $return
	  EndIf
   EndIf
   Local $_Return[3] = [0,0,0]
   Return $_Return
EndFunc