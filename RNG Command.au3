;Meta Data
;Application: RNG Command
;Date: 8/23/2024
;Creator: mranaglyph

;Included libraries for pre-built function calls
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <Misc.au3>

;Calls HotKeyClose Function to end application w/sound if possible
HotKeySet("{F9}", "HotKeyClose")

;Config file to pull data from
Local Const $cName    = "config.txt" ;(cName : Configuration (File) Name)

;Function definition to read data from config file and extract data (no globals to prevent memory leaks)
Func ReadCommands()
   ;Open config.txt file and create array
   Local $cFile 	  = FileOpen($cName)        ;(cFile : Configuration File (Open))
   Local $cData       = FileReadToArray($cFile) ;(cData : Configuration Data)

   ;Array of commands to choose from
   Local $commandArr  = FileReadToArray($cData[1]) ;(commandArr : Command (List) Array)

   ;Message window sizes
   Local $mWidth  	  = $cData[4]  ;(mWidth  : Messagebox Width)
   Local $mHeight 	  = $cData[7]  ;(mHeight : Messagebox Height)
   Local $mBuffW  	  = $cData[10] ;(mBuffW  : Messagebox Buffer Width (X Pos on Display))
   Local $mBuffH  	  = $cData[13] ;(mBuffH  : Messagebox Buffer Height (Y Pos on Display))

   ;Sleep timer variables
   Local $slpBetween  = $cData[16] * 1000 ;(slpBetween : Sleep Between (Commands))
   Local $slpRead	  = $cData[19] * 1000 ;(slpRead : Sleep Time to Read (Commands))

   ;Sound effect to be used/check if it exists, set to no sound if it does not exist
   Local $sfx		  = $cData[22] ;(sfx : Sound Effect Used)
   If Not FileExists($sfx) Then
	  $sfx 			  = ""
   EndIf

   ;Close file to save memory
   FileClose($cData)

   ;Create 2D (nested) array, then return multi-dimensional array for data distribution out of function scope
   Local $dExtracted[8] = [$commandArr, $mWidth, $mHeight, $mBuffW, $mBuffH, $slpBetween, $slpRead, $sfx]
   Return $dExtracted ;(dExtracted : Data Extracted)
EndFunc

;Function call to read the config.txt file and distribute data
Local $dData = ReadCommands() ;(dData : Distributing Data)

;End application function definition
Func HotKeyClose()
   SoundPlay("")
   SoundPlay($dData[7])
   SplashTextOn("RNG Command", "RNG Command Closing...", $dData[1], $dData[2], $dData[3], $dData[4])
   Sleep(1000)
   SplashOff()

   If WinExists("RNG Command") Then
	  WinKill("RNG Command")
   EndIf
   Exit
EndFunc

;Main Application Function Definition
Func Main()
   ;Timer between commands
   Sleep($dData[5])

   ;Select command from command array
   Local $rng = Random(0, UBound($dData[0]) - 1, 1) ;(rng : Random Number Generation (Array Index))

   ;Display chosen command to screen and play sound effect
   SoundPlay("")
   SoundPlay($dData[7])
   SplashTextOn("RNG Command [F9 to Close App]",($dData[0])[$rng], $dData[1], $dData[2], $dData[3], $dData[4])

   ;Allow user to read command message, then close message
   Sleep($dData[6])
   SplashOff()
EndFunc

;Enter Main Application Loop (Main() Call)
While True
   Main()
WEnd