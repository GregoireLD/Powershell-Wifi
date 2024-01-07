
#region Classes
class Wifi {
	hidden [String] $varSSID
	hidden [String] $varPassword

	Wifi(){
		$tmpSSID = ""

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

		$this.varSSID = $tmpSSID
	}

	Wifi([string] $SSID){
		$this.varSSID = $SSID
	}

	Wifi([string] $SSID,[string] $Password){
		$this.varSSID = $SSID
		$this.varPassword = $Password
	}

	[String] GetSSID(){
		return $this.varSSID
	}

	[String] GetPassword(){
		$tmpPass = ""

		if($this.varPassword){
			$tmpPass = $this.varPassword
		} else {
			if($global:IsMacOS) {
				$tmpPass = security find-generic-password -wga $this.varSSID
			} elseif($global:IsWindows) {
				throw "Windows is currently unimplemented"
			} elseif($global:IsLinux) {
				throw "Linux is currently unimplemented"
			} else {
				throw "Current environment could not be identified as either macOS, Windows, nor Linux"
			}
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
		[string] $SSID="",
		[string] $Password=""
	)

	if($Password -and (-not $SSID)){throw "SSID must be provided if the Password parameter is present"}
	
	$tmpSSID = $SSID
	$tmpPassword = $Password
	[Wifi] $wifi = $NULL

	if(-not $tmpPassword) {
		if(-not $tmpSSID) {
			$wifi = New-Object -TypeName 'Wifi'
		} else {
			$wifi = New-Object -TypeName 'Wifi' -ArgumentList @($tmpSSID)
		}
	} else {
		$wifi = New-Object -TypeName 'Wifi' -ArgumentList @($tmpSSID,$tmpPassword)
	}

	return ($wifi)
}

