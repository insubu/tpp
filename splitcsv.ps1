Start-Process "shell:Downloads"
Start-Process "shell:Personal"   # "Personal" = My Documents

Start-Process explorer.exe "C:\Path\To\Folder"
Start-Sleep -Seconds 1

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
    [DllImport("user32.dll")]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
}
"@

$hwnd = [WinAPI]::FindWindow("CabinetWClass", $null)
[WinAPI]::MoveWindow($hwnd, 100, 100, 800, 600, $true)
