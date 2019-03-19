; Write your own AHK commands in this file to be recognized by the GUI. Take inspiration from the samples provided here.


;-------------------------------------------------------------------------------
;;; COMMANDS SECTION ;;;
;-------------------------------------------------------------------------------

; Fake command included here for copying - highlight everything from "else if..." up to the closing "}"
; Feel free to use multiple words in your command, but the end of the line must have a comment afterward describing what it does
; "gui_destroy()" must be included in the nested if
; for programs or scripts, use the run command followed by the path to the file
; you can also include any other AHK code to be launched when the command is chosen in the GUI

/*

You can copy from "else if" all the way to the end "}" to use later. Make sure to remove the semicolon before "else if"

-----------copy from here-----------------
;else if Command = Put name of your command or program here ; A commented description must be here so the command will be parsed correctly.
{
    gui_destroy()

    run C:\Users\%A_Username%\Downloads
}
-----------copy to here-----------------

*/

;-------------------------------------------------------------------------------
;;; Initial command option - included so that all other commands can start with "else if" ;;;
;-------------------------------------------------------------------------------

if Command = zDo not choose this option ; Leave this first block of code here so you don't accidently make the first command in sequence an "else if"
{
    gui_destroy()
    MsgBox, Why would you choose this option??? I told you not to!
}

;-------------------------------------------------------------------------------
;;; Launch Directories ;;;
;-------------------------------------------------------------------------------

else if Command = Downloads Folder ; Downloads
{
    gui_destroy()
    run C:\Users\%A_Username%\Downloads
}
else if Command = Dropbox Folder ; Dropbox folder (works when it is in the default directory)
{
    gui_destroy()
    run, C:\Users\%A_Username%\Dropbox
}


;-------------------------------------------------------------------------------
;;; Launch GUI Script Related items;;;
;-------------------------------------------------------------------------------

else if Command = Reload ; Reload this script
{
    gui_destroy() ; removes the GUI even when the reload fails
    Reload
}
else if Command =  GUI Script Directory ; Open the directory for this script
{
    gui_destroy()
    Run, %A_ScriptDir%
}
else if Command = User Commands ; Edit GUI user commands
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Apps\SciTE4AutoHotkey\SciTE.exe" "%A_ScriptDir%\GUI\UserCommands.ahk"
}
else if Command = Paste Unformatted Text ; Paste clipboard content without formatting
{
    gui_destroy()
    SendRaw, %ClipBoard%
}
else if Command = Get the Date ; What is the date?
{
    gui_destroy()
    FormatTime, date,, LongDate
    MsgBox %date%
    date =
}
else if Command = Get Week Number ; Which week is it?
{
    gui_destroy()
    FormatTime, weeknumber,, YWeek
    StringTrimLeft, weeknumbertrimmed, weeknumber, 4
    if (weeknumbertrimmed = 53)
        weeknumbertrimmed := 1
    MsgBox It is currently week %weeknumbertrimmed%
    weeknumber =
    weeknumbertrimmed =
}
else if Command = ? ; Tooltip with list of commands
{
    GuiControl,, Command, ; Clear the input box
    Gosub, gui_commandlibrary
}


;-------------------------------------------------------------------------------
;;; Launch Programs and Big Scripts;;;
;-------------------------------------------------------------------------------

else if Command = Notepad ; Notepad
{
    gui_destroy()
    Run Notepad
}

else if Command = Paint ; MS Paint
{
    gui_destroy()
    run "C:\Windows\system32\mspaint.exe"
}

else if Command = Screen Clip with OCR ; Open Screenclip with OCR
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Apps\Screen Clipping with OCR\Screen Clipping w options 5.ahk"
}

else if Command = AutoGUI ; Open AutoGUI
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Apps\AutoGUI\AutoGUI.ahk"
}

else if Command = Belvedere For Desktop ; Open Belvedere for work desktop
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Apps\belvedere-desktop\belvedere.ahk"
}

else if Command = Belvedere For Laptop ; Open Belvedere for laptop
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Apps\belvedere-laptop\belvedere.ahk"
}

else if Command = Clipjump ; Open Clipjump
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Apps\Clipjump\Clipjump.exe"
}

else if Command = Lintalist ; Open Lintalist
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Apps\lintalist\lintalist.ahk"
}


;-------------------------------------------------------------------------------
;;; Launch Scripts ;;;
;-------------------------------------------------------------------------------


else if Command = Close all AHK Scripts ; Close all open AHK scripts
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Small Scripts\Close all open scripts.ahk"
}

else if Command = Compass Script ; Open angle measurement
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Small Scripts\Compass.ahk"
}

else if Command = Grade Autoentry ; Grade AutoEntry
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Small Scripts\Enter Grades.ahk"
}

else if Command = Search Internet ; Open Google Search GUI
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Small Scripts\Google Search.ahk"
}

else if Command = Multi Tabber ; Open Multi-tab script
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Small Scripts\Multi-tabber for quick grading.ahk"
}

else if Command = Task Entry ; Send New Task to TODOList
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Small Scripts\Send New Task to Inbox.ahk"
}

else if Command = Text Reformatter ; Open text reformatter
{
    gui_destroy()
    run, "%A_ScriptDir%\..\Small Scripts\Text Reformatting.ahk"
}


;-------------------------------------------------------------------------------
;;; Launch Websites & Web Apps ;;;
;-------------------------------------------------------------------------------

else if Command = Google Calendar ; Google Calendar
{
    gui_destroy()
    run https://www.google.com/calendar
}

else if Command = Google Maps ; Google Maps focused on the Technical University of Denmark, DTU
{
    gui_destroy()
    run "https://www.google.com/maps/"
}

else if Command = Gmail ; Open Gmail
{
    gui_destroy()
    run https://mail.google.com/mail/u/0/#inbox
}

else if Command = Launch URL From Clipboard ; Open an URL from the clipboard (naive - will try to run whatever is in the clipboard)
{
    gui_destroy()
    run %ClipBoard%
}

else if Command = Paperpile ; Paperpile App
{
    gui_destroy()
    Run https://paperpile.com/app
}

else if Command = Compose Email ; Open Gmail Compose Window without inbox
{
    gui_destroy()
    Run https://mail.google.com/mail/?view=cm&fs=1&tf=1
}

;-------------------------------------------------------------------------------
;;; Launch Windows Utilities ;;;
;-------------------------------------------------------------------------------

else if Command = Command Prompt ; Open Command Prompt
{
    gui_destroy()
    Run cmd
}
else if Command = Recycle Bin ; Open Recycle Bin
{
    gui_destroy()
    Run ::{645FF040-5081-101B-9F08-00AA002F954E}
}
else if Command = Ping Google ; Ping Google using command prompt
{
    gui_destroy()
    Run, cmd /K "ping www.google.com"
}
else if Command = Hosts File ; Open hosts file in Notepad
{
    gui_destroy()
    Run notepad.exe C:\Windows\System32\drivers\etc\hosts
}

