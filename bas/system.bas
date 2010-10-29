Attribute VB_Name = "modSystem"


Public Type POINTAPI
    x As Long
    y As Long
End Type
Public Const WM_HOTKEY = &H312
Public Const MOD_ALT = &H1
Public Const MOD_CONTROL = &H2
Public Const MOD_SHIFT = &H4
Public Const GWL_WNDPROC = (-4)
Public preWinProc As Long
Public Modifiers As Long, uVirtKey As Long, idHotKey As Long
Public Type taLong
     ll As Long
End Type
Public Type t2Int
     lWord As Integer
     hword As Integer
End Type

Public Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Public Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Public Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
Public Declare Function TrackPopupMenu Lib "user32" (ByVal hMenu As Long, ByVal wFlags As Long, ByVal x As Long, ByVal y As Long, ByVal nReserved As Long, ByVal hwnd As Long, lprc As Any) As Long
Public Declare Function GetMenu Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function GetSubMenu Lib "user32" (ByVal hMenu As Long, ByVal nPos As Long) As Long
Public Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Public Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Declare Function RegisterHotKey Lib "user32" (ByVal hwnd As Long, ByVal id As Long, ByVal fsModifiers As Long, ByVal vk As Long) As Long
Public Declare Function UnregisterHotKey Lib "user32" (ByVal hwnd As Long, ByVal id As Long) As Long


 Public Function wndproc(ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
 
     If Msg = WM_HOTKEY And wParam = idHotKey Then
        Dim lp As taLong, i2 As t2Int
        lp.ll = lParam
        LSet i2 = lp
        If (i2.lWord = Modifiers) And i2.hword = uVirtKey Then
             Debug.Print "HotKey Shift－Alt－G Pressed"
             trayform.MenuMain_Click
        End If
    Else
     '如果不是热键信息则调用原来的程序
     wndproc = CallWindowProc(preWinProc, hwnd, Msg, wParam, lParam)
    End If
End Function

