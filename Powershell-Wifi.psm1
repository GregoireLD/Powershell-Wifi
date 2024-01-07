
#region Classes
class Wifi {
	hidden [String] $varSSID
	hidden [String] $varPassword
	hidden [bool] $externalySourcedWifi = $true

	Wifi(){
		$this.Init($NULL, $NULL, $false)
	}

	Wifi([bool] $retreivePassword){
		$this.Init($NULL, $NULL, $retreivePassword)
	}

	Wifi([string] $SSID){
		$this.Init($SSID, $NULL, $false)
	}

	Wifi([string] $SSID, [bool] $retreivePassword){
		$this.Init($SSID, $NULL, $retreivePassword)
	}

	Wifi([string] $SSID,[string] $Password){
		$this.Init($SSID, $Password, $false)
	}

	hidden Init([string] $SSID, [string] $Password, [bool] $retreivePassword) {
        $tmpSSID = $NULL
		$tmpPassword = $NULL
		$tmpExternal = $true

		if(-not $SSID){
			if($global:IsMacOS) {
				$tmpSSID = /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I  | Select-String " SSID:"
				$tmpSSID = $tmpSSID.Tostring().Substring($tmpSSID.Tostring().IndexOf("SSID: ")+"SSID: ".Length)
			} elseif($global:IsWindows) {
				throw "Windows is currently unimplemented"
			} elseif($global:IsLinux) {
				throw "Linux is currently unimplemented"
			} else {
				throw "Current environment could not be identified as either macOS, Windows, nor Linux"
			}
			if(-not $tmpSSID){throw "Could not get current SSID"}
		} else {
			$tmpSSID = $SSID
		}

		$this.varSSID = $tmpSSID

		if(-not $Password){
			if($retreivePassword){
				$tmpExternal = $false
				$tmpPassword = $this.GetPassword()
			} else {
				$tmpPassword = $NULL
			}
		} else {
			$tmpPassword = $Password
			$tmpExternal = $false
		}

		$this.varPassword = $tmpPassword
		$this.externalySourcedWifi = $tmpExternal
    }

	[String] GetSSID(){
		return $this.varSSID
	}

	[String] GetPassword(){
		$tmpPass = ""

		if($this.externalySourcedWifi){
			if($global:IsMacOS) {
				$tmpPass = security find-generic-password -wga $this.varSSID
			} elseif($global:IsWindows) {
				throw "Windows is currently unimplemented"
			} elseif($global:IsLinux) {
				throw "Linux is currently unimplemented"
			} else {
				throw "Current environment could not be identified as either macOS, Windows, nor Linux"
			}
		} else {
			$tmpPass = $this.varPassword
		}

		if(-not $tmpPass){throw "Could not get the Wifi Password for "+$this.varSSID}

		return $tmpPass
	}

	[String] GetEscapedPassword(){
		return $this.GetPassword().Replace("\","\\").Replace(":","\:");
	}

	[String] ToString(){
		return ("WIFI:S:"+$this.GetSSID()+";T:WPA;P:"+$this.GetEscapedPassword()+";;")
	}
}
#endregion Classes

function Get-Wifi {
	[CmdletBinding()]
	param (
		[Parameter(Position=0,mandatory=$true)][string] $SSID="",
		[Parameter(mandatory=$false)][string] $Password="",
		[switch] $retreivePassword=$false
	)

	if($Password -and (-not $SSID)){throw "SSID must be provided if the Password parameter is present"}
	if($Password -and $retreivePassword){Write-Warning "retreivePassword is superfluous if the Password parameter is present"}
	
	$tmpSSID = $SSID
	$tmpPassword = $Password
	[Wifi] $wifi = $NULL

	if(-not $tmpPassword) {
		if(-not $tmpSSID) {
			$wifi = New-Object -TypeName 'Wifi' -ArgumentList @($retreivePassword)
		} else {
			$wifi = New-Object -TypeName 'Wifi' -ArgumentList @($tmpSSID,$retreivePassword)
		}
	} else {
		$wifi = New-Object -TypeName 'Wifi' -ArgumentList @($tmpSSID,$tmpPassword)
	}

	return ($wifi)
}
