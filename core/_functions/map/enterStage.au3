#cs ----------------------------------------------------------------------------

 Function: enterStage

 Algorithm for entering a stage in the maps.

 Parameters:

	strImage - Image name of the map.

	strMode - Modes include: normal, hard, extreme

	boolAuto - Boolean for autobattle mode.

 Returns:

	On success - Returns 1

	On fail - Returns 0

#ce ----------------------------------------------------------------------------

Func enterStage($strImage, $strMode = "normal", $boolAuto = False, $boolLog = True)
	If waitLocation("map") = 1 Then
		Local $errorCounter = 0
		While findImageWait($strImage, 2, 100) = False
			If _Sleep(500) Then Return

			If checkLocations("astroleague", "map-stage", "association") = 1 Then ControlSend($hWindow, "", "", "{ESC}")

			If $errorCounter > 20 Then
				Return 0
			EndIf

			ControlSend($hWindow, "", "", "{LEFT}")
			$errorCounter+=1
		WEnd

		;clicking map list and selecting difficulty
		clickImage($strImage, 100)
		Switch $strMode
			Case "normal" ;Normal
				If $boolLog Then setLog("Entering " & StringReplace(_StringProper(StringReplace($strImage, "-", " ")), "Map ", "") & " on Normal.", 1)
				clickPoint($map_coorMode)
				clickPoint($map_coorNormal)
			Case "hard" ;Hard
				If $boolLog Then setLog("Entering " & StringReplace(_StringProper(StringReplace($strImage, "-", " ")), "Map ", "") & " on Hard.", 1)
				clickPoint($map_coorMode)
				clickPoint($map_coorHard)
			Case "extreme" ;Extreme
				If $boolLog Then setLog("Entering " & StringReplace(_StringProper(StringReplace($strImage, "-", " ")), "Map ", "") & " on Extreme.", 1)
				clickPoint($map_coorMode)
				clickPoint($map_coorExtreme)
			Case Else
				If $boolLog Then setLog("Input error: " & $strMode & " not within 1-3 modes.", 1)
				Return 0
		EndSwitch

		;selecting a stage (not yet complete)
		clickPoint(findImageWait("misc-stage-energy", 5, 100))

		;applying autobattle mode
		If $boolAuto = True Then
			clickPointWait($map_pixelAutoBattle20xUnchecked, "map-battle", 5)
			clickPoint($map_coorConfirmAutoBattle)
		EndIf

		;launching stage
		clickPoint($map_coorBattle, 3, 1000)

		If checkLocations("map-gem-full", "battle-gem-full") = 1 Then Return 0

		Return waitLocation("battle", 10)
	Else
		Return 0
	EndIf
EndFunc