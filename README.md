# Powershell-Wifi
Manage stored Wifi Network on macOS, and soon Windows and Linux too.

## Samples :

### Auto-Loading :

To use this module, the "Powershell-Wifi" folder, contaning both the psm1
and the psd1 files, must be in one of your default Powershell Modules folder.
You can check what they are using :

```powershell
Write-Output $env:PSModulePath
```

### Manual Loading :

You can also manually enable it using the folowing command :

```powershell
Import-Module <Path_to_the_Powershell-Wifi.psm1_file>
```

### Passwords :

The resulting object will retreive the password only on a "as-needed" basis, and, if needed, will result in the prompting
of a user password.

ie, on macOS, `$myWifi = Get-Wifi`, won't trigger a password prompt
(because at this point the password is not retrieved), but `Get-Wifi` will,
because the password must be retrieved prior to displaying it.

If you want to retreive the pasword at the time of the creation of the Wifi object, you can use the `-retreivePassword` flag.

### toString() :

The default ToString() returned string is compliant with the format used in QRCodes, including escaping column characters :

```powershell
Get-Wifi -SSID <SSID> -Password <Password>
```
or

```powershell
$myWifi = Get-Wifi -SSID <SSID> -Password <Password>
$myWifi.toString()
```

### More Examples :

#### Getting an object targeting the current Wifi
```powershell
$myWifi = Get-Wifi
```

#### Getting an object targeting the current Wifi with pre-fetched password
```powershell
$myWifi = Get-Wifi -retreivePassword
```

#### Getting an object targeting a specific SSID
```powershell
$myWifi = Get-Wifi -SSID <SSID>
```

#### Getting an object with manually specified SSID and Password
```powershell
$myWifi = Get-Wifi -SSID <SSID> -Password <Password>
```

