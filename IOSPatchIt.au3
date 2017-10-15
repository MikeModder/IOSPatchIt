;It's a windows app to patch IOS 31 and 80 for RiiConnect24
;IOSPatchIt Beta - (C) 2017 MikeModder

#include <Misc.au3>
#include <AutoItConstants.au3>

;This is the first thing I've made in AutoIt, so it probably isn't that good.
;Huge thanks to JoshuaDoes for telling me about this neat language.

#Region ;Stuff about the compiled exe
#AutoIt3Wrapper_Version=Beta
;#AutoIt3Wrapper_Icon=
#AutoIt3Wrapper_Outfile=bin/IOSPatchIt.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=A patcher made to allow users to generate the patched wads to use with RiiConnect24.
#AutoIt3Wrapper_Res_Description=IOS Patcher for RiiConnect24
#AutoIt3Wrapper_Res_Fileversion=2
#AutoIt3Wrapper_Change2CUI=y
#EndRegion

#NoTrayIcon

Global $prgInfo[]
Global $overwriteFiles = 1
Global $hDLL = DllOpen("user32.dll")

;Program information
$prgInfo["updateURL"] = "http://mikemodder.me/ipi/latest.ini"
$prgInfo["tempConfPath"] = @TempDir&"\IOSPatchIt\updates.ini"
$prgInfo["tempConfFile"] = "updates.ini"

;Clean current directory of old app and wad files.
ConsoleWrite("Cleaning current directory of old WAD files (should they exist)..."&@CRLF)
FileDelete(@ScriptDir&"\*.wad")

ConsoleWrite("Cleaning current directory of old APP files (should they exist)..."&@CRLF)
FileDelete(@ScriptDir&"\*.app")

;Clean the IOS80 and IOS31 folders
ConsoleWrite("Cleaning IOS80/31 extracted directories (should they exist)..."&@CRLF)
FileDelete(@ScriptDir&"\IOS31\*")
FileDelete(@ScriptDir&"\IOS80\*")

;Extract the files we need to patch stuff
ConsoleWrite("Extracting required files..."&@CRLF)

If Not FileInstall(".\inc\Sharpii.exe", ".\Sharpii.exe", $overwriteFiles) Then
	ConsoleWrite("Error: Cannot extract Sharpii!")
	waitForEnter()
	Exit
EndIf

If Not FileInstall(".\inc\xdelta3.exe", ".\xdelta3.exe", $overwriteFiles) Then
	ConsoleWrite("Error: Cannot extract xdelta3!")
	waitForEnter()
	Exit
EndIf

If Not FileInstall(".\inc\libWiiSharp.dll", ".\libWiiSharp.dll", $overwriteFiles) Then
	ConsoleWrite("Error: Cannot extract libWiiSharp!")
	waitForEnter()
	Exit
EndIf

If Not FileInstall(".\inc\WadInstaller.dll", ".\WadInstaller.dll", $overwriteFiles) Then
	ConsoleWrite("Error: Cannot extract WadInstaller!")
	waitForEnter()
	Exit
EndIf

If Not FileInstall(".\inc\00000006-80.delta", ".\00000006-80.delta", $overwriteFiles) Then
	ConsoleWrite("Error: Cannot extract IOS80 delta!")
	waitForEnter()
	Exit
EndIf

If Not FileInstall(".\inc\00000006-31.delta", ".\00000006-31.delta", $overwriteFiles) Then
	ConsoleWrite("Error: Cannot extract IOS31 delta!")
	waitForEnter()
	Exit
EndIf

;Files are now extracted and ready for use!
;Show the user a message, and give KcrPL some thanks.
 ConsoleWrite("The creator of this program (MikeModder) is not affiliated with RiiConnect24,"&@CRLF)
 ConsoleWrite("nor are they responsible for any damage that may occur after using this tool."&@CRLF)
 ConsoleWrite(@CRLF)
 ConsoleWrite("Thanks to KcrPL for the batch version of IOS Patcher. Without some bits from"&@CRLF)
 ConsoleWrite("his batch script, IOSPatchIt may not have existed!"&@CRLF&@CRLF)

ConsoleWrite("Press enter to cotinue...")
 waitForEnter()

;Download IOS31 wad
ConsoleWrite("Downloading IOS31...   ")
ShellExecuteWait(".\Sharpii.exe", "NUSD -ios 31 -v latest -o IOS31-noPatch.wad -wad", "", $SHEX_OPEN, @SW_HIDE)

;Make sure the wad downloaded without error.
If Not @error == 0 Then
	ConsoleWrite("Error downloading IOS31! Error code: "&@error)
	waitForEnter()
	Exit
EndIf

ConsoleWrite("Done!"&@CRLF)

;Download IOS80 wad
ConsoleWrite("Downloading IOS80...   ")
ShellExecuteWait(".\Sharpii.exe", "NUSD -ios 80 -v latest -o IOS80-noPatch.wad -wad", "", $SHEX_OPEN, @SW_HIDE)

;Make sure IOS80 downloaded fine too
If Not @error == 0 Then
	ConsoleWrite("Error downloading IOS80! Error code: "&@error)
	waitForEnter()
	Exit
EndIf

ConsoleWrite("Done!"&@CRLF)

;Time to extract the contents of the IOSes
ConsoleWrite("Now we need to extract the contents so we can patch it!"&@CRLF)

;Extract IOS31 to IOS31/
ConsoleWrite("Extracting IOS31...   ")
ShellExecuteWait(".\Sharpii.exe", "WAD -u IOS31-noPatch.wad IOS31/", "", $SHEX_OPEN, @SW_HIDE)

If Not @error == 0 Then
	ConsoleWrite("Error extracting IOS31! Error code: "&@error)
	waitForEnter()
	Exit
EndIf

ConsoleWrite("Done!"&@CRLF)

;Extract IOS80 to IOS80/
ConsoleWrite("Extracting IOS80...   ")
ShellExecuteWait(".\Sharpii.exe", "WAD -u IOS80-noPatch.wad IOS80/", "", $SHEX_OPEN, @SW_HIDE)

If Not @error == 0 Then
	ConsoleWrite("Error extracting IOS80! Error code: "&@error)
	waitForEnter()
	Exit
EndIf

ConsoleWrite("Done!"&@CRLF)

;Move the .app file to the script dir, so we can have the output give us the correct file.
FileMove(@ScriptDir&"\IOS31\00000006.app", @ScriptDir&"\00000006.app")
;Make sure it was moved
If Not FileExists(@ScriptDir&"\00000006.app") Then
	ConsoleWrite("Failed to move 00000006.app!"&@CRLF)
	waitForEnter()
	Exit
EndIf

;Patch the .app file of IOS31
ConsoleWrite("Patching IOS31...   ")
ShellExecuteWait(".\Sharpii.exe", "-f -d -s 00000006.app 00000006-31.delta IOS31\00000006.app", "", $SHEX_OPEN, @SW_HIDE)

If Not @error == 0 Then
	ConsoleWrite("Error patching IOS31! Error code: "&@error)
	waitForEnter()
	Exit
EndIf

ConsoleWrite("Done!"&@CRLF)

FileDelete(@ScriptDir&"\00000006.app")

;Patch the .app file of IOS80
ConsoleWrite("Patching IOS80...   ")
ShellExecuteWait(".\Sharpii.exe", "-f -d -s 00000006.app 00000006-80.delta IOS80\00000006.app", "", $SHEX_OPEN, @SW_HIDE)

If Not @error == 0 Then
	ConsoleWrite("Error patching IOS80! Error code: "&@error)
	waitForEnter()
	Exit
EndIf

ConsoleWrite("Done!"&@CRLF)

;Make a WAD directory for the patched wads
If Not FileExists(@ScriptDir&"\WAD\") Then
	DirCreate(@ScriptDir&"\WAD\")
EndIf

;Rebuild IOS31
ConsoleWrite("Rebuilding IOS31...   ")
ShellExecuteWait(".\Sharpii.exe", "WAD -p IOS31\ WAD\IOS31.wad -fs", "", $SHEX_OPEN, @SW_HIDE)

If Not @error == 0 Then
	ConsoleWrite("Error rebuilding IOS31! Error code: "&@error)
	waitForEnter()
	Exit
EndIf

ConsoleWrite("Done!"&@CRLF)

;Rebuild IOS80
ConsoleWrite("Rebuilding IOS80...   ")
ShellExecuteWait(".\Sharpii.exe", "WAD -p IOS80\ WAD\IOS80.wad -fs", "", $SHEX_OPEN, @SW_HIDE)

If Not @error == 0 Then
	ConsoleWrite("Error rebuilding IOS80! Error code: "&@error)
	waitForEnter()
	Exit
EndIf

ConsoleWrite("Done!"&@CRLF)

ConsoleWrite("Looks like we're done with downloading and patching. Cleaning up the directory..."&@CRLF)
FileDelete(@ScriptDir&"\*.wad")
FileDelete(@ScriptDir&"\*.dll")
FileDelete(@ScriptDir&"\*.delta")
FileDelete(@ScriptDir&"\Sharpii.exe")
FileDelete(@ScriptDir&"\xdelta3.exe")

ConsoleWrite("The patched WAD files can be found the WAD directory.")

ConsoleWrite("Program finished. Thanks for using it!"&@CRLF)
waitForEnter()

Func waitForEnter()
	While Not _IsPressed("0D", $hDLL)
		Sleep(100)
	WEnd
EndFunc