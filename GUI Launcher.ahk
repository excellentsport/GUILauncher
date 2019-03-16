#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance Force



; TODO: Get the code to generate tooltip list up and running
; TODO: set up hotkeys that will allow for up and down movement of listview selection, without losing focus on search box

; TODO: possible: set up a scan of folders that contain scripts in the top level of folders
; TODO: possible: up a more standard format for the commands for this script. Could I set up well-formatted reference files? A reference file for programs, one for websites, etc?


;-------------------------------------------------------
; AUTO EXECUTE SECTION FOR INCLUDED SCRIPTS
; Scripts being included need to have their auto execute
; section in a function or subroutine which is then
; executed below.
;-------------------------------------------------------

SetCapsLockState, AlwaysOff
Gosub, gui_autoexecute
Gosub, buildcommandlist
return


#include %A_ScriptDir%\lib\Miscellaneous.ahk ;Contains miscellaneous options for the program
#include %A_ScriptDir%\lib\Sift.ahk ;Fuzzy search algorithm



;-------------------------------------------------------------------------------
; LAUNCH GUI
;-------------------------------------------------------------------------------
CapsLock & Space::
gui_spawn:

    if gui_state != closed
    {
        ; If the GUI is already open, close it.
        gui_destroy()
        return
    }
    gui_state = main

    Gui, Margin, 16, 16
    Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption +Border
    Gui, Font, s11, Segoe UI
    Gui, Add, Text, %gui_control_options%, Enter Command
    Gui, Font, s10, Segoe UI
    Gui, Add, Edit,  %gui_control_options% vCommandSearchString gSearchCommandList
    Gui, Add, Listview, -Hdr -Multi Sort, CommandOptions
    Loop, Parse, CommandList,|
        LV_Add("",A_LoopField)
    LV_ModifyCol()
    Gui, Show,, myGUI
    return

;-------------------------------------------------------------------------------
; Interacting with GUI
;-------------------------------------------------------------------------------

#IfWinActive myGUI
enter::
    FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	LV_GetText(Command,FocusedRowNumber)
    Gui, Submit, NoHide
    #include %A_ScriptDir%\lib\UserCommands.ahk
    Return


;-------------------------------------------------------------------------------
; GUI FUNCTIONS AND SUBROUTINES
;-------------------------------------------------------------------------------

#WinActivateForce

gui_autoexecute:
    gui_control_options := "xm w300" . cForeground
    gui_state = closed ; Initialize variable to keep track of the state of the GUI

GuiEscape: ;Close GUI when hitting escape
    gui_destroy()
    return


gui_destroy() {
    global gui_state
    gui_state = closed
    Gui, Destroy    ; Hide GUI
    WinActivate     ; Bring focus back to another window found on the desktop
}

SearchCommandList:
	GuiControlGet,commandsearch,,CommandSearchString, Value
	newlist := Sift_Regex(commandlist, commandsearch, "oc","|")
    LV_Delete()
    Loop, Parse, newlist,|
        LV_Add("",A_LoopField)
    LV_ModifyCol()
    LV_Modify(1,"+Select +Focus")
	return


;-------------------------------------------------------------------------------
; Create list of programs and commands for use in the GUI
;-------------------------------------------------------------------------------

buildcommandlist:
    global CommandList
    global FullCommandList
    CommandList =

    Loop, read, %A_ScriptDir%/lib/UserCommands.ahk
    {
        ; search for the string 'If Command =', but search for each part sequentially
        If Substr(A_LoopReadLine, 1, 1) != ";" ; Do not display commented commands
        {
            RegexMatch(A_LoopReadLine, "i)if +command *\=", foundmatch)
            If foundmatch !=
                {
                    StringGetPos, equalpos, A_LoopReadLine,`=
                    RegExMatch(A_LoopReadLine, "\b[A-Za-z0-9]+[A-Za-z0-9 ]*\b[A-Za-z0-9]*", foundcommand, StartingPosition := equalpos) 
                    CommandList .= foundcommand
                    CommandList .= ","
                }

        }

    }
    StringTrimRight CommandList, CommandList, 1 ;remove the extra comma at the end
    Sort CommandList, D,
    StringReplace, CommandList, CommandList, `,,`|, All
    fullCommandList := CommandList
    return

;-------------------------------------------------------------------------------
; TOOLTIP
; The tooltip shows all defined commands, along with a description of what
; each command does. It gets the description from the comments in UserCommands.ahk.
;-------------------------------------------------------------------------------

gui_tooltip_clear:
    ToolTip
    return

gui_commandlibrary:
    ; hidden GUI used to pass font options to tooltip:
    CoordMode, Tooltip, Screen ; To make sure the tooltip coordinates is displayed according to the screen and not active window
    Gui, 2:Font,s10, Lucida Console
    Gui, 2:Add, Text, HwndhwndStatic

    tooltiptext =
    maxpadding = 0
    StringCaseSense, Off ; Matching to both if/If in the IfInString command below
    Loop, read, %A_ScriptDir%/lib/UserCommands.ahk
    {
        ; search for the string If Command =, but search for each word individually because spacing between words might not be consistent. (might be improved with regex)
        If Substr(A_LoopReadLine, 1, 1) != ";" ; Do not display commented commands
        {
            If A_LoopReadLine contains if
            {
                IfInString, A_LoopReadLine, Command
                    IfInString, A_LoopReadLine, =
                    {
                        StringGetPos, setpos, A_LoopReadLine,=
                        StringTrimLeft, trimmed, A_LoopReadLine, setpos+1 ; trim everything that comes before the = sign
                        StringReplace, trimmed, trimmed, `%A_Space`%,{space}, All
                        tooltiptext .= trimmed
                        tooltiptext .= "`n"

                        ; The following is used to correct padding:
                        StringGetPos, commentpos, trimmed,`;
                        if (maxpadding < commentpos)
                            maxpadding := commentpos
                    }
            }
        }
    }
    tooltiptextpadded =
    Loop, Parse, tooltiptext,`n
    {
        line = %A_LoopField%
        StringGetPos, commentpos, line, `;
        spaces_to_insert := maxpadding - commentpos
        Loop, %spaces_to_insert%
        {
            StringReplace, line, line,`;,%A_Space%`;
        }
        tooltiptextpadded .= line
        tooltiptextpadded .= "`n"
    }
    Sort, tooltiptextpadded
    ToolTip %tooltiptextpadded%, 3, 3, 1
    return