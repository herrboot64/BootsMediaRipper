Option Explicit

Dim shell, fso, scriptDir, ps1, cmd
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
ps1 = scriptDir & "\.assets\BootsMediaRipperServer.ps1"

If Not fso.FileExists(ps1) Then
    MsgBox "BootsMediaRipperServer.ps1 was not found:" & vbCrLf & vbCrLf & ps1, vbCritical, "Boot's Media Ripper Server"
    WScript.Quit 1
End If

cmd = "powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -WindowStyle Hidden -File " & Chr(34) & ps1 & Chr(34)

' 0 = hidden window, False = do not wait
shell.Run cmd, 0, False
