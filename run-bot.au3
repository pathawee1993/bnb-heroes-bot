;~ Opt("MustDeclareVars", 1)
;~ #AutoIt3Wrapper_UseX64=y
;~ #AutoIt3Wrapper_Change2CUI=y
#RequireAdmin

#include "_ImageSearch_UDF.au3"
#include <MsgBoxConstants.au3>

HotKeySet("{Esc}", "_Exit") ; Press ESC for exit
Func _Exit()
    Exit 0
EndFunc   ;==>_Exit

Global $state = 0
Global $timeForWaitingConfrim = 600;
Global $state5cout = 0;

While 1
   ;~ state 0, searching my heroes
   if $state = 0 Then
	  Local $return = search("\myHeroes",1)
	  If $return[0] = 1 Then
		 MouseClick("left", $return[1], $return[2])
		 $state = 1
	  EndIf
   EndIf

   ;~ state 1, searching hero which can fight
   if $state = 1 Then
	  Sleep(2000)
	  Local $return = search("\heroCanFight",4)
	  Local $return2 = search("\unlock",4)
	  If $return[0] = 1 Then
		 MouseClick("left", $return[1], $return[2])
		 $state = 2
	  ElseIf $return2[0] = 1 Then
		 MouseClick("left", $return2[1], $return2[2])
		 $state = 2
	  Else
		 MouseClick("left", 50, 150)
			$state = 0
	  EndIf
   EndIf

   if $state = 2 Then
	  Local $return = search("\goToMage",2)
	  If $return[0] = 1 Then
		 MouseClick("left", $return[1], $return[2])
		 $state = 3
	  EndIf
   EndIf

   if $state = 3 Then
	  Local $return = search("\fightMage",3)
	  If $return[0] = 1 Then
		 MouseClick("left", $return[1], $return[2])
		 $state = 4
	  EndIf
   EndIf

   if $state = 4 Then
	  Sleep(2000)
	  Local $return = search("\checkGasOk",6)
	  If $return[0] = 1 Then
		 MouseMove($return[1], $return[2])
		 Local $return = search("$confirm",1)
		 If $return[0] = 1 Then
			MouseClick("left", $return[1], $return[2])
			$state = 5
			$state5cout = 0
		 EndIf
	  Else
		 Local $return = search("\reject",2)
		 If $return[0] = 1 Then
			MouseClick("left", $return[1], $return[2])
			$state = 6
		 EndIf
	  EndIf
   EndIf

   ; confirmed
   if $state = 5 Then
	  $state5cout = $state5cout + 1
	  Local $return = search("\closeResult",1)
	  Local $return2 = search("\confirmedTransaction",1)
	  If $return[0] = 1 Then
		 MouseClick("left", $return[1], $return[2])
		 $state = 6
	  ElseIf $return2[0] = 1 Then
		 $state = 6
   	  ElseIf $state5cout = $timeForWaitingConfrim Then
		 $state = 6
	  EndIf
   EndIf

   ; back to home
   if $state = 6 Then
	  MouseClick("left", 50, 150)
	  Sleep(200)
	  MouseClick("left", 50, 150)
	  $state = 0
   EndIf

   Sleep(1000)
WEnd

Func search($image, $cout)
   For $i = 1 To $cout
	  Local $return = _ImageSearch(@ScriptDir &$image&$image&$i&".bmp")
	  If $return[0] = 1 Then
		 Return $return
	  EndIf
   Next
   Local $_Return[3] = [0,0,0]
   Return $_Return
EndFunc