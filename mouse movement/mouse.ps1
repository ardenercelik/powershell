[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$signature=@'
[DllImport("user32.dll",CharSet=CharSet.Auto,CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@

$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru

Function doubleClick
{
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
    sleep -Milliseconds 500
    $SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0);
    $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0);
    $SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0);
    $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0);
}

function singleClick {
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
    sleep -Milliseconds 500
    $SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0);
    $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0);
}


$x = 1714
$y = 51
doubleClick($x, $y)
$x = 1793
$y = 51

doubleClick
$x = 1859
$y = 51

doubleClick
$x = 1180
$y = 111


singleClick
singleClick
singleClick


