#Credit https://blog.sandro-pereira.com/2020/09/01/how-to-download-a-github-repository-using-powershell/
function DownloadGitHubRepository
{
    param(
       [Parameter(Mandatory=$True)]
       [string] $Name,

       [Parameter(Mandatory=$True)]
       [string] $Author,

       [Parameter(Mandatory=$False)]
       [string] $Branch = "master",

       [Parameter(Mandatory=$False)]
       [string] $Location = "c:\temp"
    )

    # Force to create a zip file
    $ZipFile = "$location\$Name.zip"
    New-Item $ZipFile -ItemType File -Force

    #$RepositoryZipUrl = "https://github.com/sandroasp/Microsoft-Integration-and-Azure-Stencils-Pack-for-Visio/archive/master.zip"
    $RepositoryZipUrl = "https://api.github.com/repos/$Author/$Name/zipball/$Branch"
    # download the zip
    Write-Host 'Starting downloading the GitHub Repository'
    Invoke-RestMethod -Uri $RepositoryZipUrl -OutFile $ZipFile
    Write-Host 'Download finished'

    #Extract Zip File
    Write-Host 'Starting unzipping the GitHub Repository locally'
    Expand-Archive -Path $ZipFile -DestinationPath $location -Force
    Write-Host 'Unzip finished'

    # remove the zip file
    Remove-Item -Path $ZipFile -Force
}

DownloadGitHubRepository -Name awstools -Author bran6437 -Branch main -Location $pwd.Path
