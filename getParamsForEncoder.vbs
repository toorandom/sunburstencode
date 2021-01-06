' This simple script will retrieve the information needed to reproduce the Sunburst GUID
' in the same way, case, symbols, etc... as the malware does.
' With this in combination with the sunburstencode.sh below, you check which machines
' from your environment were compromised.
' The parameters returned by this script need to be passed to
' https://github.com/toorandom/sunburstencode/blob/main/sunburstencode.sh
' This VBS script is based on: https://www.tek-tips.com/viewthread.cfm?qid=793490
' Run this script in the machine that might be compromised to get the info for sunburstencode.sh
' C:\> wscript this.vbs
' Eduardo Ruiz Duarte
' toorandom@gmail.com



Dim strComputer, CRLF
Dim colDrives, strMsg
Dim WSHNetwork
Dim oShell
Dim iValue

Set oShell = CreateObject("WScript.Shell")

iValue = oShell.RegRead("HKLM\SOFTWARE\Microsoft\Cryptography\MachineGuid")

Set fso = CreateObject ("Scripting.FileSystemObject")
Set stdout = fso.GetStandardStream (1)

strComputer = "."
CRLF = Chr(13) & Chr(10)
Set NetworkPROP = WScript.CreateObject("WScript.Network")
Set objWMIService = GetObject _
("winmgmts:" & "!\\" & strComputer & "\root\cimv2")
Set colAdapters = objWMIService.ExecQuery _
("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled=True")

For Each objAdapter in colAdapters
   If objAdapter.IPAddress(0)<>"" then
         MsgBox "Domain: "      &  NetworkPROP.UserDomain & CRLF & _
         "MAC: " & objAdapter.MACAddress & CRLF & _
         "MachineGuid: " & iValue & CRLF & _
         "Encoder: "  & "https://github.com/toorandom/sunburstencode/blob/main/sunburstencode.sh", _
         vbinformation + vbOKOnly + vbmsgboxsetforeground, _
         "Params for sunburstEncoder from " + ucase(objAdapter.DNSHostName)
   end if
Next
