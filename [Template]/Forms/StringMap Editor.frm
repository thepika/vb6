VERSION 5.00
Begin VB.Form frmEditor 
   Caption         =   "StringMap Editor"
   ClientHeight    =   5535
   ClientLeft      =   60
   ClientTop       =   390
   ClientWidth     =   8310
   LinkTopic       =   "Form1"
   ScaleHeight     =   5535
   ScaleWidth      =   8310
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame fraAddition 
      BorderStyle     =   0  'None
      Height          =   1140
      Left            =   345
      TabIndex        =   5
      Top             =   4260
      Width           =   7830
   End
   Begin VB.TextBox txtValueEx 
      Height          =   1170
      Index           =   0
      Left            =   150
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   4
      Top             =   390
      Width           =   5295
   End
   Begin VB.CommandButton cmdFile 
      Caption         =   "ѡ��"
      Height          =   345
      Index           =   0
      Left            =   6705
      TabIndex        =   3
      Top             =   390
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.CommandButton cmdDir 
      Caption         =   "ѡ��"
      Height          =   345
      Index           =   0
      Left            =   5580
      TabIndex        =   2
      Top             =   390
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.TextBox txtValue 
      Height          =   375
      Index           =   0
      Left            =   165
      TabIndex        =   1
      Top             =   375
      Width           =   5295
   End
   Begin VB.Label lblKey 
      AutoSize        =   -1  'True
      Caption         =   "Key:"
      Height          =   195
      Index           =   0
      Left            =   165
      TabIndex        =   0
      Top             =   165
      Width           =   2115
   End
End
Attribute VB_Name = "frmEditor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mMap As CStringMap
Private mKeys() As String
Private mKeyUBound As Long

Private Sub cmdCancel_Click()
    Unload Me
End Sub

Private Sub cmdOK_Click()
    
    Dim i As Long
    For i = 0 To lblKey.UBound
        mMap.Map(mKeys(i)) = getText(i)
    Next

    Unload Me
End Sub

Private Sub Form_Resize()
    On Error Resume Next
    Dim i As Long
    Dim u As Long
    
    Dim dist As Single
    
    'lblKey(0).Move 60, 60
    cmdFile(0).Move Me.ScaleWidth - 120 - cmdFile(0).Width, txtValue(0).Top
    cmdDir(0).Move cmdFile(0).Left, cmdFile(0).Top
    'txtValue(0).Move lblKey(0).Left, cmdFile(0).Top + cmdFile(0).Height + 120
    If cmdFile(0).Visible = False And cmdDir(0).Visible = False Then
        txtValue(0).Width = Me.ScaleWidth - 2 * txtValue(0).Left
    Else
        txtValue(0).Width = cmdFile(0).Left - 2 * txtValue(0).Left
    End If

    txtValueEx(0).Move txtValue(0).Left, txtValue(0).Top, txtValue(0).Width
    
    
    For i = 1 To lblKey.UBound
        If txtValue(i - 1).Visible Then
            dist = txtValue(i - 1).Top + txtValue(i - 1).Height + 120 - lblKey(i - 1).Top
        Else
            dist = txtValueEx(i - 1).Top + txtValueEx(i - 1).Height + 120 - lblKey(i - 1).Top
        End If
        lblKey(i).Move lblKey(i - 1).Left, lblKey(i - 1).Top + dist
        cmdFile(i).Move cmdFile(i - 1).Left, cmdFile(i - 1).Top + dist
        cmdDir(i).Move cmdDir(i - 1).Left, cmdDir(i - 1).Top + dist
        txtValue(i).Move txtValue(i - 1).Left, txtValue(i - 1).Top + dist
        If cmdFile(i).Visible Or cmdDir(i).Visible Then
            txtValue(i).Width = cmdFile(i).Left - 2 * txtValue(i).Left
        Else
            txtValue(i).Width = Me.ScaleWidth - 2 * txtValue(i).Left
        End If
        txtValueEx(i).Move txtValue(i).Left, txtValue(i).Top, txtValue(i).Width
    Next
    i = lblKey.UBound
    
    Dim txtBox As TextBox
    Set txtBox = GetTextValueControl(i)
    
    
    fraAddition.Top = txtBox.Top + txtBox.Height + 120
    fraAddition.Left = Me.ScaleWidth - 120 - fraAddition.Width
'
'    If txtValue(i).Visible Then
'            cmdCancel.Move Me.ScaleWidth - cmdCancel.Width - 120, txtValue(i).Top + txtValue(i).Height + 120
'        Else
'           cmdCancel.Move Me.ScaleWidth - cmdCancel.Width - 120, txtValueEx(i).Top + txtValueEx(i).Height + 120
'    End If
'
'    cmdOK.Move cmdCancel.Left - cmdOK.Width - 240, cmdCancel.Top
    
    
    
End Sub

Private Function GetTextValueControl(ByVal vIndex As Integer) As TextBox
    If txtValue(vIndex).Visible Then
        Set GetTextValueControl = txtValue(vIndex)
    Else
        Set GetTextValueControl = txtValueEx(vIndex)
    End If
End Function

Public Sub Init(ByVal vMap As CStringMap)
    Set mMap = vMap
    If mMap Is Nothing Then Set mMap = New CStringMap
    mKeys = mMap.Keys
    mKeyUBound = SafeUBound(mKeys())
    
    On Error Resume Next
    Dim i As Long
    For i = 0 To mKeyUBound
        Load lblKey(i)
        lblKey(i).Visible = True
        lblKey(i).Caption = mKeys(i) & ":"
        Load txtValue(i)
        txtValue(i).Visible = True
        txtValue(i).text = mMap.Map(mKeys(i))
        Load txtValueEx(i)
        txtValueEx(i).Visible = False
        txtValueEx(i).text = mMap.Map(mKeys(i))
        Load cmdFile(i)
        cmdFile(i).Visible = False
        Load cmdDir(i)
        cmdDir(i).Visible = False
    Next
    
    
    Form_Resize
End Sub

Public Sub SetField(ByRef vKey As String, ByRef vValue As String)
    Dim i As Long
    i = SearchIndex(vKey)
    If i >= 0 Then setText i, vValue
End Sub

Public Function GetField(ByRef vKey As String) As String
    Dim i As Long
    i = SearchIndex(vKey)
    GetField = getText(i)
End Function

Private Function getText(ByVal index As Long) As String
On Error GoTo ErrorGetText
    If index > mKeyUBound Then Exit Function
    If index < 0 Then Exit Function
    If txtValue(index).Visible Then
        getText = txtValue(index).text
    Else
        getText = txtValueEx(index).text
    End If
    Exit Function
ErrorGetText:
End Function

Private Sub setText(ByVal index As Long, ByRef vValue As String)
        '<EhHeader>
        On Error GoTo setText_Err
        '</EhHeader>
100     If index > mKeyUBound Then Exit Sub
102     If txtValue(index).Visible Then
104         txtValue(index).text = vValue
        Else
106         txtValueEx(index).text = vValue
        End If
        '<EhFooter>
        Exit Sub

setText_Err:
'        MsgBox Err.Description & vbCrLf & _
'               "in GetSSLib.frmMapEditor.setText " & _
'               "at line " & Erl, _
'               vbExclamation + vbOKOnly, "Application Error"
'        Resume Next
        '</EhFooter>
End Sub

Private Function SearchIndex(ByRef vKey As String) As Long
    Dim i As Long
    For i = 0 To mKeyUBound
        If mKeys(i) = vKey Then SearchIndex = i: Exit Function
    Next
    SearchIndex = -1
End Function

Public Sub SetMultiLine(ByRef vKey As String)
    Dim i As Long
    i = SearchIndex(vKey)
    If i >= 0 Then
        txtValueEx(i).Visible = True
        txtValue(i).Visible = False
        Form_Resize
    End If
End Sub

Public Sub SetDirectory(ByRef vKey As String)
    Dim i As Long
    i = SearchIndex(vKey)
    If i >= 0 Then
        cmdFile(i).Visible = False
        cmdDir(i).Visible = True
        Form_Resize
    End If
End Sub

Public Sub SetFile(ByRef vKey As String)
    Dim i As Long
    i = SearchIndex(vKey)
    If i >= 0 Then
        cmdFile(i).Visible = True
        cmdDir(i).Visible = False
        Form_Resize
    End If
End Sub
Private Function SafeUBound(ByRef mArray() As String) As Long
    On Error GoTo ErrorSafeUbound
    SafeUBound = UBound(mArray())
    Exit Function
    
ErrorSafeUbound:
    SafeUBound = -1
End Function
