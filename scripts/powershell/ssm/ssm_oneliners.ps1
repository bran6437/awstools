#SSM Version ( does not work on SSM versions less than v3.0 )
& "C:\Program Files\Amazon\SSM\amazon-ssm-agent.exe" -version

# set  DNS to use dhcp
Get-WmiObject win32_NetworkAdapterConfiguration -filter 'ipenabled="true"' | %{$_.SetDNSServerSearchOrder()}

#ensure no proxy
netsh winhttp reset proxy;
netsh winhttp show proxy;
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\AmazonSSMAgent" -Name Environment -Value @("http_proxy=","no_proxy=169.254.169.254", "https_proxy=") -PropertyType MultiString -Force;
Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\AmazonSSMAgent | fl DisplayName,Version,Environment

#restart agent
spsv AmazonSSMAgent;sasv AmazonSSMAgent -passthru

#oneliner of all the above
& "C:\Program Files\Amazon\SSM\amazon-ssm-agent.exe" -version;Get-WmiObject win32_NetworkAdapterConfiguration -filter 'ipenabled="true"' | %{$_.SetDNSServerSearchOrder()};netsh winhttp reset proxy;netsh winhttp show proxy;New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\AmazonSSMAgent" -Name Environment -Value @("http_proxy=","no_proxy=169.254.169.254", "https_proxy=") -PropertyType MultiString -Force;Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\AmazonSSMAgent | fl DisplayName,Version,Environment;spsv AmazonSSMAgent;sasv AmazonSSMAgent -passthru


#get logs
# Get SSM Logs Logs
$dateFilter = [datetime]::Now.ToString('yyyy-MM-dd hh');
$logs = gc "$env:ProgramData\Amazon\SSM\Logs\amazon-ssm-agent.log" | ?{$_ -match $dateFilter };$logs


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

