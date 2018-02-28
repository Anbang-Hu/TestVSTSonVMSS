# Downloads the Visual Studio Team Services Build Agent and installs on the new machine
# and registers with the Visual Studio Team Services account and build agent pool

# Enable -Verbose option
[CmdletBinding()]
Param(
[Parameter(Mandatory=$true)]$VSTSAccount,
[Parameter(Mandatory=$true)]$PersonalAccessToken,
[Parameter(Mandatory=$true)]$PoolName,
[Parameter(Mandatory=$true)]$VSTSBuildAgentUsername,
[Parameter(Mandatory=$true)]$VSTSBuildAgentPassword
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Set the computer name to be the agentname
$AgentName = $env:ComputerName + "-" + (Get-Date -UFormat "%s")

# Start VSO Agent Install
Write-Verbose "Entering InstallVSTSAgent.ps1" -verbose

$currentLocation = Split-Path -parent $MyInvocation.MyCommand.Definition
Write-Verbose "Current folder: $currentLocation" -verbose

#Create a temporary directory where to download from VSTS the agent package (vsts-agent.zip) and then launch the configuration.
$agentTempFolderName = Join-Path $env:temp ([System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Force -Path $agentTempFolderName
Write-Verbose "Temporary Agent download folder: $agentTempFolderName" -verbose

$serverUrl = "https://$VSTSAccount.visualstudio.com"
Write-Verbose "Server URL: $serverUrl" -verbose

# $retryCount = 3
# $retries = 1
# Write-Verbose "Downloading Agent installation files" -verbose
# do
# {
#   try
#   {
#     Write-Verbose "Trying to get download URL for VSTS agent ..."
#     Invoke-WebRequest -Uri "https://vstsagentpackage.azureedge.net/agent/2.129.1/vsts-agent-win-x64-2.129.1.zip" -OutFile "$agentTempFolderName\agent.zip"
#     Write-Verbose "Downloaded agent successfully on attempt $retries" -verbose
#     break
#   }
#   catch
#   {
#     $exceptionText = ($_ | Out-String).Trim()
#     Write-Verbose "Exception occured downloading agent: $exceptionText in try number $retries" -verbose
#     $retries++
#     Start-Sleep -Seconds 30 
#   }
# } 
# while ($retries -le $retryCount)

# # Construct the agent folder under the main (hardcoded) C: drive.
# $agentInstallationPath = "C:\vsts-agent"
# # Create the directory for this agent.
# New-Item -ItemType Directory -Force -Path $agentInstallationPath

# Push-Location -Path $agentInstallationPath

# Add-Type -AssemblyName System.IO.Compression.FileSystem
# [System.IO.Compression.ZipFile]::ExtractToDirectory("$agentTempFolderName\agent.zip", "$PWD")

# # Call the agent with the configure command and all the options (this creates the settings file) without prompting
# # the user or blocking the cmd execution
# Write-Verbose "Configuring agent" -Verbose

# # Set the current directory to the agent dedicated one previously created.
# Push-Location -Path $agentInstallationPath

# .\config.cmd --unattended --url $serverUrl --auth PAT --token $PersonalAccessToken --pool $PoolName --agent $AgentName --runAsService --windowsLogonAccount $VSTSBuildAgentUsername --windowsLogonPassword $VSTSBuildAgentPassword

# Pop-Location

# Write-Verbose "Agent install output: $LASTEXITCODE" -Verbose

# Write-Verbose "Exiting InstallVSTSAgent.ps1" -Verbose