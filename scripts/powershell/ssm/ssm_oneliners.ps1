##############################
# Manually install SSM Agent #
##############################
# Resource: https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-install-win.html
#Download
$progressPreference = 'silentlyContinue'
Invoke-WebRequest https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe ` -OutFile $env:USERPROFILE\Desktop\SSMAgent_latest.exe
#Install
Start-Process -FilePath $env:USERPROFILE\Desktop\SSMAgent_latest.exe -ArgumentList "/S"
#clean up
rm -Force $env:USERPROFILE\Desktop\SSMAgent_latest.exe

###########################
# SSM Proxy Configuration #
###########################
#resource: https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-install-ssm-proxy.html#ssm-agent-proxy-services
# Cnofigure Proxy Config
$serviceKey = "HKLM:\SYSTEM\CurrentControlSet\Services\AmazonSSMAgent"
$keyInfo = (Get-Item -Path $serviceKey).GetValue("Environment")
$proxyVariables = @("http_proxy=hostname:port", "https_proxy=hostname:port", "no_proxy=169.254.169.254")

if ($keyInfo -eq $null) {
    New-ItemProperty -Path $serviceKey -Name Environment -Value $proxyVariables -PropertyType MultiString -Force
}
else {
    Set-ItemProperty -Path $serviceKey -Name Environment -Value $proxyVariables
}
Restart-Service AmazonSSMAgent

#Reset proxy config
Remove-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\AmazonSSMAgent -Name Environment
Restart-Service AmazonSSMAgent
netsh winhttp reset proxy
netsh winhttp show proxy
